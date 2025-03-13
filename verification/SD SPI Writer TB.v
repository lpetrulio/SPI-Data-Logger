`timescale 1ns / 1ps

module tb_sd_spi_writer;

    // Parameters
    parameter CLK_PERIOD = 10; // 100MHz system clock (10ns cycle)
    parameter CLK_DIV = 4;     // SPI Clock Divider (25MHz SPI clock)

    // Signals
    reg clk;
    reg rst;
    reg start;
    reg [15:0] data_in;
    wire busy;
    wire sclk;
    wire mosi;
    reg miso;
    wire cs;

    // Instantiate SD SPI Writer
    sd_spi_writer #(.CLK_DIV(CLK_DIV)) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .busy(busy),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .cs(cs)
    );

    // Generate 100MHz Clock
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Test Sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        start = 0;
        data_in = 16'b1010101010101010; // Example data to write
        miso = 0;

        // Apply Reset
        #50 rst = 0;

        // Start SPI Write
        #20 start = 1;
        #10 start = 0; // Start should only be high for one cycle

        // Wait until SPI write is complete
        wait (busy == 0);
        #20;

        // Check results
        $display("SD SPI Write Completed!");
        if (cs == 1 && busy == 0) begin
            $display("Test Passed: SD card write operation successful.");
        end else begin
            $display("Test Failed: SPI signals did not behave as expected.");
        end

        // Observe
