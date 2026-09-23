module led_blink(
	input clk,
	output led1,
	output led2
);
    parameter PERIOD = 50*1000*1000;
    parameter BW_CNT = $clog2(PERIOD);
	reg [BW_CNT:0] cnt = {BW_CNT{1'b0}};
	always @(posedge clk) begin
        if (cnt==PERIOD-1) begin
            cnt <= {BW_CNT{1'b0}};
        end else begin
		    cnt <= cnt + 1;
        end
	end

    wire clk_en;
    assign clk_en = cnt==PERIOD-1;

    reg led1_state = 1'b0;
    reg led2_state = 1'b1;
    always @(posedge clk) begin
        if (clk_en) begin
            led1_state <= ~led1_state;
            led2_state <= ~led2_state;
        end
    end
    assign led1 = led1_state;
    assign led2 = led2_state;

endmodule


