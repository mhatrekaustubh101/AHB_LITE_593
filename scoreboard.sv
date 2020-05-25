
import Definitions::*;

class scoreboard;
    txn t;
    mailbox m2s=new();
    virtual inf vif;
	
	logic [ADDRWIDTH - 1 : 0] wrap_address, waddress;
	logic [DATAWIDTH - 1 : 0] wrap_data, wrap_write_data;
	int addr_incr;
	
	localparam MEMDEPTH = 2 ** 8;

	// declare internal variables
	logic	[7:0]		memory[MEMDEPTH];
    
	
	function new(mailbox mbx,virtual inf vif);
	    m2s			=	mbx;
	    this.vif	=	vif;

    endfunction;
    
    task run();
	    forever 
		begin
			@(posedge vif.HCLK);
				//Working
				m2s.get(t);
				
				if(t.HRESETn == 1'b1)
				begin
					
					//Single mode of operation
					if((t.HBURST == SINGLE) && (t.HTRANS == NONSEQ))
					begin
						if(t.HWRITE == 1'b1)
						begin
							Single_OP_write (t.HADDR);
						end
						else
						begin
							Single_OP_read (t.HADDR);
						end
					end
					
					//WRAP Non seq mode of operation
					else if(((t.HBURST == WRAP4) | (t.HBURST == WRAP8) | (t.HBURST == WRAP16)) && (t.HTRANS == NONSEQ))
					begin
						wrap_address = t.HADDR;
						wrap_write_data = wrap_data;
						wrap_data = t.HWDATA;
						addr_incr = 0;
					end
					
					//WRAP Seq mode of operation
					else if(((t.HBURST == WRAP4) | (t.HBURST == WRAP8) | (t.HBURST == WRAP16)) && (t.HTRANS == SEQ))
					begin
						waddress = wrap_address;
						wrap_write_data = wrap_data;
						wrap_data = t.HWDATA;
						
						if(t.HWRITE == 1'b1)
						begin
							case(t.HBURST)
								WRAP4	:begin
											waddress[1:0] = wrap_address[1:0] + addr_incr;
											addr_incr = addr_incr + 1;
											memory[waddress] = wrap_write_data;
										 end
								WRAP8	:begin
											waddress[2:0] = wrap_address[2:0] + addr_incr;
											addr_incr = addr_incr + 1;
											memory[waddress] = wrap_write_data;
										 end
								WRAP16	:begin
											waddress[3:0] = wrap_address[3:0] + addr_incr;
											addr_incr = addr_incr + 1;
											memory[waddress] = wrap_write_data;
										 end
							
							endcase
						end
						else
						begin
							case(t.HBURST)
								WRAP4	:begin
											waddress[1:0] = wrap_address[1:0] + addr_incr;
											addr_incr = addr_incr + 1;
											if(memory[waddress] == t.HRDATA)
											begin
												$display("SUCCESSFULL :::: Actual data = %h, Testbench data = %h", t.HRDATA, memory[waddress], $time);
											end
											else
											begin
												$display("FAILURE :::: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
											end
			     						 end
								WRAP8	:begin
											waddress[2:0] = wrap_address[2:0] + addr_incr;
											addr_incr = addr_incr + 1;
											if(memory[waddress] == t.HRDATA)
											begin
												$display("SUCCESSFULL :::: Actual data = %h, Testbench data = %h", t.HRDATA, memory[waddress], $time);
											end
											else
											begin
												$display("FAILURE :::: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
											end
										 end
								WRAP16	:begin
											waddress[3:0] = wrap_address[3:0] + addr_incr;
											addr_incr = addr_incr + 1;
											if(memory[waddress] == t.HRDATA)
											begin
												$display("SUCCESSFULL :::: Actual data = %h, Testbench data = %h", t.HRDATA, memory[waddress], $time);
											end
											else
											begin
												$display("FAILURE :::: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
											end
										 end
								
								endcase
							end
						end
					
					//INCR Nonseq mode of operation
					else if(((t.HBURST == INCR) | (t.HBURST == INCR4) | (t.HBURST == INCR8) | (t.HBURST == INCR16)) && (t.HTRANS == NONSEQ))
					begin
						wrap_address = t.HADDR;
						addr_incr = 0;
					end
					
					//INCR Seq mode of operation
					else if(((t.HBURST == INCR) | (t.HBURST == INCR4) | (t.HBURST == INCR8) | (t.HBURST == INCR16)) && (t.HTRANS == SEQ))
					begin
						waddress = wrap_address;
						if(t.HWRITE == 1'b1)
						begin
							waddress = wrap_address + addr_incr;
							addr_incr = addr_incr + 1;
							memory[waddress] = t.HWDATA;
						end
						else
						begin
							waddress = wrap_address + addr_incr;
							addr_incr = addr_incr + 1;
							if(memory[waddress] == t.HRDATA)
							begin
								$display("SUCCESSFULL :::: Actual data = %h, Testbench data = %h", t.HRDATA, memory[waddress], $time);
							end
							else
							begin
								$display("FAILURE :::: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
							end
						end
					end
				end
		end
		    
    endtask
	
	
	task Single_OP_write (input logic [31:0] addr);
		logic [31:0] address;
		address = addr;
		fork
		begin
		@(posedge vif.HCLK)
		if(t.HREADY == 1'b1)
		begin
			
				if(t.HTRANS == NONSEQ)
				begin
					memory[address] = t.HWDATA;
				end
		end
		end
		join_none
	
	endtask
	
	task Single_OP_read (input logic [31:0] addr);
		logic [31:0] address;
		address = addr;
		
		fork
		begin
		@(posedge vif.HCLK)
		if(t.HREADY == 1'b1)
		begin
			if(t.HTRANS == NONSEQ)
			begin
				if(memory[address] == t.HRDATA)
				begin
					$display("SUCCESSFULL :::: Actual data = %h, Testbench data = %h", t.HWDATA, memory[address], $time);
				end
				else
				begin
					$display("FAILURE :::: Actual data = %h, Testbench data = %h, testbech address = %h", t.HWDATA, memory[address], address, $time);
				end
			end
			
		end
		end
		join_none
	
	endtask
    
	
endclass

