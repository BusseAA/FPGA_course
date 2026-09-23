`timescale 1 ns /1 ns
 
 
 module tb_led_blink();
    reg clk = 1'b0;
    always begin
        #1 clk = ~clk;
    end

    wire led1, led2;
    led_blink #(
        .PERIOD(8)
    ) DUT (
        .clk(clk),
        .led1(led1),
        .led2(led2)
    );

    initial begin
        $dumpvars;
        $display("Test started...");
        #(100)
        $finish;
    end
 endmodule
