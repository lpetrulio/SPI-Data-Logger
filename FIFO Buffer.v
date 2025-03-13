module fifo_buffer #(
    parameter DEPTH = 32,
    parameter WIDTH = 16
)(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout,
    output reg full,
    output reg empty
);

    reg [WIDTH-1:0] buffer [DEPTH-1:0];
    reg [5:0] write_ptr, read_ptr, count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 0;
            read_ptr  <= 0;
            count     <= 0;
            full      <= 0;
            empty     <= 1;
        end else begin
            if (wr_en && !full) begin
                buffer[write_ptr] <= din;
                write_ptr <= write_ptr + 1;
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                dout <= buffer[read_ptr];
                read_ptr <= read_ptr + 1;
                count <= count - 1;
            end
            full  <= (count == DEPTH);
            empty <= (count == 0);
        end
    end
endmodule
