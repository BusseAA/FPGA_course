`timescale 1ns / 1ps

module tb_uart_tx;
    localparam integer CLKS_PER_BIT = 4;

    reg clk = 1'b0;
    reg reset = 1'b1;
    reg start = 1'b0;
    reg [7:0] data_in = 8'd0;
    wire tx;
    wire busy;

    always #5 clk = ~clk;

    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) DUT (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    initial begin
        // Drive inputs on falling edges, away from the sampling edge.
        repeat (4) @(negedge clk);
        reset = 1'b0;

        repeat (2) @(negedge clk);
        data_in = 8'h48; // ASCII 'H'.
        start = 1'b1;
        @(negedge clk);
        start = 1'b0;

        // wait for the transmission to finish
        repeat (12 * CLKS_PER_BIT) @(negedge clk);
        $finish;
    end
endmodule
