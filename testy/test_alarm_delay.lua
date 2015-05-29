--test_stopwatch.lua
package.path = package.path..";../?.lua"

local Kernel = require("kernel"){exportglobal = true};
local Clock = require("clock")

local c1 = Clock();

local function twoSeconds()
	print("TWO SECONDS: ", c1:secondsElapsed());
	halt();
end

local function test_alarm_delay()
	print("delay(twoSeconds, 2000)");
	delay(twoSeconds, 2000);
end

run(test_alarm_delay)
