
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
			//pkt.print("Driver address and data");
			driver_item(pkt);
			
		end
  endtask

  
   task driver_item(txn t);
				
			
				vif.HRESETn 	= t.HRESETn;
				vif.HWDATA 		= t.HWDATA;
				vif.HADDR 		= t.HADDR;
				vif.HSIZE 		= t.HSIZE;
				vif.HBURST 		= t.HBURST;
				vif.HTRANS 		= t.HTRANS;
				vif.HWRITE 		= t.HWRITE;
				vif.HMASTLOCK 	= t.HMASTLOCK;
				vif.HREADY 		= t.HREADY;
				vif.HPROT 		= t.HPROT;
				@(posedge vif.HCLK);
  endtask 
  
endclass