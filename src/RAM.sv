module RAM
    import DEF::word;
(
    input logic clk,
    input logic rst_n,
    input logic [3:0] w_en,
    input logic [15:0] addr,
    input word w_data,
    output word r_data
);
    reg [7:0] mem[65536];  // register array to mimic DRAM
                           // size of the RAM is 0x10000 (addr width = 16 bits)

    /* main memory logic */
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i <= 65536; i++) begin
                mem[i] <= 8'b0;
            end
        end else begin
            unique0 if (w_en == 4'b1111) begin
                for (logic [15:0] i = 0; i < 4; i++) begin
                    mem[addr+i] <= w_data[8*i+:8];
                end
            end else if (w_en == 4'b0011) begin
                for (logic [15:0] i = 0; i < 2; i++) begin
                    mem[addr+i] <= w_data[8*i+:8];
                end
            end else if (w_en == 4'b0001) begin
                mem[addr] <= w_data[0+:8];
            end
        end
    end
    /* assign output read data */
    assign r_data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
endmodule : RAM
