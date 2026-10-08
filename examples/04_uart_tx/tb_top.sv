`timescale 1ns / 1ps

module tb_top;
    localparam integer CLKS_PER_BIT = 4;

    reg clk = 1'b0;
    reg btn = 1'b1;
    wire tx;

    always #5 clk = ~clk;

    top #(
        .CLKS_PER_BIT(CLKS_PER_BIT),
        .DENOISE_DELAY(12)
    ) DUT (
        .clk(clk),
        .btn(btn),
        .tx(tx)
    );

    initial begin
        $dumpfile("build/tb_top.vcd");
        $dumpvars(0, tb_top);

        repeat (4) @(negedge clk);
        repeat (6) @(negedge clk);

        // First press: start sending "Hello".
        btn = 1'b0;
        repeat (6) @(negedge clk);
        btn = 1'b1;

        // Second press: debounce has expired, but the UART is still busy.
        repeat (24) @(negedge clk);
        btn = 1'b0;
        repeat (6) @(negedge clk);
        btn = 1'b1;

        // Wait longer than a complete five-byte message.
        repeat (60 * CLKS_PER_BIT) @(negedge clk);

        // Third press: start sending another "Hello".
        btn = 1'b0;
        repeat (6) @(negedge clk);
        btn = 1'b1;

        repeat (60 * CLKS_PER_BIT) @(negedge clk);
        $finish;
    end
endmodule
