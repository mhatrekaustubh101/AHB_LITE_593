//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : monitor.sv                                                                                       //                                                          //
// Term      : Spring 2020                                                                                      //
// Authors   : Kaustubh Mhatre 							                                    	                //
// Date      : 05/20/2020                                                                                       //
// Version   : 1                                                                                                //
// Reference :                                                                                                  //
// Portland State University                                                                                    //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import Definitions::*;

class monitor;

	//Virtual interface to get data from the interface connecting driver and DUT
    virtual inf vif;
	
	//Mailbox to send data to the Scoreboard
    mailbox mon2scr;
	
	//Object of transaction class to send data to Scoreboard
    txn t;
  
	//New function
    function new(virtual inf vif,mailbox mbx);
		this.vif	=	vif;
		mon2scr		=	mbx;
		t			=	new();
    endfunction
    
	//Run task
    task run();
		forever
		begin
			sample();
		end
    endtask

	//Sample task to send data to the scoreboard via mailbox
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
