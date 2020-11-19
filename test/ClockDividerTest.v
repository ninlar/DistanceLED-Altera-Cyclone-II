`timescale 1ns / 1ps

// fpga4student.com FPGA projects, VHDL projects, Verilog projects
// Verilog project: Verilog code for clock divider on FPGA
// Testbench Verilog code for clock divider on FPGA
module ClockDividerTest;
 // Inputs
 reg ClockIn;
 // Outputs
 wire ClockOut;
 // Instantiate the Unit Under Test (UUT)
 // Test the clock divider in Verilog
 ClockDivider uut
 (
  .ClockIn(ClockIn), 
  .ClockOut(ClockOut)
 );
 
 initial begin
  // Initialize Inputs
  ClockIn = 0;

 end
 
 always begin
   #10 ClockIn = !ClockIn;
 end
      
endmodule
