`define DATA_LEN 7

module reciver #(parameter CLKS_PER_BIT)(clk, rx, data_out, out_valid);
    input clk;
    input rx;

    output reg [`DATA_LEN:0] data_out;
    output reg out_valid = 0;

    //=====================================

    reg [2:0] state = 3'b000, next_state;
    reg [`DATA_LEN:0] current_data = 0;
    reg par;
    reg [3:0] data_index = 0;
    reg clk_count = 0;

    //=====================================

    parameter IDLE          = 3'b000;
    parameter START_BIT     = 3'b001;
    parameter PARITY        = 3'b010;
    parameter RECIVE_DATA   = 3'b011;
    parameter STOP          = 3'b100;
    
    //=====================================

    always @(*)begin
        state <= next_state;
    end

    reg [10:0] cc =0;

    always@(posedge clk)begin
        cc = cc + 1;
        case (state)
            IDLE: begin
                out_valid = 0;
                data_index = 0;
                clk_count = 0;
                if(rx == 1'b0)begin
                    next_state = START_BIT;
                end
                else begin
                    next_state = IDLE;
                end
            end
            
            START_BIT:begin
                if(clk_count < CLKS_PER_BIT-2 )begin
                    clk_count = clk_count + 1;
                    next_state = START_BIT;
                    if(rx == 1'b1)begin
                        clk_count =0;
                        next_state = IDLE;
                    end
                end
                else begin
                    clk_count = 0;
                    next_state = PARITY; 
                end
            end

            PARITY: begin
                if(clk_count < CLKS_PER_BIT-1)begin
                    clk_count = clk_count +1;
                    next_state = PARITY;
                end
                else begin
                    clk_count = 0;
                    next_state = RECIVE_DATA; 
                    current_data[0] = rx;
                end
                
            end

            RECIVE_DATA: begin
                if (clk_count < CLKS_PER_BIT-1)begin
                    clk_count = clk_count + 1;
                    next_state = RECIVE_DATA;
                end
                else begin
                    clk_count = 0;
                    current_data[data_index + 1] = rx;
                    if(data_index < `DATA_LEN-1) begin
                        data_index = data_index + 1;
                        next_state = RECIVE_DATA;
                    end
                    else begin
                        data_index = 0;
                        next_state = STOP; 
                    end
                end
            end

            STOP: begin
                if(clk_count < CLKS_PER_BIT-1) begin
                    clk_count = clk_count + 1;
                    next_state = STOP;
                end
                else begin
                    clk_count = 0;
                    next_state = IDLE;
                    out_valid = 1'b1;
                    data_out = current_data;
                end
            end

            default: begin
                next_state =IDLE;
            end
        endcase
    end

endmodule
