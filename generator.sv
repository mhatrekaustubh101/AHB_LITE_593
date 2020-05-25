
import Definitions::*;

class gen;
	txn pkt;
	txn t;
	mailbox mbx=new();
  
	logic         	HRESETn;
	logic  [31:0]	HWDATA;
	logic  [31:0]	HADDR;
	logic  [2:0]	HSIZE;
	logic	[2:0]	HBURST;
	logic		[1:0]	HTRANS;
	logic        	HWRITE; 
	logic			HMASTLOCK; 
	logic			HREADY;
	logic   [3:0]	HPROT;
    
	logic   [31:0]	HRDATA;
	logic         	HRESP;


	function new(mailbox mbx);
		this.mbx = mbx;
	endfunction

	
	task run();
		repeat(10000)
		begin
			pkt=new();
			assert(pkt.randomize);
			//pkt.print("Generator data and address ");
			
			
			//Reset
			driver_send(0, 	0, 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(0, 	0, 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(0, 	0, 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);

			//Single Write followed by Single read for a specific address
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	0, 	0, 	1, 	0);
			
			//INCR Write 
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  INCR, 	   SEQ, 	1, 	0, 	1, 	0);
			
			//INCR Read
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR, 	NONSEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  INCR, 	   SEQ, 	0, 	0, 	1, 	0);
			
			//INCR4 Write 
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	1, 	0, 	1, 	0);
			repeat(4)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
			end
			
			//INCR4 Read 
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(4)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			//INCR8 Write 
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  INCR8, 	NONSEQ, 	1, 	0, 	1, 	0);
			repeat(8)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  INCR8, 	   SEQ, 	1, 	0, 	1, 	0);
			end
			
			//INCR8 Read 
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  INCR8, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(8)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  INCR8, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			//INCR16 Write 
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  INCR16, 	NONSEQ, 	1, 	0, 	1, 	0);
			repeat(16)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  INCR16, 	   SEQ, 	1, 	0, 	1, 	0);
			end
			
			//INCR16 Read 
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  INCR16, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(16)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  INCR16, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			//WRAP4 Write 
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	1, 	0, 	1, 	0);
			repeat(4)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
			end
			
			//WRAP4 Read 
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(4)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			//WRAP8 Write 
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  WRAP8, 	NONSEQ, 	1, 	0, 	1, 	0);
			repeat(8)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  WRAP8, 	   SEQ, 	1, 	0, 	1, 	0);
			end
			
			//WRAP8 Read 
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  WRAP8, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(8)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  WRAP8, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			//WRAP16 Write 
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  WRAP16, 	NONSEQ, 	1, 	0, 	1, 	0);
			repeat(16)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  WRAP16, 	   SEQ, 	1, 	0, 	1, 	0);
			end
			
			//WRAP16 Read 
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  WRAP16, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(16)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  WRAP16, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			
			
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	2,		 	pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(4)
			begin
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			end
		end
	endtask
  
	task driver_send(
						input
							logic                          HRESETn,
							logic   [DATAWIDTH-1:0]        HWDATA,
							logic   [ADDRWIDTH-1:0]        HADDR,
							logic   [DATATRANFER_SIZE-1:0] HSIZE,
							BType_t                        HBURST,
							Trans_t                        HTRANS,
							logic                          HWRITE, HMASTLOCK, HREADY,
							logic   [3:0]                  HPROT
							
					);
		t = new();
		t.HRESETn	=	HRESETn;
		t.HWDATA	=	HWDATA;
		t.HADDR		=	HADDR;
		t.HSIZE		=	HSIZE;
		t.HBURST	=	HBURST;
		t.HTRANS	=	HTRANS;
		t.HWRITE	=	HWRITE; 
		t.HMASTLOCK	=	HMASTLOCK; 
		t.HREADY	=	HREADY;
		t.HPROT		=	HPROT;
		t.HRDATA	=	HRDATA;
		t.HRESP		=	HRESP;
		
		mbx.put(t);
  
	endtask

endclass

