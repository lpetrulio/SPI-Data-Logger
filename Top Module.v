module spi_data_logger (
    input wire clk_in,      // Raw clock input (before Clock Wizard)
    input wire reset,       // External reset button
    input wire start,       // Start Data Logging (Can be mapped to a push button)

    // SPI for Thermocouple (Only Receiving Data)
    input wire miso_tc,     // MISO from Thermocouple
    output wire sclk_tc,    // SPI Clock for Thermocouple
    output wire cs_tc,      // Chip Select for Thermocouple

    // SPI for SD Card (Full SPI Communication)
    input wire miso_sd,     // MISO from SD Card
    output wire mosi_sd,    // MOSI to SD Card
    output wire sclk_sd,    // SPI Clock for SD Card
    output wire cs_sd,      // Chip Select for SD Card

    // UART for Debugging
    output wire uart_tx     // UART TX Output to PC
);

    // Internal signals
    wire clk;            // Clock from Clock Wizard
    wire locked;         // Clock Wizard locked signal
    wire spi_busy, sd_busy;
    wire [15:0] spi_data_out, fifo_data_out;
    reg start_spi;
    reg fifo_wr_en;
    wire fifo_rd_en, fifo_full, fifo_empty;
    reg start_sd_write;

    // Instantiate Clock Wizard
    clk_wiz_0 clk_gen (
        .clk_out1(clk),  
        .reset(reset),   
        .locked(locked),
        .clk_in1(clk_in) 
    );

    wire sys_reset = reset || !locked;

    // SPI Master (Thermocouple) - 1 MHz Clock
    spi_master #(.CLK_DIV(100)) spi_tc (
        .clk(clk),
        .rst(sys_reset),
        .start(start_spi),
        .dout(spi_data_out),
        .busy(spi_busy),
        .sclk(sclk_tc),
        .miso(miso_tc),
        .cs(cs_tc)
    );

    // FIFO Buffer
    fifo_buffer #(
        .DEPTH(32),
        .WIDTH(16)
    ) fifo (
        .clk(clk),
        .rst(sys_reset),
        .wr_en(fifo_wr_en),
        .rd_en(fifo_rd_en),
        .din(spi_data_out),
        .dout(fifo_data_out),
        .full(fifo_full),
        .empty(fifo_empty)
    );

    // SD Card SPI Writer - 25 MHz Clock
    sd_spi_writer #(.CLK_DIV(4)) sd_writer (
        .clk(clk),
        .rst(sys_reset),
        .start(start_sd_write),
        .data_in(fifo_data_out),
        .busy(sd_busy),
        .sclk(sclk_sd),
        .mosi(mosi_sd),
        .miso(miso_sd),
        .cs(cs_sd)
    );

    // UART Debugging
    uart_tx #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200)
    ) uart (
        .clk(clk),
        .rst(sys_reset),
        .din(fifo_data_out[7:0]), 
        .send(fifo_rd_en),
        .tx(uart_tx)
    );

    assign fifo_rd_en = !fifo_empty && !sd_busy;

endmodule






