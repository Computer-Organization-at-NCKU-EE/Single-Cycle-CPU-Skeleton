module CoreTop
    import DEF::*;
(
    // clock and reset signals
    input logic clk,
    input logic rst_n,
    // for "data" memory access
    output word mem_addr,
    input word mem_r_data,
    output logic [3:0] mem_w_en,
    output word mem_w_data,
    // for CrossVerify
    output logic valid_inst
);
    // TODO
endmodule : CoreTop

