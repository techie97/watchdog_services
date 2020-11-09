class service_watchdogtimer extends uvm_component;
	`uvm_component_utils(service_watchdogtimer)

	// Local message
	uvm_analysis_export #(service_seq_itm) ip_msg;
	uvm_analysis_export #(string) ip_msgclk;
	
	uvm_tlm_analysis_fifo #(service_seq_itm) ip_msg_fifo;
	uvm_tlm_analysis_fifo #(string) ip_msgclk_fifo;
	service_seq_itm seq_item;
	
	//Analysis import to connect 
	uvm_analysis_port #(string) wdg_op_msg_port;

	
	enum {idle,start,result,reset} state = idle;
	
	int unsigned counter = 0, wdg_time = 0 ;
	string msg_text = "",op_string = "",msg_severity ="";
	string clk;
	reg [4:0] flag = 0;
	
	
	function new(string name="wdg_service",uvm_component parent=null);
		super.new(name,parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ip_msg = new("ip_msg",this);
		ip_msgclk = new("ip_msgclk",this);
		ip_msg_fifo = new("ip_msg_fifo",this);
		ip_msgclk_fifo = new("ip_msgclk_fifo",this);
		wdg_op_msg_port = new("wdg_op_msg_port",this);
	endfunction: build_phase
	
	function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
			ip_msg.connect(ip_msg_fifo.analysis_export);
			ip_msgclk.connect(ip_msgclk_fifo.analysis_export);
    endfunction : connect_phase

	task run_phase (uvm_phase phase);
		fork
			forever 
				begin
					ip_msg_fifo.get(seq_item);
					ip_msgclk_fifo.get(clk);
                  
				case(state)
			
				idle: 
					begin
						$display("Idle state");
						if(seq_item.cmd == "set") 
							begin
								state = start;
								wdg_time = seq_item.watchdog_timer;    
								msg_severity = seq_item.msg;
								msg_text = seq_item.msg_text;    
								counter = wdg_time;
							end
						else if(seq_item.cmd == "reset")
							begin
								state = idle;
								wdg_time = 0;
								msg_severity = "";
								msg_text = "";
								counter = 0;
							end
						else
							begin 
								state = idle;
							end
					end


				start: 
					begin
						$display("Service counter=%0d",counter);
						if(seq_item.cmd == "reset") 
							begin
								state = result;
								wdg_time = 0;
								msg_severity = "";
								msg_text = "";
								counter=0;
							end
						else 
							begin
							if(clk == "posedge") 
								begin
									state = start;
									counter = counter - 1;
									flag = flag + 1;
									$display(clk);
									$display(flag);
									if(counter == 0 )
										begin
											$display(clk);
											state = result;
											op_string = {"fail", msg_text};
										end
									else if (counter !=0 && flag==seq_item.clk_tick) 
										begin
											$display(seq_item.clk_tick);
											state = result;
											op_string = "pass";
											flag = 0;
											
										end
								end
							end
					end

				result:
					begin
						$display("result state");
						state = idle;
						if(counter == 0)
							begin
								case(msg_severity)
									"informational": `uvm_info("WDG Service",op_string,UVM_MEDIUM)
									"error": `uvm_error("WDG Service",op_string)
									"fatal": `uvm_warning("WDG Service fatal",op_string)
/*
									0 : `uvm_info("WDG ///////Service",op_string,UVM_MEDIUM)
									1 : `uvm_error("WDG Service",op_string)
									2 : `uvm_warning("WDG Service fatal",op_string)
*/
									default: `uvm_fatal("WDG Service","in default state of msg_severity")
								endcase
							end
						else 
							begin
								`uvm_info("WDG Service","PASS",UVM_MEDIUM)
								counter=0;	
							end
					end
			
				default:
					begin
						`uvm_fatal("WDG Service","in default state of main FSM")
					end
				
															
				endcase								
			wdg_op_msg_port.write(op_string);
			end
		join_none
	endtask: run_phase

endclass: service_watchdogtimer
