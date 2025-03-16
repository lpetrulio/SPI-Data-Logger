module spi_master #(
    parameter CLK_DIV = 100  // 100MHz / 100 = 1MHz SPI Clock
)(
    input wire clk,       // 100 MHz system clock
    input wire rst,       // Reset signal
    input wire start,     // Start SPI transaction
    output reg [15:0] dout,// Data received (16-bit, 14-bit valid)
    output reg busy,      // SPI busy flag
    output reg sclk,      // SPI clock
    input wire miso,      // Master In, Slave Out (Thermocouple sends data)
    output reg cs         // Chip select (active low)
);

    reg [3:0] bit_cnt;
    reg [7:0] clk_count;
    reg spi_clk_en;
    reg [1:0] state;  // FSM State Variable
    reg [15:0] dout_pipeline [1:0]; // Pipelining for timing optimization

    // Double Flip-Flop Synchronizer for MISO (Fixes CDC issue)
    reg [1:0] miso_sync;
    always @(posedge clk) begin
        miso_sync <= {miso_sync[0], miso}; // CDC Synchronizer
    end
    wire miso_stable = miso_sync[1]; // Synchronized MISO data

    // State Encoding
    parameter IDLE = 2'b00, 
              START = 2'b01, 
              TRANSFER = 2'b10, 
              DONE = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sclk  <= 0;
            cs    <= 1;
            busy  <= 0;
            bit_cnt <= 0;
            clk_count <= 0;
        end else begin
            if (clk_count == (CLK_DIV / 2)) begin
                clk_count <= 0;
                sclk <= ~sclk;
                spi_clk_en <= 1;
            end else begin
                clk_count <= clk_count + 1;
                spi_clk_en <= 0;
            end

            case (state)
                IDLE: begin
                    if (start) begin
                        cs    <= 0;
                        bit_cnt <= 13; 
                        busy  <= 1;
                        state <= START;
                    end
                end
                
                START: begin
                    if (spi_clk_en) begin
                        state <= TRANSFER;
                    end
                end

                TRANSFER: begin
                    if (spi_clk_en) begin
                        dout_pipeline[0] <= dout_pipeline[1];
                        dout_pipeline[1] <= miso_stable; // Pipelined data capture
                        dout[bit_cnt] <= dout_pipeline[1]; // Assign pipelined data to output

                        if (bit_cnt == 0) begin
                            state <= DONE;
                        end else begin
                            bit_cnt <= bit_cnt - 1;
                        end
                    end
                end

                DONE: begin
                    cs <= 1;
                    busy <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule






