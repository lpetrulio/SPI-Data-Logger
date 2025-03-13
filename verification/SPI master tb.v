`timescale 1ns / 1ps

module tb_spi_master;

    // Parameters
    parameter CLK_PERIOD = 10; // 100MHz System Clock (10ns per cycle)
    parameter CLK_DIV = 100;   // SPI Clock Divider (1MHz SPI Clock)
    
    // Signals
    reg clk;
    reg rst;
    reg start;
    wire [15:0] dout;
    wire busy;
    wire sclk;
    reg miso;
    wire cs;

    // Instantiate SPI Master
    spi_master #(.CLK_DIV(CLK_DIV)) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .dout(dout),
        .busy(busy),
        .sclk(sclk),
        .miso(miso),
        .cs(cs)
    );

    // Generate 100 MHz clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // Fake SPI Slave (Thermocouple Sensor)
    reg [15:0] thermocouple_data = 16'b1010101010101010; // Simulated sensor response
    integer bit_index;

    // Fake SPI slave behavior (shifts out data when chip select is low)
    always @(negedge sclk) begin
        if (!cs) begin
            miso <= thermocouple_data[bit_index];
            bit_index <= bit_index - 1;
        end
    end

    // Test Procedure
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        start = 0;
        miso = 0;
        bit_index = 13;

        // Reset
        #50 rst = 0;
        #50 start = 1; // Start SPI transaction
        #20 start = 0;

        // Wait for transaction to complete
        wait (busy == 0);
        #50;

        // Display result
        $display("SPI Data Received: %b", dout);
        if (dout[13:0] == thermocouple_data[13:0]) begin
            $display("Test Passed: SPI Master correctly received data!");
        end else begin
            $display("Test Failed: Incorrect data received.");
        end

        // End simulation
        $finish;
    end

endmodule
