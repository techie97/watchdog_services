import uvm_pkg::*;
`include "uvm_macros.svh"
`include "service_seq_item.sv"
`include "service_seq.sv"
`include "service_sequencer.sv"
`include "service_driver.sv"
`include "service_watchdogtimer.sv"
`include "service_agent.sv"
`include "service_env.sv"
`include "service_test.sv"

module top();

	reg clk = 0;
	initial begin
		forever #1 clk = ~clk;
	end

        initial begin
		
		$display("START NOW");
                run_test("service_test");
        	
		$finish;
        end

endmodule: top
