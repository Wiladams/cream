--test_alarm_periodic.lua
--package.path = package.path..";../?.lua"

--local Kernel = require("kernel"){exportglobal = true};
--local Alarm = require("alarm")(Kernel, true)
--local Clock, timespec = require("clock")

local c1 = Kernel.Clock();

local function haltAfterTime(nsecs)
	local function closure()
		print("READY TO HALT: ", nsecs, c1:secondsElapsed());
		exit();
	end

	delay(closure, nsecs);	-- halt after 10 seconds
end

local function everyPeriod()
	print("PERIODIC: ", c1:secondsElapsed());
end

local function main()
	periodic(everyPeriod,250)
	haltAfterTime(5000);

end

main()
