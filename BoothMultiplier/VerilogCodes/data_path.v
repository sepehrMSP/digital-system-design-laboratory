`include "constants.v"

module booth_multiplier_data_path(en, multiplier, mutiplicand, clk, rst, first_round, result);

    parameter size = `size;

    input en;
    input [size-1:0] multiplier;
    input [size-1:0] mutiplicand;
    input clk;
    input rst;
    input first_round;

    output [2*size:1] result;
    
    //========================================

    reg signed  [2*size:0] temp_result;
    reg [1:0]      op;
    
    //========================================

    assign result       = temp_result[2*size:1];

    always @(posedge clk, posedge rst)begin
        if (rst == 1'b1) begin
            temp_result =   0;
        end
        else begin
            if (en) begin
                if(first_round == 1'b1)begin
                    temp_result[size:0] = (mutiplicand<<1);
                    temp_result[2*size:size+1] = 0;
                    op = temp_result[1:0];
                end
                case (op)
                    `NOOP:  begin
                                temp_result = (temp_result >>> 1);
                                op = temp_result[1:0];
                            end

                    `ADD:   begin
                                temp_result[2*size:size+1] = temp_result[2*size:size+1] + multiplier;
                                temp_result = (temp_result >>> 1);
                                op = temp_result[1:0];
                            end
                    
                    `SUB:   begin
                                temp_result[2*size:size+1] = temp_result[2*size:size+1] - multiplier;
                                temp_result = (temp_result >>> 1);
                                op = temp_result[1:0];
                            end
                    default: begin
                                temp_result = (temp_result >>> 1);
                                op = temp_result[1:0];
                            end
                endcase
            end
        end
    end



endmodule
