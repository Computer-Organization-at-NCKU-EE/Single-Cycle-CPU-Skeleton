module TextBuffer (
    input logic clk,
    input logic w_en,
    input logic [7:0] w_data
);
    always_ff @(posedge clk) begin
        if (w_en) begin
            $write("%c", w_data);  // print a single character on screen
        end
    end
endmodule : TextBuffer
