`include "constants.v"
 
module test_booth();

    parameter size = `size;
    reg [size-1:0] multiplier;
    reg [size-1:0] mutiplicand;
    reg clk;
    reg rst;
    reg start;

    wire [2*size-1:0] res;

    always #5 clk = !clk;

    booth_multiplier booth_multiplier(
                                        .multiplier(multiplier),
                                        .clk(clk),
                                        .rst(rst),
                                        .mutiplicand(mutiplicand),
                                        .start(start),
                                        .result(res)
                                    );

    initial begin
        rst = 1;
        clk = 0;
        mutiplicand = -3;
        multiplier = 5;
        #15
        rst =0;
        start =1;
    end
    


endmodule 
