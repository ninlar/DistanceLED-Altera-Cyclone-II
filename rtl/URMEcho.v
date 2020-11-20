//////////////////////////////////////////////////////////////////////////////
// Module : URMEcho
// Purpose: Measures the echo pin on the ultrasonic range module for distance
//////////////////////////////////////////////////////////////////////////////
module URMEcho
(
  Clock,
  Echo,
  Distance,
);

//////////////////////////////////////////////////////////////////////////////
// Inputs / Outputs
//////////////////////////////////////////////////////////////////////////////
input Clock; // 50 MHz clock from FPGA
input Echo; // Echo pin from the ultrasonic range module
output[15:0] Distance; // Distance in centimeters

//////////////////////////////////////////////////////////////////////////////
// Registers / Wires
//////////////////////////////////////////////////////////////////////////////
reg[15:0] _counter;
reg[15:0] _distance;
wire _clock;

//////////////////////////////////////////////////////////////////////////////
// Parameters
//////////////////////////////////////////////////////////////////////////////
parameter CM_PER_MICROSECOND = 15'd58; // Centimeters distance per microsecond

//////////////////////////////////////////////////////////////////////////////
// Modules
//////////////////////////////////////////////////////////////////////////////
ClockDivider _clockDivider
(
  .ClockIn(Clock), 
  .ClockOut(_clock)
);

// Divide the clock by 50 to get a 1MHz clock (1us per cycle)
defparam _clockDivider.DIVISOR = 50;

initial begin
  _counter = 0;
end

// Whenever we receive an echo signal start...
always @(posedge Echo)
begin
  // Reset counter
  _counter = 4'd0;
end

// On each divided clock signal
always @(posedge _clock)
begin
  // Increment counter
  _counter = _counter + 15'd1;
end

// When the echo signal completes...
always @(negedge Echo)
begin
  // Copy counter to the distance register
  _distance = _counter;
end

// Map distance register to the output, but convert
// to centimeters first. For every 1 microsecond the
// echo signal is high, the object is 1 centimeter away.
assign Distance = (_distance / CM_PER_MICROSECOND);

endmodule