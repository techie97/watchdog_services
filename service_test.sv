class service_test extends uvm_test;
    `uvm_component_utils(service_test)
    
    service_env env;
    service_seq seq;
    
    function new(string name="Me",uvm_component parent=null);
        super.new(name,parent);
        
    endfunction : new
    
    function void build_phase(uvm_phase phase);
	env = service_env::type_id::create("env",this);
	seq = service_seq::type_id::create("seq",this);
    endfunction : build_phase
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this,"Start UVM");
        seq.start(env.agent.sqr);
	#50;
        phase.drop_objection(this,"End now");
    endtask : run_phase

endclass : service_test
