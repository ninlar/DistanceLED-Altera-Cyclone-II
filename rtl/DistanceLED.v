//////////////////////////////////////////////////////////////////////////////
// Module : DistanceLED
// Purpose: Uses an HC-SR04 Ultrasonic Range Module to light up 4 LEDs
//        : with respect to their distance from the module.
//////////////////////////////////////////////////////////////////////////////
module DistanceLED
(
  Clock,
  Trigger,
  Echo,
  LED
);


//////////////////////////////////////////////////////////////////////////////
// Inputs / Outputs
//////////////////////////////////////////////////////////////////////////////
input Clock;     // Input clock on FPGA (50MHz)
input Echo;      // Echo signal from the HC-SR04
output Trigger;  // Sends 10us pulse to HC-SR04 to get a distance reading
output[3:0] LED; // 10us pull output

//////////////////////////////////////////////////////////////////////////////
// Registers / Wires
//////////////////////////////////////////////////////////////////////////////
reg[3:0] _led;  // Counter used for the 10us pulse
reg[15:0] _distance; 
wire _clock;    // Used to send the trigger signal every 

//////////////////////////////////////////////////////////////////////////////
// Parameters
//////////////////////////////////////////////////////////////////////////////
parameter PULSECOUNT = 4'd10;  // Number of pulses to keep the trigger out high

//////////////////////////////////////////////////////////////////////////////
// Modules
//////////////////////////////////////////////////////////////////////////////

// Clock Divider that sends a trigger signal every 60ms (~16Hz)
ClockDivider _clockDivider
(
  .ClockIn(Clock), 
  .ClockOut(_clock)
);

// We cannot sample for distance more than once every 60ms
// So divide the clock by 3.2 million to get as close to 16Hz as possible
defparam _clockDivider.DIVISOR = 26'd3_200_000;

// When signaled by the ~16Hz clock, this module sends 10us pulse to
// the HC-SR04 module
URMTrigger _trigger
(
  .Clock(Clock), 
  .TriggerIn(_clock),
  .TriggerOut(Trigger)
);

// This module constantly monitors the echo pin on the SR-HC04 module
// and converts it to centimeters
URMEcho _echo
(
  .Clock(Clock), 
  .Echo(Echo),
  .Distance(_distance)
);

initial begin
  // LEDs all blank
  _led = 4'b0000;
end

// When the ~16Hz clock edge falls the distance should be ready to
// signal the LEDs
always @(negedge _clock)
begin
  if (_distance <= 16'd4)
    _led = 4'b1000; // Red
  else if (_distance <= 16'd10)
    _led = 4'b0100; // Yellow
  else if (_distance <= 16'd20)
    _led = 4'b0010; // Green
  else
    _led = 4'b0001; // Blue
end

assign LED = _led;

endmodule
 