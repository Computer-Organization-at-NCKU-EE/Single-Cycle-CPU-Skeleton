module Halt (
    input  logic clk,
    input  logic rst_n,
    input  logic w_en,
    input  logic w_data,
    output logic halt
);
    logic halt_reg;
    always_ff @(negedge rst_n or posedge clk) begin
        if (!rst_n) begin
            halt_reg <= 1'b0;
        end else begin
            if (w_en) begin
                halt_reg <= w_data;
            end
        end
    end
    assign halt = halt_reg;
endmodule : Halt
