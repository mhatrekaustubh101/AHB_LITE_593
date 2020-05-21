
//import Definitions::*;

class txn;
    
	//DATA
	randc int data_in;
	//ADDRESS
    randc int addr_in;
	
	
	constraint legal	{
							data_in <= 255;
							data_in >= 0;
							addr_in <= 255;
							addr_in >= 0;
						}
	
	//DISPLAY FUNCTION
    function void print(string str);
		$display("[][][][][][][][][][][][][][][][][][][][][][][][]][][][][][][][]");
		$display(str);
		$display($time,"data_in : %d\ndata_out : %d",data_in,addr_in);
		$display("[][][][][][][][][][][][][][][][][][][][][][][][]][][][][][][][]");
    endfunction
	
endclass
    
