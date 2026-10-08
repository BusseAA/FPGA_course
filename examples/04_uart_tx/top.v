module top #(
    parameter integer CLKS_PER_BIT = 50000000/9600,
    parameter integer DENOISE_DELAY = 50000
) (
    input  wire clk,
    input  wire btn,
    output wire tx
);

    localparam [1:0]
        IDLE = 2'd0,
        SEND = 2'd1,
        WAIT_DONE = 2'd2;

    reg [1:0] state = IDLE;
    reg [2:0] char_index = 3'd0;
    reg [7:0] tx_data;
    wire btn_press;
    wire tx_busy;
    wire tx_start = (state == SEND) && !tx_busy;

    button #(
        .DENOISE_DELAY(DENOISE_DELAY)
    ) button_inst (
        .clk(clk),
        .btn(btn),
        .btn_press_o(btn_press)
    );

    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uart_tx_inst (
        .clk(clk),
        .reset(1'b0),
        .start(tx_start),
        .data_in(tx_data),
        .tx(tx),
        .busy(tx_busy)
    );

    // Send five bytes sequentially
    always @* begin
        case (char_index)
            3'd0: tx_data = "H";
            3'd1: tx_data = "e";
            3'd2: tx_data = "l";
            3'd3: tx_data = "l";
            3'd4: tx_data = "o";
            default: tx_data = 8'd0;
        endcase
    end

    // simple state machine to drive sequential bytes sending
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                // Presses during a message are discarded.
                if (btn_press && !tx_busy) begin
                    char_index <= 3'd0;
                    state <= SEND;
                end
            end

            SEND: begin
                if (!tx_busy)
                    state <= WAIT_DONE;
            end

            WAIT_DONE: begin
                if (!tx_busy) begin
                    if (char_index == 3'd4)
                        state <= IDLE;
                    else begin
                        char_index <= char_index + 3'd1;
                        state <= SEND;
                    end
                end
            end

            default: state <= IDLE;
        endcase
    end
endmodule
