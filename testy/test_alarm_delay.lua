--test_alarm_delay.lua

local c1 = Kernel.Clock();

local function twoSeconds()
	print("TWO SECONDS: ", c1:secondsElapsed());
	halt();
end

local function test_alarm_delay()
	print("delay(twoSeconds, 2000)");
	delay(twoSeconds, 2000);
end

test_alarm_delay()
