//typedef enum {informational, error, fatal} msg_severity;
//typedef enum {set, reset} command;

class service_seq_itm extends uvm_sequence_item;
	`uvm_object_utils(service_seq_itm)
	
	function new(string name="service_seq_itm");
		super.new(name);
	endfunction
	string msg; //msg_severity
	string cmd; //command
	rand int watchdog_timer; //how many cycles to wait for reset signal
	//msg_severity msg;
	//rand command cmd;
	string msg_text;
	int clk_tick; // this is to specify by how many cycles should 
	
	function string convert2string();
		return $sformatf("cmd=%s, wdg_time=%d msg_severity=%s msg_text=%s \n",cmd, watchdog_timer, msg, msg_text);
	endfunction: convert2string

	
endclass
