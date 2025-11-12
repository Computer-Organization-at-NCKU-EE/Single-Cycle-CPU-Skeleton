module ROM
    import DEF::word;
(
    input logic clk,
    input logic [12:0] addr,
    output word r_data
);
    reg [7:0] mem[8192];  // the size of ROM is 0x2000 bytes

    // initial ROM by reading hex files
    string prog_elf_path;
    initial begin
        if ($value$plusargs("prog_elf_path=%s", prog_elf_path)) begin
            string hex_path = {prog_elf_path, ".hex"};
            $readmemh(hex_path, mem);
        end else begin
            $fatal(1, "hex_path is not set!");
        end
    end

    // main logic
    assign r_data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
endmodule : ROM
