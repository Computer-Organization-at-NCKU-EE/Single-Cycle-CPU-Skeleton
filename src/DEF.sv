package DEF;
    typedef logic [31:0] word;

    /* opcode enumeration of ALU */
    typedef enum logic [3:0] {
        ALU_OP_ADD,
        ALU_OP_SLL,
        ALU_OP_SLT,
        ALU_OP_SLTU,
        ALU_OP_XOR,
        ALU_OP_SRL,
        ALU_OP_OR,
        ALU_OP_AND,
        ALU_OP_SUB,
        ALU_OP_SRA
    } alu_opcode_t;

    /* about Mux selection control */
    typedef enum logic {
        NEXT_PC_SEL_PLUS_4,
        NEXT_PC_SEL_TARGET
    } next_pc_sel_t;

    typedef enum logic {
        ALU_OP1_SEL_RS1,
        ALU_OP1_SEL_PC
    } alu_op1_sel_t;

    typedef enum logic {
        ALU_OP2_SEL_RS2,
        ALU_OP2_SEL_IMM
    } alu_op2_sel_t;

    typedef enum logic [1:0] {
        SEL_PC_PLUS_4,
        SEL_LOAD_DATA,
        SEL_ALU_OUT
    } wb_sel_t;

    /* RISC-V RV64I instruction formats (equivalent to 32-bit logic type) */
    typedef union packed {
        // R-type
        struct packed {
            logic [6:0] func7;
            logic [4:0] rs2;
            logic [4:0] rs1;
            logic [2:0] func3;
            logic [4:0] rd;
            logic [6:0] opcode;
        } R_TYPE;
        // I-type
        struct packed {
            logic [11:0] imm_11_0;
            logic [4:0]  rs1;
            logic [2:0]  func3;
            logic [4:0]  rd;
            logic [6:0]  opcode;
        } I_TYPE;
        // S-type
        struct packed {
            logic [6:0] imm_11_5;
            logic [4:0] rs2;
            logic [4:0] rs1;
            logic [2:0] func3;
            logic [4:0] imm_4_0;
            logic [6:0] opcode;
        } S_TYPE;
        // U-type
        struct packed {
            logic [19:0] imm_31_12;
            logic [4:0]  rd;
            logic [6:0]  opcode;
        } U_TYPE;
        // B-type
        struct packed {
            logic imm_12;
            logic [5:0] imm_10_5;
            logic [4:0] rs2;
            logic [4:0] rs1;
            logic [2:0] func3;
            logic [3:0] imm_4_1;
            logic imm_11;
            logic [6:0] opcode;
        } B_TYPE;
        // J-type
        struct packed {
            logic imm_20;
            logic [9:0] imm_10_1;
            logic imm_11;
            logic [7:0] imm_19_12;
            logic [4:0] rd;
            logic [6:0] opcode;
        } J_TYPE;
        logic [31:0] raw;
    } inst_t;

    /* instruction opcode map */
    typedef enum logic [6:0] {
        OP = 7'b0110011,
        OP_IMM = 7'b0010011,
        LOAD = 7'b0000011,
        STORE = 7'b0100011,
        BRANCH = 7'b1100011,
        JAL = 7'b1101111,
        JALR = 7'b1100111,
        AUIPC = 7'b0010111,
        LUI = 7'b0110111
    } INST_OPCODE;

    /* arithmetic func3 map */
    typedef enum logic [2:0] {
        ADD_SUB_FUNC3 = 3'b000,
        SLL_FUNC3 = 3'b001,
        SLT_FUNC3 = 3'b010,
        SLTU_FUNC3 = 3'b011,
        XOR_FUNC3 = 3'b100,
        SRL_SRA_FUNC3 = 3'b101,
        OR_FUNC3 = 3'b110,
        AND_FUNC3 = 3'b111
    } ARITHMETIC_FUNC3;

    /* branch inst. func3 map */
    typedef enum logic [2:0] {
        BEQ_FUNC3  = 3'b000,
        BNE_FUNC3  = 3'b001,
        BLT_FUNC3  = 3'b100,
        BGE_FUNC3  = 3'b101,
        BLTU_FUNC3 = 3'b110,
        BGEU_FUNC3 = 3'b111
    } BRANCH_FUNC3;

    typedef enum logic [2:0] {
        SB_FUNC3 = 3'b000,
        SH_FUNC3 = 3'b001,
        SW_FUNC3 = 3'b010
    } STORE_FUNC3;

    typedef enum logic [2:0] {
        LB_FUNC3  = 3'b000,
        LH_FUNC3  = 3'b001,
        LW_FUNC3  = 3'b010,
        LBU_FUNC3 = 3'b100,
        LHU_FUNC3 = 3'b101
    } LOAD_FUNC3;
endpackage : DEF

