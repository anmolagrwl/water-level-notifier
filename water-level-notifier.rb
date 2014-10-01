require 'bundler/setup'
require 'dino'

board = Dino::Board.new(Dino::TxRx::Serial.new)
led = Dino::Components::Led.new(pin: 13, board: board)
flex_sensor = Dino::Components::Sensor.new(pin: 'A0', board: board)


flex_too_high = 475 #the value of the assigned analog pin when the flex sensor is bent forward past this threshold.
flex_too_low = 465 #the value of the assigned analog pin when the flex sensor is bent backward past this threshold.
bend_value = 0 #store the changing analog values of the flex resistor as it bends.
bend_state = 0 #the binary condition of the flex sensor. If it’s straight, its value is equal to zero. If the flex resistor deviates either direction, we will set its state to one.

def initialize
	
end

def sendWaterAlert(bend_value, bend_state)
	if bend_state == 1
		led.send(:on)
		puts "Water level threshold exceeded, bend_value = #{bend_value}"
	else
		led.send(:off)
		puts "Water level threshold returned to normal, bend_value = #{bend_value}"
	end
end

# The main loop of the sketch will poll the value of the flex resistor every second. A switch statement tests the condition of the flex resistor. If its last status was straight (case 0:), check to see if it has since bent beyond the upper and lower threshold limits. If so, set the bend_state accordingly and call the SendWaterAlert function. Conversely, if the resistor’s last status was bent (case 1:), check to see if it’s now straight. If it is, set the bend_state variable to zero and pass that new state to the SendWaterAlert function.

sensor.when_data_received do |data|
  bend_value = data
  puts "bend_value = #{bend_value}"
end

case bend_state
when 0
	if (bend_value >= flex_too_high || bend_value <= flex_too_low)
		bend_state = 1
		sendWaterAlert(bend_value, bend_state)
	end
	break
when 1
	if (bend_value < flex_too_high || bend_value > flex_too_low)
		bend_state = 0
		sendWaterAlert(bend_value, bend_state)
	end
	break	
end


#send email