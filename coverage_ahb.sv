
import Definitions::*;

class coverage;

	virtual inf vinf;
	
	logic   [DATAWIDTH-1:0]			HWDATA;
	logic   [DATAWIDTH-1:0]			HRDATA;
	logic   [ADDRWIDTH-1:0]			HADDR;
	logic   [DATATRANFER_SIZE-1:0]	HSIZE;
	
	logic 	HRESETn;
	logic	HWRITE;
	logic	HMASTLOCK, HREADY;
	logic   [3:0]	HPROT;
	//logic   HSEL;
    
	
	Response_t	HRESP;
	BType_t		HBURST;
	Trans_t		HTRANS;
	
	
	covergroup cg_ahb;

//------------------------------------------BASIC COVERAGE----------------------------------------------//	
		/*
		slave_response: coverpoint HRESP {	//OKAY or ERROR response
			bins OKAY	= {1'b0};
			bins ERROR	= {1'b1};
			}
		*/	
		burst: coverpoint HBURST {	//BURST transfers
			bins SINGLE	= {3'b000};
			bins INCR	= {3'b001};
			bins WRAP4	= {3'b010};
			bins INCR4	= {3'b011};
			bins WRAP8	= {3'b100};
			bins INCR8	= {3'b101};
			bins WRAP16	= {3'b110};
			bins INCR16	= {3'b111};
			}
			
		transfer_type: coverpoint HTRANS {	//transfer types
			bins IDLE	= {2'b00};
			bins BUSY	= {2'b01};
			bins NONSEQ	= {2'b10};
			bins SEQ	= {2'b11};
			}
		/*	
		burst_nonseq_seq: coverpoint HTRANS {	//burst sequence except SINGLE
			bins NONSEQ_SEQ			= {NONSEQ => SEQ};
			illegal_bins SEQ_NONSEQ	= {SEQ => NONSEQ};
			}
			
		slave_select: coverpoint HSEL {		//slave select based on the DECODER
			bins SLAVE_0	= {1'b0};
			bins SLAVE_1	= {1'b1};
			}
		*/	
		ready_master_slave: coverpoint HREADY {		//master slave ready for data transfer
			bins READY	= {1'b1};
			bins WAIT	= {1'b0};
			}
			
		reset: coverpoint HRESETn {		//reset signal ACTIVE LOW
			bins RESET_asserted		= {1'b0};
			bins RESET_deasserted	= {1'b1};
			}
			
		data_size : coverpoint HSIZE {		//size of a transfer
			bins BYTE		= {3'b000};
			//bins HALF_WORD	= {3'b001};
			//bins WORD		= {3'b010};
			ignore_bins SIZE_INVALID[] = {[3'b001:3'b111]};
			}
			
		master_read_data: coverpoint HRDATA {	//data for read operation
			bins READ_DATA[] = {[0:255]} iff (HWRITE==0);
			}
			
		master_broadcast_data: coverpoint HWDATA {	//data for write operation
			bins WRITE_DATA[]	= {[0:255]} iff (HWRITE==1);
			}
		
		master_read_addr: coverpoint HADDR {	//address for read operation
			bins READ_addr[]	= {[0:255]} iff (HWRITE==0);
			}
			
		master_write_addr: coverpoint HADDR {	//address for write operation
			bins WRITE_addr[]	= {[0:255]} iff (HWRITE==1);
			}
		
		data_operations: coverpoint HWRITE {	//read or write operations
			bins READ			= {1'b0};
			bins WRITE			= {1'b1};
			}
			
		read_write_transitions: coverpoint HWRITE {		//read write transitions
			bins READ_WRITE			= (0 => 1);
			bins WRITE_READ			= (1 => 0);
			bins READ_WRITE_SINGLE	= (0 => 1) iff (HBURST==SINGLE);
			bins WRITE_READ_SINGLE	= (1 => 0) iff (HBURST==SINGLE);
			bins READ_WRITE_INCR	= (0 => 1) iff (HBURST==INCR);
			bins WRITE_READ_INCR	= (1 => 0) iff (HBURST==INCR);
			bins READ_WRITE_INCR4	= (0 => 1) iff (HBURST==INCR4);
			bins WRITE_READ_INCR4	= (1 => 0) iff (HBURST==INCR4);
			bins READ_WRITE_INCR8	= (0 => 1) iff (HBURST==INCR8);
			bins WRITE_READ_INCR8	= (1 => 0) iff (HBURST==INCR8);
			bins READ_WRITE_INCR16	= (0 => 1) iff (HBURST==INCR16);
			bins WRITE_READ_INCR16	= (1 => 0) iff (HBURST==INCR16);
			bins READ_WRITE_WRAP4	= (0 => 1) iff (HBURST==WRAP4);
			bins WRITE_READ_WRAP4	= (1 => 0) iff (HBURST==WRAP4);
			bins READ_WRITE_WRAP8	= (0 => 1) iff (HBURST==WRAP8);
			bins WRITE_READ_WRAP8	= (1 => 0) iff (HBURST==WRAP8);
			bins READ_WRITE_WRAP16	= (0 => 1) iff (HBURST==WRAP16);
			bins WRITE_READ_WRAP16	= (1 => 0) iff (HBURST==WRAP16);
			}
			
		burst_transitions: coverpoint HBURST {		//transitions based on the generator scenarios
			bins SINGLE_SINGLE  = (SINGLE => SINGLE);
			bins SINGLE_INCR4	= (SINGLE => INCR4);
			bins SINGLE_INCR8	= (SINGLE => INCR8);
			bins SINGLE_INCR16	= (SINGLE => INCR16);
			bins SINGLE_WRAP4	= (SINGLE => WRAP4);
			bins SINGLE_WRAP8	= (SINGLE => WRAP8);
			bins SINGLE_WRAP16	= (SINGLE => WRAP16);
			
			bins INCR4_SINGLE   = (INCR4 => SINGLE);
			bins INCR4_INCR4	= (INCR4 => INCR4);
			bins INCR4_INCR8	= (INCR4 => INCR8);
			bins INCR4_INCR16	= (INCR4 => INCR16);
			bins INCR4_WRAP4	= (INCR4 => WRAP4);
			bins INCR4_WRAP8	= (INCR4 => WRAP8);
			bins INCR4_WRAP16	= (INCR4 => WRAP16);
			
			bins INCR8_SINGLE   = (INCR8 => SINGLE);
			bins INCR8_INCR4	= (INCR8 => INCR4);
			bins INCR8_INCR8	= (INCR8 => INCR8);
			bins INCR8_INCR16	= (INCR8 => INCR16);
			bins INCR8_WRAP4	= (INCR8 => WRAP4);
			bins INCR8_WRAP8	= (INCR8 => WRAP8);
			bins INCR8_WRAP16	= (INCR8 => WRAP16);
			
			bins INCR16_SINGLE  = (INCR16 => SINGLE);
			bins INCR16_INCR4	= (INCR16 => INCR4);
			bins INCR16_INCR8	= (INCR16 => INCR8);
			bins INCR16_INCR16	= (INCR16 => INCR16);
			bins INCR16_WRAP4	= (INCR16 => WRAP4);
			bins INCR16_WRAP8	= (INCR16 => WRAP8);
			bins INCR16_WRAP16	= (INCR16 => WRAP16);
			
			bins WRAP4_SINGLE   = (WRAP4 => SINGLE);
			bins WRAP4_INCR4	= (WRAP4 => INCR4);
			bins WRAP4_INCR8	= (WRAP4 => INCR8);
			bins WRAP4_INCR16	= (WRAP4 => INCR16);
			bins WRAP4_WRAP4	= (WRAP4 => WRAP4);
			bins WRAP4_WRAP8	= (WRAP4 => WRAP8);
			bins WRAP4_WRAP16	= (WRAP4 => WRAP16);
			
			bins WRAP8_SINGLE   = (WRAP8 => SINGLE);
			bins WRAP8_INCR4	= (WRAP8 => INCR4);
			bins WRAP8_INCR8	= (WRAP8 => INCR8);
			bins WRAP8_INCR16	= (WRAP8 => INCR16);
			bins WRAP8_WRAP4	= (WRAP8 => WRAP4);
			bins WRAP8_WRAP8	= (WRAP8 => WRAP8);
			bins WRAP8_WRAP16	= (WRAP8 => WRAP16);
			
			bins WRAP16_SINGLE  = (WRAP16 => SINGLE);
			bins WRAP16_INCR4	= (WRAP16 => INCR4);
			bins WRAP16_INCR8	= (WRAP16 => INCR8);
			bins WRAP16_INCR16	= (WRAP16 => INCR16);
			bins WRAP16_WRAP4	= (WRAP16 => WRAP4);
			bins WRAP16_WRAP8	= (WRAP16 => WRAP8);
			bins WRAP16_WRAP16	= (WRAP16 => WRAP16);
			
			bins INCR_INCR 		= (INCR => INCR);
			}
			
//------------------------------------------CROSS COVERAGE----------------------------------------------//
		
		/*read_write_okay: cross read_write_transitions, slave_response {		//all responses for read and write transitions must be OKAY
			ignore_bins other = binsof(read_write_transitions) && binsof(slave_response.ERROR);
			}*/
		/*	
		burst_trans_nonseq_seq: cross burst_nonseq_seq, burst {		//all bursts must undergo transfer type in nonseq to seq order EXCEPT single
			ignore_bins single	= binsof(burst_nonseq_seq) && binsof(burst.SINGLE);
			}
		*/
		/*
		reset_idle: cross reset, transfer_type {	//after reset asserted only IDLE state should be present
			ignore_bins except_IDLE	= binsof(reset.RESET_deasserted) && binsof(burst.BUSY) && binsof(burst.NONSEQ) && binsof(burst.SEQ);
			}
		*/
		/*burst_write_read_cmd_resp: cross read_write_transitions, burst, slave_response {	//read and write transitions must occur in every type of burst and the slave response must be OKAY
			ignore_bins other = binsof(read_write_transitions) && binsof(burst)&& binsof(slave_response.ERROR);
			}*/
			
		burst_read_write_transitions:	cross read_write_transitions, burst;	//
		data_size_burst: 				cross burst, data_size;		//all burst types can have different data size from 1byte to 4bytes
		ready_rw_transitions:			cross read_write_transitions, ready_master_slave;		
		ready_transfer_type:			cross ready_master_slave, transfer_type;	
		rw_transitions_trans_type:		cross read_write_transitions, transfer_type;
		
	endgroup 
		
	
	function new (virtual inf i);
     	cg_ahb = new();
     	vinf = i;
   	endfunction : new
	

   task run();
      forever begin  : sampling_block
		@(posedge vinf.HCLK);
      	HADDR = vinf.HADDR;
		HWDATA = vinf.HWDATA;
      	HWRITE = vinf.HWRITE;
		HTRANS = vinf.HTRANS;
		HSIZE = vinf.HSIZE;
		HBURST = vinf.HBURST;
		HREADY = vinf.HREADY;
		HRDATA = vinf.HRDATA;
		HRESP = vinf.HRESP;
      	 
        cg_ahb.sample();

     
      end : sampling_block
   endtask

			
endclass
		