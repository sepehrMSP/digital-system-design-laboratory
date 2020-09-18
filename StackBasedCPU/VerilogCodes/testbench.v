module test_cpu();

    reg [7:0] data_in;
    reg clk;
    reg reset;

    wire [6:0] ones;
    wire [6:0] tens;
    wire [6:0] hundreds;

    wire error;
    wire [7:0] out;
    //=====================================

    // cpu cpu(    .clk(clk),
    //             .reset(reset),
    //             .in(data_in),
    //             .out(out),
    //             .error(error)
    //         );

    cpu_and_prepherals  cpu_and_prepherals( .clk(clk),
                                            .reset(reset),
                                            .in(data_in),
                                            .ones_7seg(ones),
                                            .tens_7seg(tens),
                                            .hundreds_7seg(hundreds),
                                            .error(error)
                                        );
    
    //=====================================

    initial begin
        reset = 0;
        clk = 0;
        #1
        reset = 1;
        #12
        reset = 0;
        data_in = 8'b_1110_1001;
        #15
        ;
        //////////////////////////////////////////////
        // #220
        // data_in = 8'b10101010;
    end
    
    always #5 clk = ~clk;

endmodule

