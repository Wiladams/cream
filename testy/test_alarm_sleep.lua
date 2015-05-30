--test_alarm_sleep.lua
--package.path = package.path..";../?.lua"

--local Kernel = require("kernel"){exportglobal = true};
--local Alarm = require("alarm")(Kernel)
--local Clock, timespec = require("clock")



local function main()
	local s1 = Kernel.Clock();
	local starttime = s1:reset();
	print("sleep(7525)");

	sleep(7525);

	local duration = s1:secondsElapsed();

	print("Duration: ", duration);

	exit();
end

main()
