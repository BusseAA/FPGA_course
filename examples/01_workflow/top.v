module top (
	input btn_1, btn_2,
	output led
);
    assign led = ~btn_1 & ~btn_2;
endmodule