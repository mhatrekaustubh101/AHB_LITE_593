
import Definitions::*;

program tb_top(inf intf);
	env e;
	initial begin
		e=new(intf);
		e.run();
	end
endprogram
