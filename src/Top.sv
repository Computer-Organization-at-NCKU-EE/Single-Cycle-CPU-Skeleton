module Top
    import DEF::word;
(
    input  logic clk,
    input  logic rst_n,
    output logic valid_inst,
    output logic halt
);
    /* construct memory map */
    typedef struct packed {
        logic [31:0] lower_bound;
        logic [31:0] upper_bound;
    } addr_bound_t;
    addr_bound_t memory_map[4] = {
        {32'h0, 32'h2000},  // ROM
        {32'h80000000, 32'h80010000},  // RAM
        {32'hfffffff7, 32'hfffffff8},  // Text Buffer
        {32'hfffffffb, 32'hfffffffc}  // Halt Buffer
    };

    /* CPU Core */
    logic [3:0] mem_w_en;
    word mem_addr, mem_r_data, mem_w_data;
    CoreTop core (
        .clk(clk),
        .rst_n(rst_n),
        .mem_addr(mem_addr),
        .mem_r_data(mem_r_data),
        .mem_w_en(mem_w_en),
        .mem_w_data(mem_w_data),
        .valid_inst(valid_inst)
    );

    /* Read-Only Memory */
    logic [12:0] rom_addr;
    word rom_r_data;
    assign rom_addr = mem_addr[12:0];
    ROM rom (
        .clk(clk),
        .addr(rom_addr),
        .r_data(rom_r_data)
    );

    /* Random Access Memory */
    logic [15:0] ram_addr;
    logic [ 3:0] ram_w_en;
    word ram_w_data, ram_r_data;
    assign ram_addr = mem_addr[15:0];
    RAM ram (
        .clk(clk),
        .rst_n(rst_n),
        .addr(ram_addr),
        .w_en(ram_w_en),
        .w_data(ram_w_data),
        .r_data(ram_r_data)
    );

    /* Text Buffer */
    logic text_buffer_w_en;
    logic [7:0] text_buffer_w_data;
    TextBuffer text_buffer (
        .clk(clk),
        .w_en(text_buffer_w_en),
        .w_data(text_buffer_w_data)
    );

    /* Halt Buffer */
    logic halt_w_en, halt_w_data;
    Halt halt_buffer (
        .clk(clk),
        .rst_n(rst_n),
        .w_en(halt_w_en),
        .w_data(halt_w_data),
        .halt(halt)
    );

    /* simple crossbar control logics */
    always_comb begin
        // default values
        mem_r_data = 32'd0;
        ram_w_en = 4'd0;
        ram_w_data = 32'd0;
        text_buffer_w_en = 1'b0;
        text_buffer_w_data = 8'd0;
        halt_w_en = 1'b0;
        halt_w_data = 1'b0;

        // main logic
        if (mem_addr >= memory_map[0].lower_bound && mem_addr < memory_map[0].upper_bound) begin
            // forward to ROM
            mem_r_data = rom_r_data;
        end else if (mem_addr >= memory_map[1].lower_bound && mem_addr < memory_map[1].upper_bound) begin
            // forward to RAM
            mem_r_data = ram_r_data;
            ram_w_en   = mem_w_en;
            ram_w_data = mem_w_data;
        end else if (mem_addr >= memory_map[2].lower_bound && mem_addr < memory_map[2].upper_bound) begin
            // forward to Text Buffer
            text_buffer_w_en   = mem_w_en[0];
            text_buffer_w_data = mem_w_data[7:0];
        end else if (mem_addr >= memory_map[3].lower_bound && mem_addr < memory_map[3].upper_bound) begin
            // forward to Halt Buffer
            halt_w_en   = mem_w_en[0];
            halt_w_data = mem_w_data[0];
        end else begin
            // do nothing
        end
    end
endmodule : Top

module DriveTop ();
    logic clk, rst_n, valid_inst, halt;
    Top top (
        .clk(clk),
        .rst_n(rst_n),
        .valid_inst(valid_inst),
        .halt(halt)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        rst_n = 0;
        #6 rst_n = 1;
        #4 rst_n = 0;
        #5 rst_n = 1;
        wait (halt);
        $finish;
    end
endmodule : DriveTop
