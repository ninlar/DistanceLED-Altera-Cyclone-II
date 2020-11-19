//////////////////////////////////////////////////////////////////////////////
// Module : ClockDivider
// Purpose: Divides the input clock resulting in a lower frequency
//        : output clock
//////////////////////////////////////////////////////////////////////////////
module ClockDivider
(
  ClockIn,
  ClockOut
);

//////////////////////////////////////////////////////////////////////////////
// Inputs / Outputs
//////////////////////////////////////////////////////////////////////////////
input ClockIn; // input clock on FPGA
output ClockOut; // output clock after dividing the input clock by divisor

//////////////////////////////////////////////////////////////////////////////
// Parameters
//////////////////////////////////////////////////////////////////////////////
parameter DIVISOR = 28'd2;  // Default divisor, can be overridden

//////////////////////////////////////////////////////////////////////////////
// Registers
//////////////////////////////////////////////////////////////////////////////
reg[27:0] _counter = 28'd0; // 50 MHz Clock needs 28-bit counter

// The frequency of the output ClockOut = the frequency of the input ClockIn 
// divided by DIVISOR.
// For example:
// Assume: FClockIn = 50MHz,
// Desired: FClockOut = 1Hz
// The DIVISOR parameter value to 28'd50.000.000
// Then the frequency of the output ClockOut = 50MHz/50.000.000 = 1Hz
always @(posedge ClockIn)
begin
  _counter <= _counter + 28'd1;
  
  if(_counter >= (DIVISOR - 1))
  begin
    _counter <= 28'd0;
  end
end
  
// We want the duty cycle to be the same. Half the cycle is one
// while the other have is zero.
assign ClockOut = (_counter < DIVISOR / 2) ? 1'b0 : 1'b1;

endmodule
