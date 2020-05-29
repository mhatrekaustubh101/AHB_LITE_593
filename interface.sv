//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : testbench                                                                                        //                                                          //
// Term      : Spring 2020                                                                                      //
// Authors   : Kaustubh Mhatre | Aayush  | Saurabh Chavan                                     	                //
// Date      : 05/14/2020                                                                                       //
// Version   : 1                                                                                                //
// Reference :                                                                                                  //
// Portland State University                                                                                    //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



`include "AHB_Package.sv"
import Definitions::*;

interface inf(input  HCLK);
	logic                          HRESETn;
	logic   [DATAWIDTH-1:0]        HWDATA;
	logic   [ADDRWIDTH-1:0]        HADDR;
	logic   [DATATRANFER_SIZE-1:0] HSIZE;
	BType_t                        HBURST;
	Trans_t                        HTRANS;
	logic                          HWRITE, HMASTLOCK, HREADY;
	logic   [3:0]                  HPROT;
    
	logic   [DATAWIDTH-1:0]        HRDATA;
	Response_t                     HRESP;
	
	modport DUT (
					input  HCLK, HRESETn,
					input  HWDATA,
					input  HADDR,
					input  HSIZE,
					input  HBURST,
					input  HTRANS,
					input  HWRITE, HMASTLOCK, HREADY,
					input  HPROT,
					output HRDATA, 
					output HRESP
				);
	
endinterface
