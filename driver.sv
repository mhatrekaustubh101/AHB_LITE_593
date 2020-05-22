
//`include "scenario_1.sv"


import Definitions::*;



class driver;
  
  virtual inf vif;
  txn pkt;
  mailbox mbx=new();
  
  function new(mailbox mbx,virtual inf vif);
	  this.mbx=mbx;
	  this.vif=vif;
  endfunction

  task run();
		pkt=new();
		forever 
		begin
			mbx.get(pkt);
			pkt.print("Driver address and data");
			driver_item(pkt);
		end
  endtask

  
   task driver_item(txn t);
		
		int count;
		
		if(t.HBURST == SINGLE)
		begin
				
			@(posedge vif.HCLK);
				vif.HRESETn = 1;
				vif.HWDATA = 0;
				vif.HADDR = t.HADDR;
				vif.HSIZE = t.HSIZE;
				vif.HBURST = t.HBURST;
				vif.HTRANS = NONSEQ;
				vif.HWRITE = 1;
				vif.HMASTLOCK = t.HMASTLOCK;
				vif.HREADY = t.HREADY;
				vif.HPROT = t.HPROT;
				
			@(posedge vif.HCLK);
				vif.HRESETn = 1;
				vif.HWDATA = t.HWDATA;
				vif.HADDR = t.HADDR;
				vif.HSIZE = t.HSIZE;
				vif.HBURST = t.HBURST;
				vif.HTRANS = NONSEQ;
				vif.HWRITE = 0;
				vif.HMASTLOCK = t.HMASTLOCK;
				vif.HREADY = t.HREADY;
				vif.HPROT = t.HPROT;
		
			@(posedge vif.HCLK);
		end
		else if(t.HBURST == INCR | t.HBURST == INCR4 | t.HBURST == INCR8 | t.HBURST == INCR16 |
			t.HBURST == WRAP4 | t.HBURST == WRAP8 | t.HBURST == WRAP16)
		begin
			case(t.HBURST)
				INCR	: begin
							count = 1;
						  end
				INCR4, WRAP4	: begin
							count = 4;
						  end
				INCR8, WRAP8	: begin
							count = 8;
						  end
				INCR16, WRAP16	: begin
							count = 16;
						  end
			
			endcase
			@(posedge vif.HCLK);
				vif.HRESETn = 1;
				vif.HWDATA = 0;
				vif.HADDR = t.HADDR;
				vif.HSIZE = t.HSIZE;
				vif.HBURST = t.HBURST;
				vif.HTRANS = NONSEQ;
				vif.HWRITE = 1;
				vif.HMASTLOCK = t.HMASTLOCK;
				vif.HREADY = t.HREADY;
				vif.HPROT = t.HPROT;
			for(int i = 1; i <= count; i = i + 1)
			begin
			@(posedge vif.HCLK);
				vif.HRESETn = 1;
				vif.HWDATA = t.HWDATA + i - 1;
				vif.HADDR = 0;
				vif.HSIZE = t.HSIZE;
				vif.HBURST = t.HBURST;
				vif.HTRANS = SEQ;
				vif.HWRITE = 1;
				vif.HMASTLOCK = t.HMASTLOCK;
				vif.HREADY = t.HREADY;
				vif.HPROT = t.HPROT;
			end
			
			@(posedge vif.HCLK);
				vif.HRESETn = 1;
				vif.HWDATA = 0;
				vif.HADDR = t.HADDR;
				vif.HSIZE = t.HSIZE;
				vif.HBURST = t.HBURST;
				vif.HTRANS = NONSEQ;
				vif.HWRITE = 0;
				vif.HMASTLOCK = t.HMASTLOCK;
				vif.HREADY = t.HREADY;
				vif.HPROT = t.HPROT;
			for(int i = 1; i <= count; i = i + 1)
			begin
			@(posedge vif.HCLK);
				vif.HRESETn = 1;
				vif.HWDATA = 0;
				vif.HADDR = 0;
				vif.HSIZE = t.HSIZE;
				vif.HBURST = t.HBURST;
				vif.HTRANS = SEQ;
				vif.HWRITE = 0;
				vif.HMASTLOCK = t.HMASTLOCK;
				vif.HREADY = t.HREADY;
				vif.HPROT = t.HPROT;
			end
		end
		
		
  endtask 
  
endclass