// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// xbar_env_pkg__params generated by `tlgen.py` tool


// List of Xbar device memory map
tl_device_t xbar_devices[$] = '{
    '{"rv_dm__regs", '{
        '{32'h41200000, 32'h41200fff}
    }},
    '{"rv_dm__rom", '{
        '{32'h00010000, 32'h00010fff}
    }},
    '{"rom_ctrl__rom", '{
        '{32'h00008000, 32'h0000bfff}
    }},
    '{"rom_ctrl__regs", '{
        '{32'h411e0000, 32'h411e0fff}
    }},
    '{"ram_main", '{
        '{32'h10000000, 32'h1001ffff}
    }},
    '{"eflash", '{
        '{32'h20000000, 32'h200fffff}
    }},
    '{"peri", '{
        '{32'h40000000, 32'h407fffff}
    }},
    '{"flash_ctrl__core", '{
        '{32'h41000000, 32'h41000fff}
    }},
    '{"flash_ctrl__prim", '{
        '{32'h41008000, 32'h41008fff}
    }},
    '{"hmac", '{
        '{32'h41110000, 32'h41110fff}
    }},
    '{"kmac", '{
        '{32'h41120000, 32'h41120fff}
    }},
    '{"aes", '{
        '{32'h41100000, 32'h41100fff}
    }},
    '{"entropy_src", '{
        '{32'h41160000, 32'h41160fff}
    }},
    '{"csrng", '{
        '{32'h41150000, 32'h41150fff}
    }},
    '{"edn0", '{
        '{32'h41170000, 32'h41170fff}
    }},
    '{"edn1", '{
        '{32'h41180000, 32'h41180fff}
    }},
    '{"rv_plic", '{
        '{32'h41010000, 32'h41010fff}
    }},
    '{"otbn", '{
        '{32'h411d0000, 32'h411dffff}
    }},
    '{"keymgr", '{
        '{32'h41130000, 32'h41130fff}
    }},
    '{"sram_ctrl_main", '{
        '{32'h411c0000, 32'h411c0fff}
}}};

  // List of Xbar hosts
tl_host_t xbar_hosts[$] = '{
    '{"corei", 0, '{
        "rom_ctrl__rom",
        "rv_dm__rom",
        "ram_main",
        "eflash"}}
    ,
    '{"cored", 1, '{
        "rom_ctrl__rom",
        "rom_ctrl__regs",
        "rv_dm__rom",
        "rv_dm__regs",
        "ram_main",
        "eflash",
        "peri",
        "flash_ctrl__core",
        "flash_ctrl__prim",
        "aes",
        "entropy_src",
        "csrng",
        "edn0",
        "edn1",
        "hmac",
        "rv_plic",
        "otbn",
        "keymgr",
        "kmac",
        "sram_ctrl_main"}}
    ,
    '{"rv_dm.sba", 2, '{
        "rom_ctrl__rom",
        "rom_ctrl__regs",
        "rv_dm__regs",
        "ram_main",
        "eflash",
        "peri",
        "flash_ctrl__core",
        "flash_ctrl__prim",
        "aes",
        "entropy_src",
        "csrng",
        "edn0",
        "edn1",
        "hmac",
        "rv_plic",
        "otbn",
        "keymgr",
        "kmac",
        "sram_ctrl_main"}}
};
