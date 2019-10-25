// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package alert_handler_reg_pkg;

  // Param list
  localparam int NAlerts = 1;
  localparam int EscCntDw = 32;
  localparam int AccuCntDw = 16;
  localparam int LfsrSeed = 2147483647;
  localparam logic [NAlerts-1:0] AsyncOn = 1'b0;
  localparam int N_CLASSES = 4;
  localparam int N_ESC_SEV = 4;
  localparam int N_PHASES = 4;
  localparam int N_LOC_ALERT = 4;
  localparam int PING_CNT_DW = 24;
  localparam int PHASE_DW = 2;
  localparam int CLASS_DW = 2;

////////////////////////////
// Typedefs for multiregs //
////////////////////////////

typedef struct packed {
  logic [0:0] q;
} alert_handler_reg2hw_alert_en_mreg_t;
typedef struct packed {
  logic [1:0] q;
} alert_handler_reg2hw_alert_class_mreg_t;
typedef struct packed {
  logic [0:0] q;
} alert_handler_reg2hw_alert_cause_mreg_t;
typedef struct packed {
  logic [0:0] q;
} alert_handler_reg2hw_loc_alert_en_mreg_t;
typedef struct packed {
  logic [1:0] q;
} alert_handler_reg2hw_loc_alert_class_mreg_t;
typedef struct packed {
  logic [0:0] q;
} alert_handler_reg2hw_loc_alert_cause_mreg_t;

typedef struct packed {
  logic [0:0] d;
  logic de;
} alert_handler_hw2reg_alert_cause_mreg_t;
typedef struct packed {
  logic [0:0] d;
  logic de;
} alert_handler_hw2reg_loc_alert_cause_mreg_t;

///////////////////////////////////////
// Register to internal design logic //
///////////////////////////////////////

typedef struct packed {
  struct packed {
    struct packed {
      logic q; // [828]
    } classa;
    struct packed {
      logic q; // [827]
    } classb;
    struct packed {
      logic q; // [826]
    } classc;
    struct packed {
      logic q; // [825]
    } classd;
  } intr_state;
  struct packed {
    struct packed {
      logic q; // [824]
    } classa;
    struct packed {
      logic q; // [823]
    } classb;
    struct packed {
      logic q; // [822]
    } classc;
    struct packed {
      logic q; // [821]
    } classd;
  } intr_enable;
  struct packed {
    struct packed {
      logic q; // [820]
      logic qe; // [819]
    } classa;
    struct packed {
      logic q; // [818]
      logic qe; // [817]
    } classb;
    struct packed {
      logic q; // [816]
      logic qe; // [815]
    } classc;
    struct packed {
      logic q; // [814]
      logic qe; // [813]
    } classd;
  } intr_test;
  struct packed {
    logic [0:0] q; // [812:812]
  } regen;
  struct packed {
    logic [23:0] q; // [811:788]
  } ping_timeout_cyc;
  alert_handler_reg2hw_alert_en_mreg_t [0:0] alert_en; // [787:787]
  alert_handler_reg2hw_alert_class_mreg_t [0:0] alert_class; // [786:785]
  alert_handler_reg2hw_alert_cause_mreg_t [0:0] alert_cause; // [784:784]
  alert_handler_reg2hw_loc_alert_en_mreg_t [3:0] loc_alert_en; // [783:780]
  alert_handler_reg2hw_loc_alert_class_mreg_t [3:0] loc_alert_class; // [779:772]
  alert_handler_reg2hw_loc_alert_cause_mreg_t [3:0] loc_alert_cause; // [771:768]
  struct packed {
    struct packed {
      logic q; // [767]
    } en;
    struct packed {
      logic q; // [766]
    } lock;
    struct packed {
      logic q; // [765]
    } en_e0;
    struct packed {
      logic q; // [764]
    } en_e1;
    struct packed {
      logic q; // [763]
    } en_e2;
    struct packed {
      logic q; // [762]
    } en_e3;
    struct packed {
      logic [1:0] q; // [761:760]
    } map_e0;
    struct packed {
      logic [1:0] q; // [759:758]
    } map_e1;
    struct packed {
      logic [1:0] q; // [757:756]
    } map_e2;
    struct packed {
      logic [1:0] q; // [755:754]
    } map_e3;
  } classa_ctrl;
  struct packed {
    logic [0:0] q; // [753:753]
    logic qe; // [752]
  } classa_clr;
  struct packed {
    logic [15:0] q; // [751:736]
  } classa_accum_thresh;
  struct packed {
    logic [31:0] q; // [735:704]
  } classa_timeout_cyc;
  struct packed {
    logic [31:0] q; // [703:672]
  } classa_phase0_cyc;
  struct packed {
    logic [31:0] q; // [671:640]
  } classa_phase1_cyc;
  struct packed {
    logic [31:0] q; // [639:608]
  } classa_phase2_cyc;
  struct packed {
    logic [31:0] q; // [607:576]
  } classa_phase3_cyc;
  struct packed {
    struct packed {
      logic q; // [575]
    } en;
    struct packed {
      logic q; // [574]
    } lock;
    struct packed {
      logic q; // [573]
    } en_e0;
    struct packed {
      logic q; // [572]
    } en_e1;
    struct packed {
      logic q; // [571]
    } en_e2;
    struct packed {
      logic q; // [570]
    } en_e3;
    struct packed {
      logic [1:0] q; // [569:568]
    } map_e0;
    struct packed {
      logic [1:0] q; // [567:566]
    } map_e1;
    struct packed {
      logic [1:0] q; // [565:564]
    } map_e2;
    struct packed {
      logic [1:0] q; // [563:562]
    } map_e3;
  } classb_ctrl;
  struct packed {
    logic [0:0] q; // [561:561]
    logic qe; // [560]
  } classb_clr;
  struct packed {
    logic [15:0] q; // [559:544]
  } classb_accum_thresh;
  struct packed {
    logic [31:0] q; // [543:512]
  } classb_timeout_cyc;
  struct packed {
    logic [31:0] q; // [511:480]
  } classb_phase0_cyc;
  struct packed {
    logic [31:0] q; // [479:448]
  } classb_phase1_cyc;
  struct packed {
    logic [31:0] q; // [447:416]
  } classb_phase2_cyc;
  struct packed {
    logic [31:0] q; // [415:384]
  } classb_phase3_cyc;
  struct packed {
    struct packed {
      logic q; // [383]
    } en;
    struct packed {
      logic q; // [382]
    } lock;
    struct packed {
      logic q; // [381]
    } en_e0;
    struct packed {
      logic q; // [380]
    } en_e1;
    struct packed {
      logic q; // [379]
    } en_e2;
    struct packed {
      logic q; // [378]
    } en_e3;
    struct packed {
      logic [1:0] q; // [377:376]
    } map_e0;
    struct packed {
      logic [1:0] q; // [375:374]
    } map_e1;
    struct packed {
      logic [1:0] q; // [373:372]
    } map_e2;
    struct packed {
      logic [1:0] q; // [371:370]
    } map_e3;
  } classc_ctrl;
  struct packed {
    logic [0:0] q; // [369:369]
    logic qe; // [368]
  } classc_clr;
  struct packed {
    logic [15:0] q; // [367:352]
  } classc_accum_thresh;
  struct packed {
    logic [31:0] q; // [351:320]
  } classc_timeout_cyc;
  struct packed {
    logic [31:0] q; // [319:288]
  } classc_phase0_cyc;
  struct packed {
    logic [31:0] q; // [287:256]
  } classc_phase1_cyc;
  struct packed {
    logic [31:0] q; // [255:224]
  } classc_phase2_cyc;
  struct packed {
    logic [31:0] q; // [223:192]
  } classc_phase3_cyc;
  struct packed {
    struct packed {
      logic q; // [191]
    } en;
    struct packed {
      logic q; // [190]
    } lock;
    struct packed {
      logic q; // [189]
    } en_e0;
    struct packed {
      logic q; // [188]
    } en_e1;
    struct packed {
      logic q; // [187]
    } en_e2;
    struct packed {
      logic q; // [186]
    } en_e3;
    struct packed {
      logic [1:0] q; // [185:184]
    } map_e0;
    struct packed {
      logic [1:0] q; // [183:182]
    } map_e1;
    struct packed {
      logic [1:0] q; // [181:180]
    } map_e2;
    struct packed {
      logic [1:0] q; // [179:178]
    } map_e3;
  } classd_ctrl;
  struct packed {
    logic [0:0] q; // [177:177]
    logic qe; // [176]
  } classd_clr;
  struct packed {
    logic [15:0] q; // [175:160]
  } classd_accum_thresh;
  struct packed {
    logic [31:0] q; // [159:128]
  } classd_timeout_cyc;
  struct packed {
    logic [31:0] q; // [127:96]
  } classd_phase0_cyc;
  struct packed {
    logic [31:0] q; // [95:64]
  } classd_phase1_cyc;
  struct packed {
    logic [31:0] q; // [63:32]
  } classd_phase2_cyc;
  struct packed {
    logic [31:0] q; // [31:0]
  } classd_phase3_cyc;
} alert_handler_reg2hw_t;

///////////////////////////////////////
// Internal design logic to register //
///////////////////////////////////////

typedef struct packed {
  struct packed {
    struct packed {
      logic d; // [229]
      logic de; // [228]
    } classa;
    struct packed {
      logic d; // [227]
      logic de; // [226]
    } classb;
    struct packed {
      logic d; // [225]
      logic de; // [224]
    } classc;
    struct packed {
      logic d; // [223]
      logic de; // [222]
    } classd;
  } intr_state;
  alert_handler_hw2reg_alert_cause_mreg_t [0:0] alert_cause; // [221:220]
  alert_handler_hw2reg_loc_alert_cause_mreg_t [3:0] loc_alert_cause; // [219:212]
  struct packed {
    logic [0:0] d; // [211:211]
    logic de; // [210]
  } classa_clren;
  struct packed {
    logic [15:0] d; // [209:194]
  } classa_accum_cnt;
  struct packed {
    logic [31:0] d; // [193:162]
  } classa_esc_cnt;
  struct packed {
    logic [2:0] d; // [161:159]
  } classa_state;
  struct packed {
    logic [0:0] d; // [158:158]
    logic de; // [157]
  } classb_clren;
  struct packed {
    logic [15:0] d; // [156:141]
  } classb_accum_cnt;
  struct packed {
    logic [31:0] d; // [140:109]
  } classb_esc_cnt;
  struct packed {
    logic [2:0] d; // [108:106]
  } classb_state;
  struct packed {
    logic [0:0] d; // [105:105]
    logic de; // [104]
  } classc_clren;
  struct packed {
    logic [15:0] d; // [103:88]
  } classc_accum_cnt;
  struct packed {
    logic [31:0] d; // [87:56]
  } classc_esc_cnt;
  struct packed {
    logic [2:0] d; // [55:53]
  } classc_state;
  struct packed {
    logic [0:0] d; // [52:52]
    logic de; // [51]
  } classd_clren;
  struct packed {
    logic [15:0] d; // [50:35]
  } classd_accum_cnt;
  struct packed {
    logic [31:0] d; // [34:3]
  } classd_esc_cnt;
  struct packed {
    logic [2:0] d; // [2:0]
  } classd_state;
} alert_handler_hw2reg_t;

  // Register Address
  parameter ALERT_HANDLER_INTR_STATE_OFFSET = 8'h 0;
  parameter ALERT_HANDLER_INTR_ENABLE_OFFSET = 8'h 4;
  parameter ALERT_HANDLER_INTR_TEST_OFFSET = 8'h 8;
  parameter ALERT_HANDLER_REGEN_OFFSET = 8'h c;
  parameter ALERT_HANDLER_PING_TIMEOUT_CYC_OFFSET = 8'h 10;
  parameter ALERT_HANDLER_ALERT_EN_OFFSET = 8'h 14;
  parameter ALERT_HANDLER_ALERT_CLASS_OFFSET = 8'h 18;
  parameter ALERT_HANDLER_ALERT_CAUSE_OFFSET = 8'h 1c;
  parameter ALERT_HANDLER_LOC_ALERT_EN_OFFSET = 8'h 20;
  parameter ALERT_HANDLER_LOC_ALERT_CLASS_OFFSET = 8'h 24;
  parameter ALERT_HANDLER_LOC_ALERT_CAUSE_OFFSET = 8'h 28;
  parameter ALERT_HANDLER_CLASSA_CTRL_OFFSET = 8'h 2c;
  parameter ALERT_HANDLER_CLASSA_CLREN_OFFSET = 8'h 30;
  parameter ALERT_HANDLER_CLASSA_CLR_OFFSET = 8'h 34;
  parameter ALERT_HANDLER_CLASSA_ACCUM_CNT_OFFSET = 8'h 38;
  parameter ALERT_HANDLER_CLASSA_ACCUM_THRESH_OFFSET = 8'h 3c;
  parameter ALERT_HANDLER_CLASSA_TIMEOUT_CYC_OFFSET = 8'h 40;
  parameter ALERT_HANDLER_CLASSA_PHASE0_CYC_OFFSET = 8'h 44;
  parameter ALERT_HANDLER_CLASSA_PHASE1_CYC_OFFSET = 8'h 48;
  parameter ALERT_HANDLER_CLASSA_PHASE2_CYC_OFFSET = 8'h 4c;
  parameter ALERT_HANDLER_CLASSA_PHASE3_CYC_OFFSET = 8'h 50;
  parameter ALERT_HANDLER_CLASSA_ESC_CNT_OFFSET = 8'h 54;
  parameter ALERT_HANDLER_CLASSA_STATE_OFFSET = 8'h 58;
  parameter ALERT_HANDLER_CLASSB_CTRL_OFFSET = 8'h 5c;
  parameter ALERT_HANDLER_CLASSB_CLREN_OFFSET = 8'h 60;
  parameter ALERT_HANDLER_CLASSB_CLR_OFFSET = 8'h 64;
  parameter ALERT_HANDLER_CLASSB_ACCUM_CNT_OFFSET = 8'h 68;
  parameter ALERT_HANDLER_CLASSB_ACCUM_THRESH_OFFSET = 8'h 6c;
  parameter ALERT_HANDLER_CLASSB_TIMEOUT_CYC_OFFSET = 8'h 70;
  parameter ALERT_HANDLER_CLASSB_PHASE0_CYC_OFFSET = 8'h 74;
  parameter ALERT_HANDLER_CLASSB_PHASE1_CYC_OFFSET = 8'h 78;
  parameter ALERT_HANDLER_CLASSB_PHASE2_CYC_OFFSET = 8'h 7c;
  parameter ALERT_HANDLER_CLASSB_PHASE3_CYC_OFFSET = 8'h 80;
  parameter ALERT_HANDLER_CLASSB_ESC_CNT_OFFSET = 8'h 84;
  parameter ALERT_HANDLER_CLASSB_STATE_OFFSET = 8'h 88;
  parameter ALERT_HANDLER_CLASSC_CTRL_OFFSET = 8'h 8c;
  parameter ALERT_HANDLER_CLASSC_CLREN_OFFSET = 8'h 90;
  parameter ALERT_HANDLER_CLASSC_CLR_OFFSET = 8'h 94;
  parameter ALERT_HANDLER_CLASSC_ACCUM_CNT_OFFSET = 8'h 98;
  parameter ALERT_HANDLER_CLASSC_ACCUM_THRESH_OFFSET = 8'h 9c;
  parameter ALERT_HANDLER_CLASSC_TIMEOUT_CYC_OFFSET = 8'h a0;
  parameter ALERT_HANDLER_CLASSC_PHASE0_CYC_OFFSET = 8'h a4;
  parameter ALERT_HANDLER_CLASSC_PHASE1_CYC_OFFSET = 8'h a8;
  parameter ALERT_HANDLER_CLASSC_PHASE2_CYC_OFFSET = 8'h ac;
  parameter ALERT_HANDLER_CLASSC_PHASE3_CYC_OFFSET = 8'h b0;
  parameter ALERT_HANDLER_CLASSC_ESC_CNT_OFFSET = 8'h b4;
  parameter ALERT_HANDLER_CLASSC_STATE_OFFSET = 8'h b8;
  parameter ALERT_HANDLER_CLASSD_CTRL_OFFSET = 8'h bc;
  parameter ALERT_HANDLER_CLASSD_CLREN_OFFSET = 8'h c0;
  parameter ALERT_HANDLER_CLASSD_CLR_OFFSET = 8'h c4;
  parameter ALERT_HANDLER_CLASSD_ACCUM_CNT_OFFSET = 8'h c8;
  parameter ALERT_HANDLER_CLASSD_ACCUM_THRESH_OFFSET = 8'h cc;
  parameter ALERT_HANDLER_CLASSD_TIMEOUT_CYC_OFFSET = 8'h d0;
  parameter ALERT_HANDLER_CLASSD_PHASE0_CYC_OFFSET = 8'h d4;
  parameter ALERT_HANDLER_CLASSD_PHASE1_CYC_OFFSET = 8'h d8;
  parameter ALERT_HANDLER_CLASSD_PHASE2_CYC_OFFSET = 8'h dc;
  parameter ALERT_HANDLER_CLASSD_PHASE3_CYC_OFFSET = 8'h e0;
  parameter ALERT_HANDLER_CLASSD_ESC_CNT_OFFSET = 8'h e4;
  parameter ALERT_HANDLER_CLASSD_STATE_OFFSET = 8'h e8;


  // Register Index
  typedef enum int {
    ALERT_HANDLER_INTR_STATE,
    ALERT_HANDLER_INTR_ENABLE,
    ALERT_HANDLER_INTR_TEST,
    ALERT_HANDLER_REGEN,
    ALERT_HANDLER_PING_TIMEOUT_CYC,
    ALERT_HANDLER_ALERT_EN,
    ALERT_HANDLER_ALERT_CLASS,
    ALERT_HANDLER_ALERT_CAUSE,
    ALERT_HANDLER_LOC_ALERT_EN,
    ALERT_HANDLER_LOC_ALERT_CLASS,
    ALERT_HANDLER_LOC_ALERT_CAUSE,
    ALERT_HANDLER_CLASSA_CTRL,
    ALERT_HANDLER_CLASSA_CLREN,
    ALERT_HANDLER_CLASSA_CLR,
    ALERT_HANDLER_CLASSA_ACCUM_CNT,
    ALERT_HANDLER_CLASSA_ACCUM_THRESH,
    ALERT_HANDLER_CLASSA_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSA_PHASE0_CYC,
    ALERT_HANDLER_CLASSA_PHASE1_CYC,
    ALERT_HANDLER_CLASSA_PHASE2_CYC,
    ALERT_HANDLER_CLASSA_PHASE3_CYC,
    ALERT_HANDLER_CLASSA_ESC_CNT,
    ALERT_HANDLER_CLASSA_STATE,
    ALERT_HANDLER_CLASSB_CTRL,
    ALERT_HANDLER_CLASSB_CLREN,
    ALERT_HANDLER_CLASSB_CLR,
    ALERT_HANDLER_CLASSB_ACCUM_CNT,
    ALERT_HANDLER_CLASSB_ACCUM_THRESH,
    ALERT_HANDLER_CLASSB_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSB_PHASE0_CYC,
    ALERT_HANDLER_CLASSB_PHASE1_CYC,
    ALERT_HANDLER_CLASSB_PHASE2_CYC,
    ALERT_HANDLER_CLASSB_PHASE3_CYC,
    ALERT_HANDLER_CLASSB_ESC_CNT,
    ALERT_HANDLER_CLASSB_STATE,
    ALERT_HANDLER_CLASSC_CTRL,
    ALERT_HANDLER_CLASSC_CLREN,
    ALERT_HANDLER_CLASSC_CLR,
    ALERT_HANDLER_CLASSC_ACCUM_CNT,
    ALERT_HANDLER_CLASSC_ACCUM_THRESH,
    ALERT_HANDLER_CLASSC_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSC_PHASE0_CYC,
    ALERT_HANDLER_CLASSC_PHASE1_CYC,
    ALERT_HANDLER_CLASSC_PHASE2_CYC,
    ALERT_HANDLER_CLASSC_PHASE3_CYC,
    ALERT_HANDLER_CLASSC_ESC_CNT,
    ALERT_HANDLER_CLASSC_STATE,
    ALERT_HANDLER_CLASSD_CTRL,
    ALERT_HANDLER_CLASSD_CLREN,
    ALERT_HANDLER_CLASSD_CLR,
    ALERT_HANDLER_CLASSD_ACCUM_CNT,
    ALERT_HANDLER_CLASSD_ACCUM_THRESH,
    ALERT_HANDLER_CLASSD_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSD_PHASE0_CYC,
    ALERT_HANDLER_CLASSD_PHASE1_CYC,
    ALERT_HANDLER_CLASSD_PHASE2_CYC,
    ALERT_HANDLER_CLASSD_PHASE3_CYC,
    ALERT_HANDLER_CLASSD_ESC_CNT,
    ALERT_HANDLER_CLASSD_STATE
  } alert_handler_id_e;

  // Register width information to check illegal writes
  localparam logic [3:0] ALERT_HANDLER_PERMIT [59] = '{
    4'b 0001, // index[ 0] ALERT_HANDLER_INTR_STATE
    4'b 0001, // index[ 1] ALERT_HANDLER_INTR_ENABLE
    4'b 0001, // index[ 2] ALERT_HANDLER_INTR_TEST
    4'b 0001, // index[ 3] ALERT_HANDLER_REGEN
    4'b 0111, // index[ 4] ALERT_HANDLER_PING_TIMEOUT_CYC
    4'b 0001, // index[ 5] ALERT_HANDLER_ALERT_EN
    4'b 0001, // index[ 6] ALERT_HANDLER_ALERT_CLASS
    4'b 0001, // index[ 7] ALERT_HANDLER_ALERT_CAUSE
    4'b 0001, // index[ 8] ALERT_HANDLER_LOC_ALERT_EN
    4'b 0001, // index[ 9] ALERT_HANDLER_LOC_ALERT_CLASS
    4'b 0001, // index[10] ALERT_HANDLER_LOC_ALERT_CAUSE
    4'b 0011, // index[11] ALERT_HANDLER_CLASSA_CTRL
    4'b 0001, // index[12] ALERT_HANDLER_CLASSA_CLREN
    4'b 0001, // index[13] ALERT_HANDLER_CLASSA_CLR
    4'b 0011, // index[14] ALERT_HANDLER_CLASSA_ACCUM_CNT
    4'b 0011, // index[15] ALERT_HANDLER_CLASSA_ACCUM_THRESH
    4'b 1111, // index[16] ALERT_HANDLER_CLASSA_TIMEOUT_CYC
    4'b 1111, // index[17] ALERT_HANDLER_CLASSA_PHASE0_CYC
    4'b 1111, // index[18] ALERT_HANDLER_CLASSA_PHASE1_CYC
    4'b 1111, // index[19] ALERT_HANDLER_CLASSA_PHASE2_CYC
    4'b 1111, // index[20] ALERT_HANDLER_CLASSA_PHASE3_CYC
    4'b 1111, // index[21] ALERT_HANDLER_CLASSA_ESC_CNT
    4'b 0001, // index[22] ALERT_HANDLER_CLASSA_STATE
    4'b 0011, // index[23] ALERT_HANDLER_CLASSB_CTRL
    4'b 0001, // index[24] ALERT_HANDLER_CLASSB_CLREN
    4'b 0001, // index[25] ALERT_HANDLER_CLASSB_CLR
    4'b 0011, // index[26] ALERT_HANDLER_CLASSB_ACCUM_CNT
    4'b 0011, // index[27] ALERT_HANDLER_CLASSB_ACCUM_THRESH
    4'b 1111, // index[28] ALERT_HANDLER_CLASSB_TIMEOUT_CYC
    4'b 1111, // index[29] ALERT_HANDLER_CLASSB_PHASE0_CYC
    4'b 1111, // index[30] ALERT_HANDLER_CLASSB_PHASE1_CYC
    4'b 1111, // index[31] ALERT_HANDLER_CLASSB_PHASE2_CYC
    4'b 1111, // index[32] ALERT_HANDLER_CLASSB_PHASE3_CYC
    4'b 1111, // index[33] ALERT_HANDLER_CLASSB_ESC_CNT
    4'b 0001, // index[34] ALERT_HANDLER_CLASSB_STATE
    4'b 0011, // index[35] ALERT_HANDLER_CLASSC_CTRL
    4'b 0001, // index[36] ALERT_HANDLER_CLASSC_CLREN
    4'b 0001, // index[37] ALERT_HANDLER_CLASSC_CLR
    4'b 0011, // index[38] ALERT_HANDLER_CLASSC_ACCUM_CNT
    4'b 0011, // index[39] ALERT_HANDLER_CLASSC_ACCUM_THRESH
    4'b 1111, // index[40] ALERT_HANDLER_CLASSC_TIMEOUT_CYC
    4'b 1111, // index[41] ALERT_HANDLER_CLASSC_PHASE0_CYC
    4'b 1111, // index[42] ALERT_HANDLER_CLASSC_PHASE1_CYC
    4'b 1111, // index[43] ALERT_HANDLER_CLASSC_PHASE2_CYC
    4'b 1111, // index[44] ALERT_HANDLER_CLASSC_PHASE3_CYC
    4'b 1111, // index[45] ALERT_HANDLER_CLASSC_ESC_CNT
    4'b 0001, // index[46] ALERT_HANDLER_CLASSC_STATE
    4'b 0011, // index[47] ALERT_HANDLER_CLASSD_CTRL
    4'b 0001, // index[48] ALERT_HANDLER_CLASSD_CLREN
    4'b 0001, // index[49] ALERT_HANDLER_CLASSD_CLR
    4'b 0011, // index[50] ALERT_HANDLER_CLASSD_ACCUM_CNT
    4'b 0011, // index[51] ALERT_HANDLER_CLASSD_ACCUM_THRESH
    4'b 1111, // index[52] ALERT_HANDLER_CLASSD_TIMEOUT_CYC
    4'b 1111, // index[53] ALERT_HANDLER_CLASSD_PHASE0_CYC
    4'b 1111, // index[54] ALERT_HANDLER_CLASSD_PHASE1_CYC
    4'b 1111, // index[55] ALERT_HANDLER_CLASSD_PHASE2_CYC
    4'b 1111, // index[56] ALERT_HANDLER_CLASSD_PHASE3_CYC
    4'b 1111, // index[57] ALERT_HANDLER_CLASSD_ESC_CNT
    4'b 0001  // index[58] ALERT_HANDLER_CLASSD_STATE
  };
endpackage

