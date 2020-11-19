//////////////////////////////////////////////////////////////////////////////
// Module : URMTrigger
// Purpose: Sends a 10us trigger signal to the HC-SR04 Ultrasonic Range Module
//////////////////////////////////////////////////////////////////////////////
module URMTrigger
(
  Clock,
  TriggerIn,
  TriggerOut
);

//////////////////////////////////////////////////////////////////////////////
// Inputs / Outputs
//////////////////////////////////////////////////////////////////////////////
input Clock; // Input clock on FPGA (50MHz)
input TriggerIn; // When set to high, a 10us pulse is sent on TriggerOut
output TriggerOut; // 10us pull output

//////////////////////////////////////////////////////////////////////////////
// Registers
//////////////////////////////////////////////////////////////////////////////
reg[3:0] _counter;  // Counter used for the 10us pulse
reg _triggerOut;    // Register holding the value for TriggerOut output
wire _clock;        // 1MHz clock

//////////////////////////////////////////////////////////////////////////////
// Parameters
//////////////////////////////////////////////////////////////////////////////
parameter PULSECOUNT = 4'd10;  // Number of pulses to keep the trigger out high

//////////////////////////////////////////////////////////////////////////////
// Modules
//////////////////////////////////////////////////////////////////////////////
ClockDivider _clockDivider
(
  .ClockIn(Clock), 
  .ClockOut(_clock)
);

// Divide the clock by 50 to get a 1MHz clock
defparam _clockDivider.DIVISOR = 50;

// Don't send a pulse on startup, wait for the trigger
initial begin
  _counter = PULSECOUNT;
  _triggerOut = 0;
end

// Whenever we receive a trigger signal...
always @(posedge TriggerIn)
begin
  // Reset counter
  _counter = 4'd0;
  _triggerOut = 0;
end

// On each 1us cycle...
always @(posedge _clock)
begin
  
  // If we should still be sending the trigger pulse...
  if(_counter < PULSECOUNT)
  begin
    _counter <= _counter + 4'd1;
    _triggerOut = 1;
  end
  else
  begin
    _triggerOut = 0;
  end
end

// Map trigger output register to the output
assign TriggerOut = _triggerOut;

endmodule