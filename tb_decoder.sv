module tb_decoder();

logic DECODERin;
logic HSEL_S1;
logic HSEL_S2;
logic DECODE2MUX;

//DUT Instantiation
AHB_DECODER M1(.*);

//test
initial
	begin
		$monitor("Slave status: SLAVE_1:%b | SLAVE_2:%b DECODERin:%b | MUX:%b", HSEL_S1,HSEL_S2,DECODERin,DECODE2MUX);
		DECODERin = 1'b0;	//slave_1 is selected
		#10;
		DECODERin = 1'b1;	//slave_2 is selected
		#10;
		DECODERin = 'x;		//slave selected is invalid
		#10;
		DECODERin = 'z;		//No slave selected
		#10;
		$finish;
	end
endmodule
