module uart_tx #(
    parameter integer CLKS_PER_BIT = 16
) (
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire [7:0] data_in,
    output reg        tx,
    output wire       busy
);

    localparam integer COUNT_WIDTH = $clog2(CLKS_PER_BIT - 1);

    localparam [1:0]
        IDLE  = 2'd0,
        START = 2'd1,
        DATA  = 2'd2,
        STOP  = 2'd3;

    reg [1:0] state;
    reg [COUNT_WIDTH-1:0] count;
    reg [2:0] bit_index;
    reg [7:0] data_reg;

    wire bit_done = (count == CLKS_PER_BIT - 1);
    assign busy = (state != IDLE);

    // Bit timing counter
    always @(posedge clk) begin
        if (reset)
            count <= {COUNT_WIDTH{1'b0}};
        else if ((state == IDLE) || bit_done)
            count <= {COUNT_WIDTH{1'b0}};
        else
            count <= count + 1'b1;
    end

    // State machine, payload, and serial output
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_index <= 3'd0;
            data_reg <= 8'd0;
            tx        <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    tx        <= 1'b1;
                    bit_index <= 3'd0;
                    if (start) begin
                        data_reg <= data_in;
                        tx        <= 1'b0;
                        state     <= START;
                    end
                end

                START: if (bit_done) begin
                    tx    <= data_reg[0];
                    state <= DATA;
                end

                DATA: if (bit_done) begin
                    data_reg <= {1'b0, data_reg[7:1]};
                    bit_index <= bit_index + 3'd1;
                    tx        <= (bit_index == 3'd7)
                                 ? 1'b1 : data_reg[1];
                    if (bit_index == 3'd7)
                        state <= STOP;
                end

                STOP: if (bit_done)
                    state <= IDLE;

                default: begin
                    state <= IDLE;
                    tx    <= 1'b1;
                end
            endcase
        end
    end

endmodule
