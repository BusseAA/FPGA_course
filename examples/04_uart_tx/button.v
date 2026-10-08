module button(
   input clk,
   input btn,
   output btn_press_o
);
    /*
    Captures btn_press event
    Synchronizer -> btn_press event detection -> debouncing
    */

    // synchronize (btn_delay[1:0]) and capture negative front
    reg [2:0] btn_delay = 3'b1;
    always @(posedge clk) begin
        btn_delay[2: 1] <= btn_delay[1: 0];
        btn_delay[0] <= btn;
    end
    wire btn_press;
    assign btn_press = (~btn_delay[1]) & btn_delay[2];

    // denoise
    parameter DENOISE_DELAY = 500;
    localparam BW_DENOISE_CNT = $clog2(DENOISE_DELAY - 1);
    reg [BW_DENOISE_CNT-1: 0] denoise_cnt = {BW_DENOISE_CNT{1'b0}};

    localparam DENOISE_ST_READY = 0;
    localparam DENOISE_ST_WAITING = 1;
    reg denoise_st = DENOISE_ST_READY;
    wire btn_press_denoised = btn_press && denoise_st==DENOISE_ST_READY;

    always @(posedge clk) begin
        if (denoise_st==DENOISE_ST_READY && btn_press) begin
            denoise_st <= DENOISE_ST_WAITING;
            denoise_cnt <= {BW_DENOISE_CNT{1'b0}};

        end else if (denoise_st==DENOISE_ST_WAITING && denoise_cnt==DENOISE_DELAY-1) begin
            denoise_st <= DENOISE_ST_READY;
        end else begin
            denoise_cnt <= denoise_cnt + 1;
        end
    end
    
   assign btn_press_o = btn_press_denoised;
endmodule
