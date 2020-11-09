class service_env extends uvm_env;
`uvm_component_utils(service_env)

service_agent agent;
service_watchdogtimer service;


function new (string name,uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
agent = service_agent::type_id::create("agent",this);
service = service_watchdogtimer::type_id::create("service",this);

endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
agent.agent_msg_port.connect(service.ip_msg);
agent.agent_clk_port.connect(service.ip_msgclk);

endfunction




endclass