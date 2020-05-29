
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
    
	logic   [31:0]	HRDATA, d[1:16];
	logic         	HRESP;


	function new(mailbox mbx);
		this.mbx = mbx;
	endfunction

	
	task run();
		
		//Reset
			driver_send(0, 	0, 			0, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(0, 	0, 			0, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(0, 	0, 			0, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
		
		repeat(10000)
		begin
			pkt=new();
			assert(pkt.randomize);
			//pkt.print("Generator data and address ");
			d[1] = pkt.HWDATA;
			d[2] = pkt.HWDATA + 1;
			d[3] = pkt.HWDATA + 2;
			d[4] = pkt.HWDATA + 3;
			d[5] = pkt.HWDATA + 4;
			d[6] = pkt.HWDATA + 5;
			d[7] = pkt.HWDATA + 6;
			d[8] = pkt.HWDATA + 7;
			d[9] = pkt.HWDATA + 8;
			d[10] = pkt.HWDATA + 9;
			d[11] = pkt.HWDATA + 10;
			d[12] = pkt.HWDATA + 11;
			d[13] = pkt.HWDATA + 12;
			d[14] = pkt.HWDATA + 13;
			d[15] = pkt.HWDATA + 14;
			d[16] = pkt.HWDATA + 15;
			
			

			//Single Write followed by Single read for a specific address
			//$display("Single Write followed by Single read for a specific address");
			driver_send(1, 	d[1], 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	0, pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	0, 	0, 	1, 	0);
			
			//INCR Write 
			//$display("INCR Write");
			driver_send(1, 	 0, 			pkt.HADDR, 	0, 	  INCR, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	d[2],		    pkt.HADDR, 	0, 	  INCR, 	   SEQ, 	1, 	0, 	1, 	0);
			
			//INCR Read
			//$display("INCR Read");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR, 	NONSEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	pkt.HWDATA, pkt.HADDR, 	0, 	  INCR, 	   SEQ, 	0, 	0, 	1, 	0);
			
			//INCR4 Write
			//$display("INCR4 Write");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	1, 	0, 	1, 	0);
			for(int i = 1; i<=4; i = i + 1)
			begin
				driver_send(1, 	d[i], pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
			end
			
			
			//INCR4 Read 
			//$display("INCR4 Read");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(5)
			begin
			driver_send(1, 	0,			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			//INCR8 Write
			//$display("INCR8 Write");
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  INCR8, 	NONSEQ, 	1, 	0, 	1, 	0);
			for(int i = 1; i<=8; i = i + 1)
			begin
				driver_send(1, 	d[i], pkt.HADDR, 	0, 	  INCR8, 	   SEQ, 	1, 	0, 	1, 	0);
			end
	
			
			//INCR8 Read 
			//$display("INCR8 Read");
			driver_send(1, 	0,	pkt.HADDR, 	0, 	  INCR8, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(9)
			begin
			driver_send(1, 	0,  pkt.HADDR, 	0, 	  INCR8, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			//INCR16 Write
			//$display("INCR16 Write");
			driver_send(1, 	0, pkt.HADDR, 	0, 	  INCR16, 	NONSEQ, 	1, 	0, 	1, 	0);
			for(int i = 1; i<=16; i = i + 1)
			begin
				driver_send(1, 	d[i], pkt.HADDR, 	0, 	  INCR16, 	   SEQ, 	1, 	0, 	1, 	0);
			end
	
			
			//INCR16 Read
			//$display("INCR16 Read");
			driver_send(1, 	0, pkt.HADDR, 	0, 	  INCR16, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(16)
			begin
			driver_send(1, 	0, pkt.HADDR, 	0, 	  INCR16, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			//WRAP4 Write
			//$display("WRAP4 Write");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	1, 	0, 	1, 	0);
			for(int i = 1; i<=4; i = i + 1)
			begin
				driver_send(1, 	d[i], pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
			end
	
			
			//WRAP4 Read 
			//$display("WRAP4 Read");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(9)
			begin
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			//WRAP8 Write
			//$display("WRAP8 Write");
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  WRAP8, 	NONSEQ, 	1, 	0, 	1, 	0);
			for(int i = 1; i<=8; i = i + 1)
			begin
				driver_send(1, 	d[i], pkt.HADDR, 	0, 	  WRAP8, 	   SEQ, 	1, 	0, 	1, 	0);
			end
			
			
			
			//WRAP8 Read 
			//$display("WRAP8 Read ");
			driver_send(1, 	0, pkt.HADDR, 	0, 	  WRAP8, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(17)
			begin
			driver_send(1, 	0, pkt.HADDR, 	0, 	  WRAP8, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			//WRAP16 Write
			//$display("WRAP16 Write");
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  WRAP16, 	NONSEQ, 	1, 	0, 	1, 	0);
			for(int i = 1; i<=16; i = i + 1)
			begin
				driver_send(1, 	d[i], pkt.HADDR, 	0, 	  WRAP16, 	   SEQ, 	1, 	0, 	1, 	0);
			end
			
			
			
			//WRAP16 Read
			//$display("WRAP16 Read");
			driver_send(1, 			 0, pkt.HADDR, 	0, 	  WRAP16, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(33)
			begin
			driver_send(1, 	0, pkt.HADDR, 	0, 	  WRAP16, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			
			
			//SINGLE write followed by INCR4 read
			//$display("SINGLE write followed by INCR4 read");
			driver_send(1, 	d[1], 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(4)
			begin
			driver_send(1, 	0,			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			
			//SINGLE write followed by INCR8 read
			//$display("SINGLE write followed by INCR8 read");
			driver_send(1, 	d[2], 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR8, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(4)
			begin
			driver_send(1, 	0,			pkt.HADDR, 	0, 	  INCR8, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			//SINGLE write followed by INCR16 read
			//$display("SINGLE write followed by INCR16 read");
			driver_send(1, 	d[3], 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR16, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(4)
			begin
			driver_send(1, 	0,			pkt.HADDR, 	0, 	  INCR16, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			
			//SINGLE write followed by WRAP4 read
			//$display("SINGLE write followed by WRAP4 read");
			driver_send(1, 	d[1], 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(4)
			begin
			driver_send(1, 	0,			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			
			//SINGLE write followed by WRAP8 read
			//$display("SINGLE write followed by WRAP8 read");
			driver_send(1, 	d[2], 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP8, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(8)
			begin
			driver_send(1, 	0,			pkt.HADDR, 	0, 	  WRAP8, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			//SINGLE write followed by WRAP16 read
			//$display("SINGLE write followed by WRAP16 read");
			driver_send(1, 	d[3], 			pkt.HADDR, 	0, 	SINGLE, 	NONSEQ, 	1, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP16, 	NONSEQ, 	0, 	0, 	1, 	0);
			repeat(16)
			begin
			driver_send(1, 	0,			pkt.HADDR, 	0, 	  WRAP16, 	   SEQ, 	0, 	0, 	1, 	0);
			end
			
			
			//INCR4 write and read with IDLE state inbetween write operation
			//$display("INCR4 write and read with IDLE state inbetween write operation");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	7, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);	
				driver_send(1, 	2, pkt.HADDR, 	0, 	  INCR4, 	   IDLE, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  INCR4, 	   IDLE, 	1, 	0, 	1, 	0);
				driver_send(1, 	1, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	4, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);	
				
	
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	0, 	0, 	1, 	0);
			
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			
			
			//INCR4 write and read with IDLE state inbetween read operation
			//$display("INCR4 write and read with IDLE state inbetween read operation");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	7, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);	
				driver_send(1, 	2, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	1, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	4, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);	
				
	
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	0, 	0, 	1, 	0);
			
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   IDLE, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   IDLE, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			
			
			
			//WRAP4 write and read with IDLE state inbetween write operation
			//$display("WRAP4 write and read with IDLE state inbetween write operation");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	7, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);	
				driver_send(1, 	2, pkt.HADDR, 	0, 	  WRAP4, 	   IDLE, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  WRAP4, 	   IDLE, 	1, 	0, 	1, 	0);
				driver_send(1, 	1, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	4, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);	
				
	
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	0, 	0, 	1, 	0);
			
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			
			
			//WRAP4 write and read with IDLE state inbetween read operation
			//$display("WRAP4 write and read with IDLE state inbetween read operation");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	7, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);	
				driver_send(1, 	2, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	1, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	4, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);	
				
	
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	0, 	0, 	1, 	0);
			
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   IDLE, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   IDLE, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			
			
			
			
			
			//BUSY
			
			
			
			
			//INCR4 write and read with BUSY state inbetween write operation
			//$display("INCR4 write and read with BUSY state inbetween write operation");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	7, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);	
				driver_send(1, 	2, pkt.HADDR, 	0, 	  INCR4, 	   BUSY, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  INCR4, 	   BUSY, 	1, 	0, 	1, 	0);
				driver_send(1, 	1, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	4, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);	
				
	
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	0, 	0, 	1, 	0);
			
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			
			
			//INCR4 write and read with BUSY state inbetween read operation
			//$display("INCR4 write and read with BUSY state inbetween read operation");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	7, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);	
				driver_send(1, 	2, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	1, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	4, pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	1, 	0, 	1, 	0);	
				
	
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	NONSEQ, 	0, 	0, 	1, 	0);
			
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   BUSY, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   BUSY, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  INCR4, 	   SEQ, 	0, 	0, 	1, 	0);
			
			
			
			//WRAP4 write and read with BUSY state inbetween write operation
			//$display("WRAP4 write and read with BUSY state inbetween write operation");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	7, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);	
				driver_send(1, 	2, pkt.HADDR, 	0, 	  WRAP4, 	   BUSY, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  WRAP4, 	   BUSY, 	1, 	0, 	1, 	0);
				driver_send(1, 	1, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	4, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);	
				
	
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	0, 	0, 	1, 	0);
			
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			
			
			//WRAP4 write and read with BUSY state inbetween read operation
			//$display("WRAP4 write and read with BUSY state inbetween read operation");
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	7, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);	
				driver_send(1, 	2, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	3, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	1, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);
				driver_send(1, 	4, pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	1, 	0, 	1, 	0);	
				
	
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	NONSEQ, 	0, 	0, 	1, 	0);
			
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   BUSY, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   BUSY, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);
			driver_send(1, 	0, 			pkt.HADDR, 	0, 	  WRAP4, 	   SEQ, 	0, 	0, 	1, 	0);		
			
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

