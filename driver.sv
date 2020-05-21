
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
      forever begin
	  mbx.get(pkt);
	  pkt.print("Driver address and data");
	  driver_item(pkt);
      end
  endtask

  task driver_item(txn t);
		
		@(posedge vif.HCLK);
			vif.HRESETn = 1;
			vif.HWDATA = '0;
			vif.HADDR = '0;
			vif.HSIZE = 1;
			vif.HBURST = SINGLE;
			vif.HTRANS = IDLE;
			vif.HWRITE = 0;
			vif.HMASTLOCK = 0;
			vif.HREADY = 1;
			vif.HPROT = 0;
			
		@(posedge vif.HCLK);
			vif.HRESETn = 1;
			vif.HWDATA = 0;
			vif.HADDR = t.addr_in;
			vif.HSIZE = 1;
			vif.HBURST = SINGLE;
			vif.HTRANS = NONSEQ;
			vif.HWRITE = 1;
			vif.HMASTLOCK = 0;
			vif.HREADY = 1;
			vif.HPROT = 0;
			
		@(posedge vif.HCLK);
			vif.HRESETn = 1;
			vif.HWDATA = t.data_in;
			vif.HADDR = t.addr_in;
			vif.HSIZE = 1;
			vif.HBURST = SINGLE;
			vif.HTRANS = NONSEQ;
			vif.HWRITE = 0;
			vif.HMASTLOCK = 0;
			vif.HREADY = 1;
			vif.HPROT = 0;
	
		@(posedge vif.HCLK);
		@(posedge vif.HCLK);
		@(posedge vif.HCLK);
  endtask 

endclass
