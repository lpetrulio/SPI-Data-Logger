module sd_spi_writer #(
    parameter CLK_DIV = 4  // 100MHz / 4 = 25MHz SPI Clock
)(
    input wire clk,        
    input wire rst,        
    input wire start,      
    input wire [15:0] data_in,
    output reg busy,       
    output reg sclk,       
    output reg mosi,       
    input wire miso,       
    output reg cs          
);

    reg [3:0] bit_cnt;
    reg [7:0] clk_count;
    reg [15:0] shift_reg;
    reg spi_clk_en;
    reg [1:0] state;  // FSM State Variable

    // State Encoding
    parameter IDLE = 2'b00, 
              WRITE = 2'b01, 
              DONE = 2'b10;

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
                        shift_reg <= data_in;
                        bit_cnt <= 15;
                        busy  <= 1;
                        state <= WRITE;
                    end
                end

                WRITE: begin
                    if (spi_clk_en) begin
                        mosi <= shift_reg[15];
                        shift_reg <= {shift_reg[14:0], 1'b0};

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



