//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : driver.sv                                                                                        //                                                          //
// Term      : Spring 2020                                                                                      //
// Authors   : Kaustubh Mhatre 								                                   	                //
// Date      : 05/23/2020                                                                                       //
// Version   : 2                                                                                                //
// Reference :                                                                                                  //
// Portland State University                                                                                    //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import Definitions::*;



class driver;
	
	//Virtual interface to link send data to DUT
	virtual inf vif;
	
	//Transaction object to collect data sent by generator
	txn pkt;
	
	//Mailbox to connect to generator mailbox
	mailbox mbx=new();
	
	//New function
	function new(mailbox mbx,virtual inf vif);
		this.mbx=mbx;
		this.vif=vif;
	endfunction

	//Run task
	task run();
		pkt=new();
		forever 
		begin
			mbx.get(pkt);
			//pkt.print("Driver address and data");
			driver_item(pkt);
			
		end
	endtask

	//Task to drive data sent from the generator to the DUT via virtual interface
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