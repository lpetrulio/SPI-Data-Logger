module uart_tx #(
    parameter CLK_FREQ = 100_000_000,  // 100 MHz system clock
    parameter BAUD_RATE = 115200       // Baud rate
)(
    input wire clk,       // System clock (100 MHz)
    input wire rst,       // Reset signal
    input wire [7:0] din, // Data to send
    input wire send,      // Send signal (pulse high to send data)
    output reg tx         // UART TX output
);

    localparam integer BAUD_DIV = CLK_FREQ / BAUD_RATE;  // Clock cycles per UART bit

    reg [9:0] shift_reg;  // Data frame (Start bit + 8-bit data + Stop bit)
    reg [$clog2(BAUD_DIV):0] baud_counter;  // Baud rate counter
    reg [3:0] bit_index;  // Index of the bit being sent
    reg sending;  // Flag indicating transmission is in progress

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;  // UART idle state is high
            baud_counter <= 0;
            bit_index <= 0;
            sending <= 0;
            shift_reg <= 10'b1111111111;
        end else begin
            if (send && !sending) begin
                // Load data into shift register with start and stop bits
                shift_reg <= {1'b1, din, 1'b0};  // {Stop bit, Data, Start bit}
                sending <= 1;
                bit_index <= 0;
                baud_counter <= 0;
            end

            if (sending) begin
                if (baud_counter == BAUD_DIV - 1) begin
                    baud_counter <= 0;
                    tx <= shift_reg[bit_index];  // Transmit current bit
                    bit_index <= bit_index + 1;

                    if (bit_index == 9) begin
                        sending <= 0;  // Transmission complete
                    end
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
        end
    end
endmodule
