`define INSTRUCTION_LENGHT 12
`define MEMORY_MAPED_IO_STARTING_ADDRESS 2'hF8

module cpu (clk, reset, in, out, error);

    input clk;
    input reset;
    input  [7:0] in;

    output [7:0] out; 
    output error;
    
    //=====================================

    reg [7:0] memory [255:0];
    reg [7:0] stack [7:0];

    //The Program Counter is the register that holds
    //a pointer to the next instruction to be executed
    reg [7:0]   PC           = 0;
    reg [7:0]   top_of_stack = 0;
    reg [2:0]   SP           = 0;
    reg [11:0]  IR           = 0;
    reg [7:0]   MAR          = 0;

    reg s_flag = 0;
    reg z_flag = 0;
    //we assume that sp is always pointing to a empty memory location
    reg exe_clk_cycle = 0;
    reg [3:0] state;

    wire [3:0] opcode;
    wire [7:0] address;

    integer i;

    //=====================================

    parameter PUSH_CONST    = 4'b0000;
    parameter PUSH_MEMORY   = 4'b0001;
    parameter POP           = 4'b0010;
    parameter JUMP          = 4'b0011;
    parameter JZ            = 4'b0100;
    parameter JS            = 4'b0101;
    parameter ADD           = 4'b0110;
    parameter SUB           = 4'b0111;

    parameter INST_FETCH_1  = 4'b1000;
    parameter INST_FETCH_2  = 4'b1001;
    parameter INST_FETCH_3  = 4'b1010;
    parameter EXECUTE       = 4'b1011;
    

    //=====================================

    assign opcode   = IR[11:8];
    assign address  = IR[7:0];
    assign out      = memory[255];

    assign err = (out > 127) || (in[7] == 1);
    assign error = memory[253];

    always @(posedge clk, posedge reset)begin
        if(reset == 1'b1)begin
            MAR             <= 0;
            PC              <= 0;
            IR              <= 0;
            exe_clk_cycle   <= 0;
            SP              <= 0;
            top_of_stack    <= 0;
            state           <= INST_FETCH_1;

            memory[0]  <= 8'b_0000_0000;
            memory[1]  <= 8'b_0001_0111; // push constant 23
            memory[2]  <= 8'b_0000_0001;
            memory[3]  <= 8'b_1111_1110; // push input data from input IO (mem[254])
            memory[4]  <= 8'b_0000_0110;
            memory[5]  <= 8'b_0000_0000; // add two numbers on the stack
            memory[6]  <= 8'b_0001_0000;
            memory[7]  <= 8'b_0001_0111; // push constant 23
            memory[8]  <= 8'b_0000_0001;
            memory[9]  <= 8'b_1111_1110; // push input data from input IO (mem[254])
            memory[10] <= 8'b_0000_0110;
            memory[11] <= 8'b_0000_0000; // add two numbers on the stack
            memory[12] <= 8'b_0000_0110;
            memory[13] <= 8'b_0000_0000; // add two numbers on the stack  
            memory[14] <= 8'b_0000_0000;
            memory[15] <= 8'b_0000_1100; // push constant 12
            memory[16] <= 8'b_0000_0111;
            memory[17] <= 8'b_0000_0000; // subtract
            memory[18] <= 8'b_0000_0010;
            memory[19] <= 8'b_1111_1111; // pop from stack to mem[255]

            for (i=20; i<256; i = i+1) begin
                memory[i] <= 0;
            end

            for(i=0; i<8; i=i+1)begin
                stack[i] <= 0;
            end
        end
        else begin 
            memory[254] <= in;
            memory[253] <= err;
            case(state)
                INST_FETCH_1: begin //set PC to MAR
                    MAR <= PC;
                    PC <= PC + 1;
                    exe_clk_cycle <= 0;
                    state <= INST_FETCH_2;
                    $display("state 1");
                end

                INST_FETCH_2: begin //fetch opcode to IR
                    IR[11:8] <= memory[MAR][3:0];
                    MAR <= PC;
                    PC <= PC + 1; 
                    state <= INST_FETCH_3;
                    $display("state 2");
                end

                INST_FETCH_3:begin //fetch remain of instruction
                    IR[7:0] <= memory[MAR];
                    state <= EXECUTE;
                    $display("state 3");
                end

                EXECUTE: begin
                    $display("state 4");
                    exe_clk_cycle <= exe_clk_cycle + 1;
                    if (opcode == PUSH_CONST) begin
                        if (exe_clk_cycle == 0) begin
                            stack[SP] <= IR[7:0];
                            SP <= SP + 1;
                            state <= EXECUTE;
                        end
                        if(exe_clk_cycle == 1)begin
                            state <= INST_FETCH_1;
                        end
                    end

                    if (opcode == PUSH_MEMORY)begin
                        if (exe_clk_cycle == 0) begin
                            MAR <= address;        
                            state <= EXECUTE;
                        end
                        if (exe_clk_cycle == 1)begin
                            stack[SP] <= memory[MAR];
                            SP <= SP + 1;
                            state <= INST_FETCH_1;  
                        end
                    end

                    if (opcode == POP) begin
                        if (exe_clk_cycle == 0) begin
                            MAR <= address;
                            SP <= SP - 1;
                            state <= EXECUTE;
                        end
                        if (exe_clk_cycle == 1)begin
                            memory[MAR] <= stack[SP];
                            state <= INST_FETCH_1;
                        end
                    end

                    if (opcode == JUMP) begin
                        if (exe_clk_cycle == 0) begin
                            SP <= SP - 1;
                            state <= EXECUTE;
                        end
                        if (exe_clk_cycle == 1)begin
                            PC <= stack[SP];
                            state <= INST_FETCH_1;
                        end
                    end

                    if (opcode == JZ) begin
                        if (exe_clk_cycle == 0) begin
                            if(z_flag == 1'b1)begin
                                SP <= SP - 1;
                                state <= EXECUTE;
                            end
                            else begin
                                state <= EXECUTE;
                            end
                        end
                        if (exe_clk_cycle == 1)begin
                            if(z_flag == 1'b1)begin
                                PC <= stack[SP];
                                state <= INST_FETCH_1;
                            end
                            else begin
                                state <=  INST_FETCH_1;
                            end
                        end
                    end

                    if (opcode == JS) begin
                        if (exe_clk_cycle == 0) begin
                            if(s_flag == 1'b1)begin
                                SP <= SP - 1;
                                state <= EXECUTE;
                            end
                            else begin
                                state <= EXECUTE;
                            end
                        end
                        if (exe_clk_cycle == 1)begin
                            if(s_flag == 1'b1)begin
                                PC <= stack[SP]; 
                                state <= INST_FETCH_1;
                            end
                            else begin
                                state <= INST_FETCH_1;
                            end
                        end
                    end

                    if (opcode == ADD) begin
                        if (exe_clk_cycle == 0) begin
                            top_of_stack <= stack[SP-1];
                            SP <= SP - 1;
                            state <= EXECUTE;
                        end
                        if (exe_clk_cycle == 1)begin
                            stack[SP-1] <= stack[SP-1] + top_of_stack;
                            if (((stack[SP-1] + top_of_stack) & 8'b_1000_0000) == 8'b_1000_0000 )begin
                                s_flag <= 1;
                            end
                            else begin
                                s_flag <= 0;
                            end
                            if ((stack[SP-1] + top_of_stack) == 8'b_0000_0000)begin
                                z_flag <= 1;
                            end
                            else begin
                                z_flag <= 0;
                            end
                            state <= INST_FETCH_1;
                        end
                    end
                    if (opcode ==SUB) begin
                        if (exe_clk_cycle == 0) begin
                            top_of_stack <= stack[SP-1];
                            SP <= SP - 1;
                            state <= EXECUTE;
                        end
                        if (exe_clk_cycle == 1)begin
                            stack[SP-1] <= stack[SP-1] - top_of_stack;
                            if(((stack[SP-1] - top_of_stack) & 8'b_1000_0000) == 8'b_1000_0000)begin
                                s_flag <= 1;
                            end
                            else begin
                                s_flag <= 0;
                            end
                            if((stack[SP-1] - top_of_stack) == 8'b_0000_0000) begin
                                z_flag <= 1;
                            end
                            else begin
                                z_flag <= 0;
                            end
                            state <= INST_FETCH_1;
                        end
                    end
                end
            endcase
        end
    end

endmodule
