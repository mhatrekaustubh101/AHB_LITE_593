//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : transaction.sv                                                                                   //                                                          //
// Term      : Spring 2020                                                                                      //
// Authors   : Kaustubh Mhatre | Aayush  				                                    	                //
// Date      : 05/27/2020                                                                                       //
// Version   : 1                                                                                                //
// Reference :                                                                                                  //
// Portland State University                                                                                    //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class txn;
	
	
	rand logic         	HRESETn;						//Random reset
	rand logic  [31:0]	HWDATA;							//Random data to be written
	rand logic  [31:0]	HADDR, HADDR_s2;				//Random address to which data has to be written
	rand logic  [2:0]	HSIZE;	
	rand logic	[2:0]	HBURST;							//Randomize burst type
	logic		[1:0]	HTRANS;
	logic        	HWRITE; 
	rand logic			HMASTLOCK; 
	rand logic			HREADY;
	rand logic   [3:0]	HPROT;
    
	logic   [31:0]	HRDATA;
	logic         	HRESP;
	
	randc logic [3:0] test_case;
	
	//Constraint on HWDATA
	constraint legal_data	{
								HWDATA <= 239;
								HWDATA >= 0;
							}
	
	//Constraint on HADDR
	constraint legal_addr_s1{
								HADDR <= 239;
								HADDR >= 0;
							}
	constraint legal_addr_s2{
								HADDR_s2 >= 256;
								HADDR_s2 <= 478;
							}
						
	//Constraint on HSIZE
	constraint legal_size	{
								HSIZE == 3'b001;
							}
						
	//Constraint on HMASTLOCK
	constraint legal_Mast_Loc	{
									HMASTLOCK == 1'b0;
								}
							
    //Constraint on HREADY							
	constraint legal_READY	{
								HREADY == 1'b1;
							}

	//Constraint on HBURST
	constraint legal_BURST	{
								HBURST == 0;
							}
							
	//Constraint on selecting type of operation
	constraint tests	{
							test_case <= 15;
							test_case >= 0;
						}


	
	//DISPLAY FUNCTION
    function void print(string str);
		$display("[][][][][][][][][][][][][][][][][][][][][][][][]][][][][][][][]");
		$display(str);
		$display($time,"data_in : %d\naddress_ : %d",HWDATA,HADDR);
		$display("[][][][][][][][][][][][][][][][][][][][][][][][]][][][][][][][]");
    endfunction 
	
endclass
    
