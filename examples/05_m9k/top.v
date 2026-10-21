module top #(
    parameter P_HOLD_CYCLES = 25000000 // 0.5 s at 50 MHz
) (
    input  wire clk,
    output wire [3:0] led
);
    localparam P_MEM_DEPTH = 10;
    localparam PW_ADDRESS = $clog2(P_MEM_DEPTH);
    localparam PW_CNT = (P_HOLD_CYCLES > 1) ? $clog2(P_HOLD_CYCLES) : 1;

    reg [PW_CNT-1:0] counter = 0;
    reg [PW_ADDRESS-1:0] address = {PW_ADDRESS{1'b0}};
    wire [3:0] rom_data;

    rom rom_inst (
        .address(address),
        .clock(clk),
        .q(rom_data)
    );

    // A one in the stored pattern turns the corresponding LED on.
    assign led = ~rom_data;

    always @(posedge clk) begin
        if (counter == P_HOLD_CYCLES - 1) begin
            counter <= 0;
            if (address == 9)
                address <= {PW_ADDRESS{1'b0}};
            else
                address <= address + 1;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
