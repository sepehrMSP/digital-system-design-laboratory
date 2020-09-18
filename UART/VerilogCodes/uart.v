module  uart #(parameter CLKS_PER_BIT) (data_in , data_out , clk, in_ready, out_valid);

    input [6:0] data_in;
    input clk;
    input in_ready;

    output [7:0] data_out;
    output out_valid;
    
	//=====================================
	 
	//fpga clock is at least about 50MHz
	//baud rate is normaly set at 115200
	// so CLKS_PER_BIT will be 50000000/115200 = 434
	//  parameter CLKS_PER_BIT = 434;
		
    //=====================================

    wire tx_2_rx;

    //=====================================

    sender  #(.CLKS_PER_BIT(CLKS_PER_BIT))    sender( .clk(clk),
                                                    .data_in(data_in),
                                                    .in_ready(in_ready),
                                                    .tx(tx_2_rx)
                                                    );
                                                
    reciver #(.CLKS_PER_BIT(CLKS_PER_BIT))    reciver(.clk(clk),
                                                    .rx(tx_2_rx),
                                                    .data_out(data_out),
                                                    .out_valid(out_valid) //just determine by stop-bit
                                                    );


endmodule