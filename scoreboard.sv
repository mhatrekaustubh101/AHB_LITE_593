
import Definitions::*;

class scoreboard;
    txn t;
    mailbox m2s=new();
    virtual inf vif;
    
	
	function new(mailbox mbx,virtual inf vif);
	    m2s			=	mbx;
	    this.vif	=	vif;

    endfunction;
    
    task run();
	    forever 
		begin
			@(posedge vif.HCLK)
				m2s.get(t);
				$display("ADDR = %h,	DATA = %h", t.HADDR, t.HRDATA);
		end
		    
    endtask;
    
	
endclass

