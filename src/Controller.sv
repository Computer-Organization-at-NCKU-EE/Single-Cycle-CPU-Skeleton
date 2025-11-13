module Controller
    import DEF::*;
(
    /* inst information */
    input inst_t inst,
    /* next PC select */
    output next_pc_sel_t next_pc_sel,
    /* Register File Control */
    output logic reg_w_en,
    /* ALU control */
    output alu_op1_sel_t alu_op1_sel,
    output alu_op2_sel_t alu_op2_sel,
    output logic is_lui,
    output alu_opcode_t alu_op,
    /* Branch Comparator control */
    BranchCompControlIntf.ControllerSide bc_control,
    /* DM write control */
    output logic [3:0] ram_w_en,
    /* write-back select */
    output wb_sel_t wb_sel
);
    // TODO
endmodule
