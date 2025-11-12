module RegFile
    import DEF::*;
(
    input logic clk,
    input logic rst_n,
    input logic [4:0] rs1_index,
    input logic [4:0] rs2_index,
    input logic w_en,
    input logic [4:0] rd_index,
    input word rd_data,
    output word rs1_data,
    output word rs2_data
);
    word mem[32];  // register file
    // TODO
endmodule : RegFile
