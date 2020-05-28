
//import Definitions::*;

class txn;
    
	//DATA
	//randc logic [31:0] data_in;
	//ADDRESS
    //randc logic [31:0] addr_in;
	
	
	rand logic         	HRESETn;
	rand logic  [31:0]	HWDATA;
	rand logic  [31:0]	HADDR;
	rand logic  [2:0]	HSIZE;
	rand logic	[2:0]	HBURST;
	logic		[1:0]	HTRANS;
	logic        	HWRITE; 
	rand logic			HMASTLOCK; 
	rand logic			HREADY;
	rand logic   [3:0]	HPROT;
    
	logic   [31:0]	HRDATA;
	logic         	HRESP;
	
	
	constraint legal_data	{
								HWDATA <= 239;
								HWDATA >= 0;
							}
							
	constraint legal_addr	{
								HADDR <= 239;
								HADDR >= 0;
							}
							
	constraint legal_size	{
								HSIZE == 3'b001;
							}
							
	constraint legal_Mast_Loc	{
									HMASTLOCK == 1'b0;
								}
								
	constraint legal_READY	{
								HREADY == 1'b1;
							}

	constraint legal_BURST	{
								HBURST == 0;
							}


	
	//DISPLAY FUNCTION
    function void print(string str);
		$display("[][][][][][][][][][][][][][][][][][][][][][][][]][][][][][][][]");
		$display(str);
		$display($time,"data_in : %d\naddress_ : %d",HWDATA,HADDR);
		$display("[][][][][][][][][][][][][][][][][][][][][][][][]][][][][][][][]");
    endfunction 
	
endclass
    
