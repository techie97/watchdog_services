class service_agent extends uvm_agent;
	`uvm_component_utils(service_agent)

service_driver driver;
service_sequencer sqr;

uvm_analysis_port #(service_seq_itm) agent_msg_port;
uvm_analysis_port #(string) agent_clk_port;

function new (string name,uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
sqr = service_sequencer::type_id::create("sqr",this);
driver = service_driver::type_id::create("driver",this);

agent_msg_port = new("agent_msg_port",this);
agent_clk_port = new("agent_clk_port",this);

endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
driver.seq_item_port.connect(sqr.seq_item_export);
driver.msg_to_wdt.connect(agent_msg_port);
driver.clk_to_wdt.connect(agent_clk_port);

endfunction

endclass
