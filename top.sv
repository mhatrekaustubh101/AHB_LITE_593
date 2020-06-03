//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : top.sv                                                                                           //                                                          //
// Term      : Spring 2020                                                                                      //
// Authors   : Kaustubh Mhatre | Aayush  | Saurabh Chavan                                     	                //
// Date      : 05/20/2020                                                                                       //
// Version   : 1                                                                                                //
// Reference :                                                                                                  //
// Portland State University                                                                                    //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import Definitions::*;

module AHB(inf.DUT intf);

	//Instance of DUT
	AHB_TOP qwerty	(
						.HCLK(intf.HCLK), 
						.HRESETn(intf.HRESETn),
						.HWDATA(intf.HWDATA),
						.HADDR(intf.HADDR),
						.HSIZE(intf.HSIZE),
						.HBURST(intf.HBURST),
						.HTRANS(intf.HTRANS),
						.HWRITE(intf.HWRITE), 
						.HMASTLOCK(intf.HMASTLOCK), 
						.HREADY(intf.HREADY),
						.HPROT(intf.HPROT),
						.HRDATA(intf.HRDATA), 
						.HRESP(intf.HRESP)
					);


endmodule


	

