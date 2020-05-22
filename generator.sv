
import Definitions::*;

class gen;
  txn pkt;
  mailbox mbx=new();

  function new(mailbox mbx);
	this.mbx=mbx;
  endfunction
  
  task run();
    repeat(100)
    begin
		pkt=new();
		assert(pkt.randomize);
		pkt.print("Generator data and address ");
		mbx.put(pkt);
    end
  endtask

endclass
