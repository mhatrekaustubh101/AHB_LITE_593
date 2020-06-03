//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : tb_top.sv                                                                                        //                                                          //
// Term      : Spring 2020                                                                                      //
// Authors   : Kaustubh Mhatre 							                                    	                //
// Date      : 05/20/2020                                                                                       //
// Version   : 1                                                                                                //
// Reference :                                                                                                  //
// Portland State University                                                                                    //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import Definitions::*;

program tb_top(inf intf);

	//Object of environment class
	env e;
	
	initial begin
		e = new(intf);
		e.run();
	end
endprogram
