class service_driver extends uvm_driver #(service_seq_itm);
	`uvm_component_utils(service_driver)

service_seq_itm seq_item;
uvm_analysis_port #(service_seq_itm) msg_to_wdt; //Having 2 ports here to send the message(seq_item stuff) and the clock to the watch dog timer service.
uvm_analysis_port #(string) clk_to_wdt;
string clk;


function new (string name = "service_driver",uvm_component parent = null);
	super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	seq_item = service_seq_itm::type_id::create("seq_item");
	msg_to_wdt = new("msg_to_wdt",this);
	clk_to_wdt = new("clk_to_wdt",this);
endfunction: build_phase

task run_phase(uvm_phase phase);
fork
	forever begin
		seq_item_port.get_next_item(seq_item);

		
		repeat(seq_item.clk_tick) begin
			clk = "posedge";
			$display(clk);
		end
		msg_to_wdt.write(seq_item);
		clk_to_wdt.write(clk);
		seq_item_port.item_done();
		
	end


join_none
endtask
endclass