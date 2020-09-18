module test_uart();

    parameter clks_per_bit = 2;

    //=====================================

    reg [6:0] data_in;
    reg clk;
    reg in_ready;

    wire [7:0] data_out;
    wire out_valid;

    //=====================================

    UART  #(.CLKS_PER_BIT(clks_per_bit)) uart (.data_in(data_in),
                                            .data_out(data_out),
                                            .clk(clk),
                                            .in_ready(in_ready),
                                            .out_valid(out_valid)
                                            );

    //=====================================

    initial begin
        clk = 0;
        in_ready = 0;
        #12
        in_ready = 1;
        data_in = 7'b1101101;
        #15
        in_ready = 0;
        //////////////////////////////////////////////
        #220
        in_ready = 1;
        data_in = 7'b0101010;
        #15
        in_ready = 0;
    end
    
    always #5 clk = ~clk;

endmodule
