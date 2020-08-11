/*
 * Copyright 2019 Google LLC
 * Copyright 2019 Mellanox Technologies Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// ARITHMETIC intructions
`DEFINE_B_INSTR(BMATOR, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(BMATXOR, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(BMATFLIP, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(CRC32_D, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(CRC32C_D, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(ADDIWU, I_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(ADDWU, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(SUBWU, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(ADDU_W, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(SUBU_W, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(CLZW, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(CTZW, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(PCNTW, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(CLMULW, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(CLMULRW, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(CLMULHW, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(SHFLW, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(UNSHFLW, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(BDEPW, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(BEXTW, R_FORMAT, ARITHMETIC, RV64B)
`DEFINE_B_INSTR(BFPW, R_FORMAT, ARITHMETIC, RV64B)

// SHIFT intructions
`DEFINE_B_INSTR(SLLIU_W, I_FORMAT, SHIFT, RV64B, UIMM)
`DEFINE_B_INSTR(SLOW, R_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(SROW, R_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(ROLW, R_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(RORW, R_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(SBCLRW, R_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(SBSETW, R_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(SBINVW, R_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(SBEXTW, R_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(GREVW, R_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(SLOIW, I_FORMAT, SHIFT, RV64B, UIMM)
`DEFINE_B_INSTR(SROIW, I_FORMAT, SHIFT, RV64B, UIMM)
`DEFINE_B_INSTR(RORIW, I_FORMAT, SHIFT, RV64B, UIMM)
`DEFINE_B_INSTR(SBCLRIW, I_FORMAT, SHIFT, RV64B, UIMM)
`DEFINE_B_INSTR(SBSETIW, I_FORMAT, SHIFT, RV64B, UIMM)
`DEFINE_B_INSTR(SBINVIW, I_FORMAT, SHIFT, RV64B, UIMM)
`DEFINE_B_INSTR(GREVIW, I_FORMAT, SHIFT, RV64B, UIMM)
`DEFINE_B_INSTR(FSLW, R4_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(FSRW, R4_FORMAT, SHIFT, RV64B)
`DEFINE_B_INSTR(FSRIW, I_FORMAT, SHIFT, RV64B, UIMM)

// LOGICAL instructions
`DEFINE_B_INSTR(GORCW, R_FORMAT, LOGICAL, RV64B)
`DEFINE_B_INSTR(GORCIW, I_FORMAT, LOGICAL, RV64B, UIMM)
`DEFINE_B_INSTR(PACKW, R_FORMAT, LOGICAL, RV64B)
`DEFINE_B_INSTR(PACKUW, R_FORMAT, LOGICAL, RV64B)

