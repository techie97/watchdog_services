class service_sequencer extends uvm_sequencer #(service_seq_itm);
	`uvm_component_utils(service_sequencer)
    
    function new(string name="service_sequencer",uvm_component parent=null);
        super.new(name,parent);
    endfunction : new
    
endclass : service_sequencer