`define DATA_LEN 7

module sender #(parameter CLKS_PER_BIT) (clk, data_in, in_ready, tx);

    input clk;
    input [`DATA_LEN-1:0] data_in;
    input in_ready;
    
    output tx;

    //=====================================

    reg tx;
    reg [2:0] state = 3'b000, next_state;
    reg [3:0] data_index = 0;
    reg [7:0] clk_count = 0;
    reg [`DATA_LEN-1:0] current_data = 0;

    wire par;

    //=====================================
    
    parameter IDLE          = 3'b000;
    parameter PARITY        = 3'b001;
    parameter START_BIT     = 3'b010;
    parameter TRANSFER_DATA = 3'b011;
    parameter STOP_BIT      = 3'b100;

    //=====================================

    assign par =    current_data[0] ^ current_data[1] ^ current_data[2] ^ current_data[3] ^
                    current_data[4] ^ current_data[5] ^ current_data[6];

    always @(*)begin
        state <= next_state;
    end

    reg [10:0] cc = 0;

    always @(posedge clk) begin
        next_state = IDLE;
        cc = cc +1;
        case (state)
            IDLE:begin
                clk_count = 0;
                data_index = 0;
                tx = 1'b1;
                if (in_ready == 1'b1) begin
                    current_data = data_in;
                    next_state = START_BIT;
                end
                else begin
                    next_state = IDLE;
                end
            end

            START_BIT: begin
                tx = 1'b0;
                if(clk_count < CLKS_PER_BIT-1) begin
                    clk_count = clk_count + 1;
                    next_state = START_BIT;
                end
                else begin
                    clk_count = 0;
                    next_state = PARITY;
                end
            end

            PARITY: begin
                tx = par;
                if(clk_count < CLKS_PER_BIT-1)begin
                    clk_count = clk_count + 1;
                    next_state = PARITY;
                end
                else begin
                    clk_count =0;
                    next_state = TRANSFER_DATA;
                end
            end

            TRANSFER_DATA:begin
                tx = current_data[data_index];
                if(clk_count < CLKS_PER_BIT-1)begin
                    clk_count = clk_count + 1;
                    next_state = TRANSFER_DATA;
                end
                else begin
                    clk_count = 0;
                    if (data_index < `DATA_LEN - 1)begin
                        data_index = data_index + 1;
                        next_state = TRANSFER_DATA;
                    end
                    else begin
                        data_index = 0;
                        next_state = STOP_BIT;
                    end
                end
            end

            STOP_BIT:begin
                tx = 1'b1;
                if(clk_count < CLKS_PER_BIT-1)begin
                    clk_count = clk_count + 1;
                    next_state = STOP_BIT;
                end
                else begin
                    clk_count = 0;
                    next_state = IDLE;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule