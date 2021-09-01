# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

from typing import Dict, List, Optional

from .access import SWAccess, HWAccess
from .clocking import Clocking
from .field import Field
from .lib import (check_keys, check_str, check_name, check_bool,
                  check_list, check_str_list, check_int)
from .params import ReggenParams
from .reg_base import RegBase

import re

REQUIRED_FIELDS = {
    'name': ['s', "name of the register"],
    'desc': ['t', "description of the register"],
    'fields': ['l', "list of register field description groups"]
}

OPTIONAL_FIELDS = {
    'async': [
        's',
        "indicates the register must cross to a different "
        "clock domain before use.  The value shown here "
        "should correspond to one of the module's clocks."
    ],
    'swaccess': [
        's',
        "software access permission to use for "
        "fields that don't specify swaccess"
    ],
    'hwaccess': [
        's',
        "hardware access permission to use for "
        "fields that don't specify hwaccess"
    ],
    'hwext': [
        's',
        "'true' if the register is stored outside "
        "of the register module"
    ],
    'hwqe': [
        's',
        "'true' if hardware uses 'q' enable signal, "
        "which is latched signal of software write pulse."
    ],
    'hwre': [
        's',
        "'true' if hardware uses 're' signal, "
        "which is latched signal of software read pulse."
    ],
    'regwen': [
        's',
        "if register is write-protected by another register, that "
        "register name should be given here. empty-string for no register "
        "write protection"
    ],
    'resval': [
        'd',
        "reset value of full register (default 0)"
    ],
    'tags': [
        's',
        "tags for the register, following the format 'tag_name:item1:item2...'"
    ],
    'shadowed': [
        's',
        "'true' if the register is shadowed"
    ],
    'update_err_alert': [
        's',
        "alert that will be triggered if "
        "this shadowed register has update error"
    ],
    'storage_err_alert': [
        's',
        "alert that will be triggered if "
        "this shadowed register has storage error"
    ]
}


class Register(RegBase):
    '''Code representing a register for reggen'''
    def __init__(self,
                 offset: int,
                 name: str,
                 desc: str,
                 async_name: str,
                 async_clk: object,
                 hwext: bool,
                 hwqe: bool,
                 hwre: bool,
                 regwen: Optional[str],
                 tags: List[str],
                 resval: Optional[int],
                 shadowed: bool,
                 fields: List[Field],
                 update_err_alert: Optional[str],
                 storage_err_alert: Optional[str]):
        super().__init__(offset)
        self.name = name
        self.desc = desc
        self.async_name = async_name
        self.async_clk = async_clk
        self.hwext = hwext
        self.hwqe = hwqe
        self.hwre = hwre
        if self.hwre and not self.hwext:
            raise ValueError('The {} register specifies hwre but not hwext.'
                             .format(self.name))

        self.regwen = regwen
        self.tags = tags

        self.shadowed = shadowed
        pattern = r'^[a-z0-9_]+_shadowed(?:_[0-9]+)?'
        sounds_shadowy = re.match(pattern, self.name.lower())
        if self.shadowed and not sounds_shadowy:
            raise ValueError("Register {} has the shadowed flag but its name "
                             "doesn't end with the _shadowed suffix."
                             .format(self.name))
        elif sounds_shadowy and not self.shadowed:
            raise ValueError("Register {} has a name ending in _shadowed, but "
                             "the shadowed flag is not set."
                             .format(self.name))

        # Take a copy of fields and then sort by bit index
        assert fields
        self.fields = fields.copy()
        self.fields.sort(key=lambda field: field.bits.lsb)

        # Index fields by name and check for duplicates
        self.name_to_field = {}  # type: Dict[str, Field]
        for field in self.fields:
            if field.name in self.name_to_field:
                raise ValueError('Register {} has duplicate fields called {}.'
                                 .format(self.name, field.name))
            self.name_to_field[field.name] = field

        # Check that fields have compatible access types if we are hwext
        if self.hwext:
            for field in self.fields:
                if field.hwaccess.key == 'hro' and field.sw_readable():
                    raise ValueError('The {} register has hwext set, but '
                                     'field {} has hro hwaccess and the '
                                     'field value is readable by software '
                                     'mode ({}).'
                                     .format(self.name,
                                             field.name,
                                             field.swaccess.key))
                if not self.hwqe and field.sw_writable():
                    raise ValueError('The {} register has hwext set and field '
                                     '{} is writable by software (mode {}), '
                                     'so the register must also enable hwqe.'
                                     .format(self.name,
                                             field.name,
                                             field.swaccess.key))

        # Check that field bits are disjoint
        bits_used = 0
        for field in self.fields:
            field_mask = field.bits.bitmask()
            if bits_used & field_mask:
                raise ValueError('Register {} has non-disjoint fields: '
                                 '{} uses bits {:#x} used by other fields.'
                                 .format(self.name, field.name,
                                         bits_used & field_mask))

        # Compute a reset value and mask from our constituent fields.
        self.resval = 0
        self.resmask = 0
        for field in self.fields:
            self.resval |= (field.resval or 0) << field.bits.lsb
            self.resmask |= field.bits.bitmask()

        # If the register defined a reset value, make sure it matches. We've
        # already checked that each field matches, but we still need to make
        # sure there weren't any bits unaccounted for.
        if resval is not None and self.resval != resval:
            raise ValueError('Register {} specifies a reset value of {:#x} but '
                             'collecting reset values across its fields yields '
                             '{:#x}.'
                             .format(self.name, resval, self.resval))

        self.update_err_alert = update_err_alert
        self.storage_err_alert = storage_err_alert

    @staticmethod
    def from_raw(reg_width: int,
                 offset: int,
                 params: ReggenParams,
                 raw: object,
                 clocks: Clocking) -> 'Register':
        rd = check_keys(raw, 'register',
                        list(REQUIRED_FIELDS.keys()),
                        list(OPTIONAL_FIELDS.keys()))

        name = check_name(rd['name'], 'name of register')
        desc = check_str(rd['desc'], 'desc for {} register'.format(name))

        async_name = check_str(rd.get('async', ''), 'async clock for {} register'.format(name))
        async_clk = None

        if async_name:
            valid_clocks = clocks.clock_signals()
            if async_name not in valid_clocks:
                raise ValueError('async clock {} defined for {} does not exist '
                                 'in valid module clocks {}.'
                                 .format(async_name,
                                         name,
                                         valid_clocks))
            else:
                async_clk = clocks.get_by_clock(async_name)

        swaccess = SWAccess('{} register'.format(name),
                            rd.get('swaccess', 'none'))
        hwaccess = HWAccess('{} register'.format(name),
                            rd.get('hwaccess', 'hro'))

        hwext = check_bool(rd.get('hwext', False),
                           'hwext flag for {} register'.format(name))

        hwqe = check_bool(rd.get('hwqe', False),
                          'hwqe flag for {} register'.format(name))

        hwre = check_bool(rd.get('hwre', False),
                          'hwre flag for {} register'.format(name))

        raw_regwen = rd.get('regwen', '')
        if not raw_regwen:
            regwen = None
        else:
            regwen = check_name(raw_regwen,
                                'regwen for {} register'.format(name))

        tags = check_str_list(rd.get('tags', []),
                              'tags for {} register'.format(name))

        raw_resval = rd.get('resval')
        if raw_resval is None:
            resval = None
        else:
            resval = check_int(raw_resval,
                               'resval for {} register'.format(name))
            if not 0 <= resval < (1 << reg_width):
                raise ValueError('resval for {} register is {}, '
                                 'not an unsigned {}-bit number.'
                                 .format(name, resval, reg_width))

        shadowed = check_bool(rd.get('shadowed', False),
                              'shadowed flag for {} register'
                              .format(name))

        if async_name and shadowed:
            raise ValueError(f'{name} is defined as async and shadowed. '
                             'This is currently not supported. Please file '
                             'an issue against OpenTitan if this is needed.')

        raw_fields = check_list(rd['fields'],
                                'fields for {} register'.format(name))
        if not raw_fields:
            raise ValueError('Register {} has no fields.'.format(name))
        fields = [Field.from_raw(name,
                                 idx,
                                 len(raw_fields),
                                 swaccess,
                                 hwaccess,
                                 resval,
                                 reg_width,
                                 params,
                                 hwext,
                                 shadowed,
                                 rf)
                  for idx, rf in enumerate(raw_fields)]

        raw_uea = rd.get('update_err_alert')
        if raw_uea is None:
            update_err_alert = None
        else:
            update_err_alert = check_name(raw_uea,
                                          'update_err_alert for {} register'
                                          .format(name))

        raw_sea = rd.get('storage_err_alert')
        if raw_sea is None:
            storage_err_alert = None
        else:
            storage_err_alert = check_name(raw_sea,
                                           'storage_err_alert for {} register'
                                           .format(name))

        return Register(offset, name, desc, async_name, async_clk,
                        hwext, hwqe, hwre, regwen,
                        tags, resval, shadowed, fields,
                        update_err_alert, storage_err_alert)

    def next_offset(self, addrsep: int) -> int:
        return self.offset + addrsep

    def get_n_bits(self, bittype: List[str]) -> int:
        return sum(field.get_n_bits(self.hwext, self.hwqe, self.hwre, bittype)
                   for field in self.fields)

    def get_field_list(self) -> List[Field]:
        return self.fields

    def is_homogeneous(self) -> bool:
        return len(self.fields) == 1

    def is_hw_writable(self) -> bool:
        '''Returns true if any field in this register can be modified by HW'''
        for fld in self.fields:
            if fld.hwaccess.allows_write():
                return True
        return False

    def get_width(self) -> int:
        '''Get the width of the fields in the register in bits

        This counts dead space between and below fields, so it's calculated as
        one more than the highest msb.

        '''
        # self.fields is ordered by (increasing) LSB, so we can find the MSB of
        # the register by taking the MSB of the last field.
        return 1 + self.fields[-1].bits.msb

    def needs_we(self) -> bool:
        '''Return true if at least one field needs a write-enable'''
        for fld in self.fields:
            if fld.swaccess.needs_we():
                return True
        return False

    def needs_re(self) -> bool:
        '''Return true if at least one field needs a read-enable

        This is true if any of the following are true:

          - There's an RC field (where we'll attach the read-enable signal to
            the subreg's we port)

          - The register is hwext and allows reads (in which case the hardware
            side might need the re signal)

          - The register is shadowed and allows reads (because shadow registers
            need to know about reads)
        '''
        for fld in self.fields:
            if fld.swaccess.key == 'rc':
                return True

            if fld.swaccess.allows_read():
                if self.hwext:
                    return True

                if self.shadowed:
                    return True

        return False

    def make_multi(self,
                   reg_width: int,
                   offset: int,
                   creg_idx: int,
                   creg_count: int,
                   regwen_multi: bool,
                   compact: bool,
                   min_reg_idx: int,
                   max_reg_idx: int,
                   cname: str) -> 'Register':
        '''Generate a numbered, packed version of the register'''
        assert 0 <= creg_idx < creg_count
        assert 0 <= min_reg_idx <= max_reg_idx
        assert compact or (min_reg_idx == max_reg_idx)

        new_name = ('{}_{}'.format(self.name, creg_idx)
                    if creg_count > 1
                    else self.name)

        if self.regwen is None or not regwen_multi or creg_count == 1:
            new_regwen = self.regwen
        else:
            new_regwen = '{}_{}'.format(self.regwen, creg_idx)

        strip_field = creg_idx > 0

        if compact:
            # Compacting multiple registers into a single "compacted" register.
            # This is only supported if we have exactly one field (checked at
            # the call-site)
            assert len(self.fields) == 1
            new_fields = self.fields[0].make_multi(reg_width,
                                                   min_reg_idx, max_reg_idx,
                                                   cname, creg_idx,
                                                   strip_field)
        else:
            # No compacting going on, but we still choose to rename the fields
            # to match the registers
            assert creg_idx == min_reg_idx
            new_fields = [field.make_suffixed('_{}'.format(creg_idx),
                                              cname, creg_idx, strip_field)
                          for field in self.fields]

        # Don't specify a reset value for the new register. Any reset value
        # defined for the original register will have propagated to its fields,
        # so when we combine them here, the Register constructor can compute a
        # reset value for us (which might well be different from self.resval if
        # we've replicated fields).
        new_resval = None

        return Register(offset, new_name, self.desc, self.async_name, self.async_clk,
                        self.hwext, self.hwqe, self.hwre, new_regwen,
                        self.tags, new_resval, self.shadowed, new_fields,
                        self.update_err_alert, self.storage_err_alert)

    def check_valid_regwen(self) -> None:
        '''Check that this register is valid for use as a REGWEN'''
        # A REGWEN register should have a single field that's just bit zero.
        if len(self.fields) != 1:
            raise ValueError('One or more registers use {} as a '
                             'write-enable so it should have exactly one '
                             'field. It actually has {}.'
                             .format(self.name, len(self.fields)))

        wen_fld = self.fields[0]
        if wen_fld.bits.width() != 1:
            raise ValueError('One or more registers use {} as a '
                             'write-enable so its field should be 1 bit wide, '
                             'not {}.'
                             .format(self.name, wen_fld.bits.width()))
        if wen_fld.bits.lsb != 0:
            raise ValueError('One or more registers use {} as a '
                             'write-enable so its field should have LSB 0, '
                             'not {}.'
                             .format(self.name, wen_fld.bits.lsb))

        # If the REGWEN bit is SW controlled, check that the register
        # defaults to enabled. If this bit is read-only by SW and hence
        # hardware controlled, we do not enforce this requirement.
        if wen_fld.swaccess.key != "ro" and not self.resval:
            raise ValueError('One or more registers use {} as a '
                             'write-enable. Since it is SW-controlled '
                             'it should have a nonzero reset value.'
                             .format(self.name))

        if wen_fld.swaccess.key == "rw0c":
            # The register is software managed: all good!
            return

        if wen_fld.swaccess.key == "ro" and wen_fld.hwaccess.key == "hwo":
            # The register is hardware managed: that's fine too.
            return

        raise ValueError('One or more registers use {} as a write-enable. '
                         'However, its field has invalid access permissions '
                         '({} / {}). It should either have swaccess=RW0C '
                         'or have swaccess=RO and hwaccess=HWO.'
                         .format(self.name,
                                 wen_fld.swaccess.key,
                                 wen_fld.hwaccess.key))

    def bitmask(self) -> str:
        reg_bitmask = 0
        for f in self.fields:
            reg_bitmask |= f.bits.bitmask()

        return format(reg_bitmask, "x")

    def _asdict(self) -> Dict[str, object]:
        rd = {
            'name': self.name,
            'desc': self.desc,
            'fields': self.fields,
            'hwext': str(self.hwext),
            'hwqe': str(self.hwqe),
            'hwre': str(self.hwre),
            'tags': self.tags,
            'shadowed': str(self.shadowed),
        }
        if self.regwen is not None:
            rd['regwen'] = self.regwen
        if self.update_err_alert is not None:
            rd['update_err_alert'] = self.update_err_alert
        if self.storage_err_alert is not None:
            rd['storage_err_alert'] = self.storage_err_alert

        return rd
