`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////
// Module : URMEchoTest
// Purpose: Test bench for the URMEcho module
//////////////////////////////////////////////////////////////////////////////
module URMEchoTest;
  
//////////////////////////////////////////////////////////////////////////////
// Registers
//////////////////////////////////////////////////////////////////////////////
reg Clock;
reg Echo;
 
//////////////////////////////////////////////////////////////////////////////
// Wires
//////////////////////////////////////////////////////////////////////////////
wire[15:0] Distance;

// Instantiate the Unit Under Test (UUT)
// Test the ultrasonic range module trigger in Verilog
URMEcho uut
(
  .Clock(Clock), 
  .Echo(Echo),
  .Distance(Distance)
);
 
initial begin
  // Initialize Inputs
  Clock = 0;
  Echo = 0;
end
 
always begin
  // Toggle the state of the clock every 10ns for 50MHz
  #10 Clock = !Clock;
end

always begin
  #10;
  Echo = 1;
  
  // Test object 1cm away
  #58000;
  Echo = 0;
  
  #10;
  Echo = 1;
  
  // Test object 2cm away
  #116000;
  Echo = 0;  
  
  #100000;
end
      
endmodule



