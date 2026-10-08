`timescale 1 ns /1 ns
 
 
 module tb_button();
    reg clk = 1'b0;
    always begin
        #1 clk = ~clk;
    end

    wire led;

    // in simulation we have to use registers to drive inputs of DUT.
    reg btn = 1'b1;  
    button #(
        .DENOISE_DELAY(15) // set delay low enough to make it comfortable to debug
    ) DUT (
        .clk(clk),
        .btn(btn),
        .led(led)
    );

    int i;
    initial begin
        $dumpvars;
        // simulate some button press and noise 
        
        
        #3
        btn = 1'b0;

        // noise
        for (i=0; i<2; i=i+1) begin
            #2
            btn = 1'b1;

            #2
            btn = 1'b0;

        end

        #20
        btn <= 1'b1;



        $finish;
    end
 endmodule
