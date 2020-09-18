module cpu_and_prepherals(clk, reset, in, ones_7seg, tens_7seg, hundreds_7seg, error);

    input clk;
    input reset;
    input [7:0] in;

    output [6:0] ones_7seg;
    output [6:0] tens_7seg;
    output [6:0] hundreds_7seg;
    output error;

    //=====================================

    wire [7:0] cpu_2_bcd;

    wire [3:0] ones;
    wire [3:0] tens;
    wire [3:0] hundreds;

    //=====================================

    cpu cpu(.clk(clk),
            .reset(reset),
            .in(in),
            .out(cpu_2_bcd),
            .error(error)
            );


    BCD BCD(.in(cpu_2_bcd),
            .ones(ones),
            .tens(tens),
            .hundreds(hundreds)
            );


    seven_segment   ones_seven_segment(     .bcd(ones),
                                            .seg(ones_7seg)
                                            );

    seven_segment   tens_seven_segment(     .bcd(tens),
                                            .seg(tens_7seg)
                                            );

    seven_segment   hundreds_seven_segment( .bcd(hundreds),
                                            .seg(hundreds_7seg)
                                            );

endmodule