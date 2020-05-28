import Definitions::*;
module tb_mux();

logic 			MUX_SEL;
logic [31:0] 	HRDATA_1, HRDATA_2;
logic       	HREADYOUT_1, HREADYOUT_2;
logic [31:0] 	HRDATA_out;
logic			HREADY_out;
Response_t		HRESP_1, HRESP_2, HRESP_out;


//DUT Instantiation
AMBA_MUX DUT(.*);
task S1();
	MUX_SEL = 1'b0;
	HRDATA_1 = '0;
	HRESP_1 = OKAY;
	HREADYOUT_1 = 'b0;
endtask: S1

task S2();
	MUX_SEL = 1'b1;
	HRDATA_2 = '1;
	HRESP_2 = OKAY;
	HREADYOUT_2 = 'b1;
endtask: S2
//test
initial
	begin
		
		$monitor("MUX_SEL: %b gives Data_Out: %d | Response_out: %s | Ready: %b",MUX_SEL,HRDATA_out,HRESP_out,HREADY_out);
		S1;
		#10;
		S2;
		#10;
		$stop;
	end
endmodule
		