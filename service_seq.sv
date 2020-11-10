class service_seq extends uvm_sequence #(service_seq_itm);
    `uvm_object_utils(service_seq)

service_seq_itm seq_item;

function new (string name = "service_seq");
super.new(name);
endfunction : new

task body();

seq_item = service_seq_itm::type_id::create("seq_item");

	repeat(11) begin
	start_item(seq_item);
	seq_item.cmd = 0;
	seq_item.watchdog_timer = 12;
	seq_item.msg = 0;
	seq_item.msg_text = "timeout 10";
	seq_item.clk_tick = 9;
	finish_item(seq_item);
	end
	
#50;
			
endtask: body
endclass
