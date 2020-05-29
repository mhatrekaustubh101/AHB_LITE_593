
import Definitions::*;

module AHB(inf.DUT intf);


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


	

