`timescale 1ps/1ps

module tb();

// create reg variable that will drive input
// default value is 1'b1 cause of pull-up resistor
reg btn_1 = 1'b1;
reg btn_2 = 1'b1;
// create wire varible that will be driven by dut output
wire led;

// instantiate dut
top dut(.btn_1(btn_1), .btn_2(btn_2), .led(led));

// describe inputs behaviour in time
initial begin
    #5;
    btn_1 <= 1'b0;
    #5;
    btn_2 <= 1'b0;
    #5;
    btn_1 <= 1'b1;
    #5
    $finish();
end

endmodule
