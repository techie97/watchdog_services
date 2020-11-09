class wdog_seq extends uvm_sequence;
	`uvm_object_utils(service_seq)
	
	wdog_seq_item seq_item
	
	function new(string name="service_seq", uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	task reset();
		seq_item.cmd = 1;
	endtask
	
	task set();
		seq_item.cmd = 0;
		seq_item.randomize() with {watchdog_timer <= 10
			clk_tick < watchdog_timer;};
		case (seq_item.msg)
			0: begin
				seq_item.msg_text = "The message is informational";
				`uvm_info("WATCHDOG SEQ", $sformatf("%s", seq_item.msg_text))
			end
			1: begin
				seq_item.msg_text = "ERROR!";
				`uvm_error("WATCHDOG SEQ", $sformatf("%s", seq_item.msg_text))
			end
			2: begin
				seq_item.msg_text = "FATAL!!!";
				`uvm_fatal("WATCHDOG SEQ", $sformatf("%s", seq_item.msg_text))
			end
		endcase
	endtask
	
	task body();
		seq_item = wdog_seq_item::type_id::create("seq_item",this);
		repeat(100) begin
			start_item(seq_item);
			reset();
			set();
			finish_item(seq_item);
		end
	endtask
	
endclass