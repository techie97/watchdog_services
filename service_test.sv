class service_test extends uvm_test;
    `uvm_component_utils(service_test)
    
    service_env env;
    service_seq seq;
    
    function new(string name="service_test",uvm_component parent=null);
        super.new(name,parent);
        
    endfunction : new
    
    function void build_phase(uvm_phase phase);
	super.build_phase(phase);
$display("IN TEST BUILD PHASE");
	env = service_env::type_id::create("env",this);
	seq = service_seq::type_id::create("seq",this);
    endfunction : build_phase
    
    task run_phase(uvm_phase phase);
	$display("IN TEST RUN PHASE");
        phase.raise_objection(this,"Start UVM");
	#10;
        seq.start(env.agent.sqr);
        phase.drop_objection(this,"End now");
    endtask : run_phase

endclass : service_test
