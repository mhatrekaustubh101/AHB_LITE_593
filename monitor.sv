
import Definitions::*;

class monitor;
    virtual inf vif;
    mailbox mon2scr;
    txn t;
  
    function new(virtual inf vif,mailbox mbx);
		this.vif	=	vif;
		mon2scr		=	mbx;
		t			=	new();
    endfunction
    
    task run();
		forever
		begin
			sample();
		end
    endtask

    task sample();
		@(posedge vif.HCLK);
			t.HRESETn	=	vif.HRESETn;
			t.HWDATA	=	vif.HWDATA;
			t.HADDR		=	vif.HADDR;
			t.HSIZE		=	vif.HSIZE;
			t.HBURST	=	vif.HBURST;
			t.HTRANS	=	vif.HTRANS;
			t.HWRITE	=	vif.HWRITE; 
			t.HMASTLOCK	=	vif.HMASTLOCK; 
			t.HREADY	=	vif.HREADY;
			t.HPROT		=	vif.HPROT;
			t.HRDATA	=	vif.HRDATA;
			t.HRESP		=	vif.HRESP;
	  //$display($time,"monitor dataout %h",vif.data_out);
	  //t.print("monitor_realwala");
	  mon2scr.put(t);
    endtask

endclass
