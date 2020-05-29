
import Definitions::*;
`include "coverage_ahb.sv"

class env;
	gen g;
	driver d;
	monitor m;
	scoreboard scr;
	coverage cov;
  
	mailbox mbx=new();
	mailbox mbx2=new();

	virtual inf vif;
	
	function new(virtual inf tif);
		this.vif=tif;
	endfunction
  
	task run();
		g=new(mbx);
		d=new(mbx,vif);
		m=new(vif,mbx2);
		scr=new(mbx2,vif);
		cov=new(vif);
		
		fork
			g.run();
			d.run();
			m.run();
			scr.run();
			cov.run();
		join
	
	endtask

endclass
