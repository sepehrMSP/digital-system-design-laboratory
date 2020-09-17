`include "constants.v"

module booth_controler(clk, rst, start, first_round, last_round, data_path_en);

    parameter size = `size;

    input clk;
    input rst;
    input start;

    output first_round;
    output last_round;
    output data_path_en;

    //==========================================

    reg [size-1:0] counter =0;
    reg first_round;
    reg last_round;
    reg data_path_en;
    
    //==========================================

    always @(posedge clk, posedge rst)begin
        if (rst == 1'b1)begin
            counter = 0;
            last_round = 0;
            first_round = 0;
            data_path_en = 0;
        end
        else begin
            if (start == 1'b1) begin
                data_path_en = 1;
                if (counter == 0)begin
                    first_round = 1;
                end
                else begin
                    first_round = 0;
                end

                if (counter == size)begin
                    last_round = 1;
                end 
                else begin
                    last_round = 0;
                end

                if(counter == size)begin
                    counter = 0;
                end
                else begin
                    counter = counter + 1;
                end
            end
            else begin
                data_path_en = 0;
            end
        end
    end

endmodule
