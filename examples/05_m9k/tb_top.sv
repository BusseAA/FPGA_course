`timescale 1ns / 1ps

module tb_top;
    localparam integer P_HOLD_CYCLES = 8;
    localparam integer P_MEM_DEPTH = 10;
    reg clk = 1'b0;
    wire [3:0] led;
    reg [3:0] expected [0:P_MEM_DEPTH-1];
    integer cycle;
    integer index;

    top #(.P_HOLD_CYCLES(P_HOLD_CYCLES)) dut (.clk(clk), .led(led));
    always #10 clk = ~clk;

    initial begin
        expected[0] = 4'hD;
        expected[1] = 4'h1;
        expected[2] = 4'hD;
        expected[3] = 4'hE;
        expected[4] = 4'h4;
        expected[5] = 4'h3;
        expected[6] = 4'h9;
        expected[7] = 4'hD;
        expected[8] = 4'h1;
        expected[9] = 4'hD;

        // Exercise the actual ROM IP, including its registered address/output.
        for (cycle = 1; cycle <= (2 * P_MEM_DEPTH + 2) * P_HOLD_CYCLES; cycle = cycle + 1) begin
            @(posedge clk);
            #1;
            if (dut.address !== ((cycle / P_HOLD_CYCLES) % P_MEM_DEPTH))
                $fatal(1, "Unexpected ROM address at cycle %0d", cycle);
            if (cycle >= 2) begin
                index = ((cycle - 2) / P_HOLD_CYCLES) % P_MEM_DEPTH;
                if (led !== (~expected[index] & 4'hF))
                    $fatal(1, "LED mismatch at cycle %0d: got %h, pattern %h",
                           cycle, led, expected[index]);
            end
        end
        $display("PASS: ROM contents, active-low LEDs, dwell time and wraparound");
        $finish;
    end
endmodule
