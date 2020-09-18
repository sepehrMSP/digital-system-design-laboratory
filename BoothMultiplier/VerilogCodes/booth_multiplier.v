`include "constants.v"

module booth_multiplier(multiplier, mutiplicand, clk, rst, start, result);

    parameter size = `size;

    input [size-1:0] multiplier;
    input [size-1:0] mutiplicand;
    input clk;
    input rst;
    input start;

    output [2*size-1:0] result;

    //========================================

    wire data_path_en;
    wire first_round;
    wire last_round;
    wire [2*size-1:0] temp_result;

    //========================================
    
    assign result = (last_round) ? temp_result : 0;

    booth_controler controler(
                                .clk(clk),
                                .rst(rst),
                                .start(start),
                                .first_round(first_round),
                                .last_round(last_round),
                                .data_path_en(data_path_en)  
                            );

    booth_multiplier_data_path data_path(
                                            .en(data_path_en),
                                            .clk(clk),
                                            .rst(rst),
                                            .multiplier(multiplier),
                                            .mutiplicand(mutiplicand),
                                            .first_round(first_round),
                                            .result(temp_result)
                                        );


endmodule
