
import Definitions::*;

class scoreboard;
    txn t;
    mailbox m2s=new();
    virtual inf vif;
	
	logic [ADDRWIDTH - 1 : 0] wrap_address, waddress;
	logic [DATAWIDTH - 1 : 0] wrap_data, wrap_write_data;
	int addr_incr;
	logic [1:0] previous_state;
	logic previous_write;
	logic [2:0] previous_op, i_state;
	logic ability, abilitytemp;
	
	localparam MEMDEPTH = 2 ** 8;

	// declare internal variables
	logic	[31:0]		memory[MEMDEPTH];
    
	
	function new(mailbox mbx,virtual inf vif);
	    m2s			=	mbx;
	    this.vif	=	vif;
		
		for(int i = 0; i < (2 ** 8); i = i + 1)
		begin
			memory[i] = 32'b00000000000000000000000000000000;
		end
    endfunction;
    
    task run();
	    forever 
		begin
			@(posedge vif.HCLK);
				//Working
				m2s.get(t);
				
				if(t.HRESETn == 1'b1)
				begin
				
				
					if((previous_state == IDLE) | (previous_state == BUSY))
					begin
						//$display("IDLE FOUND AT ", $time);
						ability = 1'b0;
					//	waddress = 'x;
					end
				
				
					
					//Single mode of operation
					if((t.HBURST == SINGLE) && (t.HTRANS == NONSEQ))
					begin
						ability = 0;
						abilitytemp = 0;
						previous_pending();
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
						previous_pending();
						
						wrap_address = t.HADDR;
						wrap_write_data = wrap_data;
						addr_incr = 0;
						ability = abilitytemp;
						abilitytemp = 1;
					end
					
					//WRAP Seq mode of operation
					else if(((t.HBURST == WRAP4) | (t.HBURST == WRAP8) | (t.HBURST == WRAP16)) && (((t.HTRANS == SEQ) | (previous_state == IDLE)|(t.HTRANS == IDLE)) | ((t.HTRANS == SEQ) | (previous_state == BUSY)|(t.HTRANS == BUSY))))
					begin
						if(previous_state == IDLE)
						begin
							//$display("WRAP TRAPPED IN IDLE", $time);
							wrap_address = 'z;
							wrap_write_data = 'z;
							waddress = wrap_address;
						end
						else
						begin
							waddress = wrap_address;
							wrap_write_data = t.HWDATA;
						
						if(t.HWRITE == 1'b1)
						begin
							if(previous_state != BUSY)
							begin
							if(previous_state == IDLE)
							begin
								//$display("WRAP TRAPPED IN IDLE", $time);
								wrap_address = 'z;
								wrap_write_data = 'z;
								waddress = wrap_address;
							end
							//$display("data to be written in mem = %h", wrap_write_data, $time);
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
								//$display("Writing on address %h", waddress, $time);
							end
						end
						else
						begin
							case(t.HBURST)
								WRAP4	:begin
											if(ability == 1)
											begin
												waddress[1:0] = wrap_address[1:0] + addr_incr;
												addr_incr = addr_incr + 1;
												if(memory[waddress] == t.HRDATA)
												begin
													$display("SUCCESSFULL ::WRAP4:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
												end
												else
												begin
													$display("FAILURE ::WRAP4:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
												end
											//end
											//else
											//begin
											//	$display("IDLE STATE");
											end
			     						 end
								WRAP8	:begin
											if(ability == 1)
											begin
												waddress[2:0] = wrap_address[2:0] + addr_incr;
												addr_incr = addr_incr + 1;
												if(memory[waddress] == t.HRDATA)
												begin
													$display("SUCCESSFULL ::WRAP8:: Actual data = %h, Testbench data = %h", t.HRDATA, memory[waddress], $time);
												end
												else
												begin
													$display("FAILURE ::WRAP8:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
												end
											//end
											//else
											//begin
											//	$display("IDLE STATE");
											end
										 end
								WRAP16	:begin
											if(ability == 1)
											begin
												waddress[3:0] = wrap_address[3:0] + addr_incr;
												addr_incr = addr_incr + 1;
												if(memory[waddress] == t.HRDATA)
												begin
													$display("SUCCESSFULL ::WRAP16:: Actual data = %h, Testbench data = %h", t.HRDATA, memory[waddress], $time);
												end
												else
												begin
													$display("FAILURE ::WRAP16:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
												end
											//end
											//else
											//begin
											//	$display("IDLE STATE");
											end
										 end
								
							endcase
						end
						end
					end
					
					//INCR Nonseq mode of operation
					else if(((t.HBURST == INCR) | (t.HBURST == INCR4) | (t.HBURST == INCR8) | (t.HBURST == INCR16)) && (t.HTRANS == NONSEQ))
					begin
						previous_pending();
						wrap_address = t.HADDR;
						addr_incr = 0;
						ability = 1;
					end
					
					//INCR Seq mode of operation
					else if(((t.HBURST == INCR) | (t.HBURST == INCR4) | (t.HBURST == INCR8) | (t.HBURST == INCR16)) && (((t.HTRANS == SEQ) | (previous_state == IDLE)|(t.HTRANS == IDLE)) | ((t.HTRANS == SEQ) | (previous_state == BUSY)|(t.HTRANS == BUSY))))
					begin
						if(previous_state == IDLE)
						begin
							//$display("WRAP TRAPPED IN IDLE", $time);
							wrap_address = 'z;
							waddress = wrap_address;
						end
						else
						begin
							waddress = wrap_address;
							if(t.HWRITE == 1'b1)
							begin
								if(previous_state != BUSY)
								begin
									waddress = wrap_address + addr_incr;
									addr_incr = addr_incr + 1;
									memory[waddress] = t.HWDATA;
								end
							end
							else
							begin
								if(ability == 1)
								begin
									waddress = wrap_address + addr_incr;
									addr_incr = addr_incr + 1;
									if(memory[waddress] == t.HRDATA)
									begin
										$display("SUCCESSFULL ::INCR:: Actual data = %h, Testbench data = %h", t.HRDATA, memory[waddress], $time);
									end
									else
									begin
										$display("FAILURE ::INCR:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
									end
								//end
								//else
								//begin
								//	$display("IDLE STATE");
								end
							end
						end
					end
					
					//i_state = previous_state;
					previous_state = t.HTRANS;
					previous_write = t.HWRITE;
					previous_op = t.HBURST;
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
				if(memory[address] == t.HRDATA[7:0])
				begin
					$display("SUCCESSFULL ::SINGLE:: Actual data = %h, Testbench data = %h", t.HWDATA, memory[address], $time);
				end
				else
				begin
					$display("FAILURE ::SINGLE:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HWDATA, memory[address], address, $time);
				end
			end
			
		end
		end
		join_none
	
	endtask
	
	
	
	task previous_pending();
		if(((previous_op == WRAP4) | (previous_op == WRAP8) | (previous_op == WRAP16)) && (previous_state == SEQ))
		begin
			waddress = wrap_address;
			wrap_write_data = t.HWDATA;
			
			if(previous_write == 1'b1)
			begin
				//$display("value of ability = %d", ability);
				//if(ability == 1)
				//begin
					case(previous_op)
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
					//$display("Writing on address %h", waddress, $time);
				//end
			end
			else
			begin
				case(previous_op)
					WRAP4	:begin
								if(ability == 1)
								begin
									waddress[1:0] = wrap_address[1:0] + addr_incr;
									addr_incr = addr_incr + 1;
									if(memory[waddress] == t.HRDATA)
									begin
										$display("SUCCESSFULL ::WRAP4:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
									end
									else
									begin
										$display("FAILURE ::WRAP4:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
									end
								//end
								//else
								//begin
								//	$display("IDLE STATE");
								end
							 end
					WRAP8	:begin
								if(ability == 1)
								begin
									waddress[2:0] = wrap_address[2:0] + addr_incr;
									addr_incr = addr_incr + 1;
									if(memory[waddress] == t.HRDATA)
									begin
										$display("SUCCESSFULL ::WRAP8:: Actual data = %h, Testbench data = %h", t.HRDATA, memory[waddress], $time);
									end
									else
									begin
										$display("FAILURE ::WRAP8:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
									end
								//end
								//else
								//begin
								//	$display("IDLE STATE");
								end
							 end
					WRAP16	:begin
								if(ability == 1)
								begin
									waddress[3:0] = wrap_address[3:0] + addr_incr;
									addr_incr = addr_incr + 1;
									if(memory[waddress] == t.HRDATA)
									begin
										$display("SUCCESSFULL ::WRAP16:: Actual data = %h, Testbench data = %h", t.HRDATA, memory[waddress], $time);
									end
									else
									begin
										$display("FAILURE ::WRAP16:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
									end
								//end
								//else
								//begin
								//	$display("IDLE STATE");
								end
							 end
					
				endcase
			end
		end
		
		
		
		
		
		
		
		
		
		
		
		if(((previous_op == INCR) | (previous_op == INCR4) | (previous_op == INCR8) | (previous_op == INCR16)) && (previous_state == SEQ))
		begin
			waddress = wrap_address;
			if(previous_write == 1'b1)
			begin
				//if(ability == 1)
				//begin
					waddress = wrap_address + addr_incr;
					addr_incr = addr_incr + 1;
					memory[waddress] = t.HWDATA;
				//end
			end
			else
			begin
				if(ability == 1)
				begin
					waddress = wrap_address + addr_incr;
					addr_incr = addr_incr + 1;
					if(memory[waddress] == t.HRDATA)
					begin
						$display("SUCCESSFULL ::INCR:: Actual data = %h, Testbench data = %h", t.HRDATA, memory[waddress], $time);
					end
					else
					begin
						$display("FAILURE ::INCR:: Actual data = %h, Testbench data = %h, testbech address = %h", t.HRDATA, memory[waddress], waddress, $time);
					end
				//end
				//else
				//begin
				//	$display("IDLE STATE");
				end
			end
		end
		
	
	endtask
    
	
endclass

