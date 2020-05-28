`include "interface.sv"
//`include "transaction.sv"

`include "AHB_Package.sv"
`include "AHB_DECODER.sv"
`include "AHB_MUX.sv"
`include "AHBSEL_STORE.sv"
`include "mem.sv"
`include "memController.sv"
`include "AHB_TOP.sv"
`include "top.sv"


//`include "generator.sv"
//`include "driver.sv"
//`include "monitor.sv"
//`include "scoreboard.sv"
//`include "env.sv"
`include "tb_top.sv"

import Definitions::*;

module top;
	
	bit clk,reset,select;
	inf pif(clk);
	AHB u0 (pif);
	tb_top p0 (pif);
	
	initial
	begin
		#10000; 
		$stop;
	end
	
	always #5 clk=~clk;
	
endmodule

