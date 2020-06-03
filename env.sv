//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : env.sv                                                                                           //                                                          //
// Term      : Spring 2020                                                                                      //
// Authors   : Kaustubh Mhatre 							                                     	                //
// Date      : 05/20/2020                                                                                       //
// Version   : 1                                                                                                //
// Reference :                                                                                                  //
// Portland State University                                                                                    //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import Definitions::*;
`include "coverage_ahb.sv"

class env;

	//Object of generator
	gen g;
	
	//Object of driver
	driver d;
	
	//Object of monitor
	monitor m;
	
	//Object of scoreboard
	scoreboard scr;
	
	//Object of coverage
	coverage cov;
	
	//Mailbox for connection between generator and driver
	mailbox mbx=new();
	
	//Mailbox for connection between monitor and scoreboard
	mailbox mbx2=new();

	//Virtual interface for connection between driver and DUT (snooped by monitor and scoreboard)
	virtual inf vif;
	
	//New function
	function new(virtual inf tif);
		this.vif=tif;
	endfunction
	
	//Run task
	task run();
		g=new(mbx);
		d=new(mbx,vif);
		m=new(vif,mbx2);
		scr=new(mbx2,vif);
		cov=new(vif);
		
		//Concurrent operation
		fork
			g.run();
			d.run();
			m.run();
			scr.run();
			cov.run();
		join
	
	endtask

endclass
