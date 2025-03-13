`timescale 1ns / 1ps

module tb_fifo_buffer;

    // Parameters
    parameter DEPTH = 32;
    parameter WIDTH = 16;
    parameter CLK_PERIOD = 10; // 100MHz Clock (10ns cycle)

    // Signals
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [WIDTH-1:0] din;
    wire [WIDTH-1:0] dout;
    wire full;
    wire empty;

    // Instantiate FIFO Buffer
    fifo_buffer #(.DEPTH(DEPTH), .WIDTH(WIDTH)) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Clock Generation
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Test Sequence
    initial begin
        // Initialize Signals
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;
        
        // Apply Reset
        #20 rst = 0;
        
        // Test Writing to FIFO
        $display("Writing data to FIFO...");
        repeat (DEPTH) begin
            #CLK_PERIOD;
            din = $random % 65536;  // Random 16-bit data
            wr_en = 1;
            $display("Write: Data = %d, Full = %b", din, full);
        end
        #CLK_PERIOD;
        wr_en = 0; // Stop writing
        
        if (full)
            $display("FIFO is full as expected!");
        else
            $display("Error: FIFO should be full but isn't!");

        // Test Reading from FIFO
        $display("Reading data from FIFO...");
        repeat (DEPTH) begin
            #CLK_PERIOD;
            rd_en = 1;
            $display("Read: Data = %d, Empty = %b", dout, empty);
        end
        #CLK_PERIOD;
        rd_en = 0; // Stop reading
        
        if (empty)
            $display("FIFO is empty as expected!");
        else
            $display("Error: FIFO should be empty but isn't!");

        // Try Reading from an Empty FIFO
        #CLK_PERIOD;
        rd_en = 1;
        #CLK_PERIOD;
        rd_en = 0;

        // Try Writing when FIFO is Full
        repeat (DEPTH) begin
            #CLK_PERIOD;
            wr_en = 1;
        end
        #CLK_PERIOD;
        wr_en = 0;

        // End Simulation
        $display("FIFO Test Completed!");
        $finish;
    end

endmodule
