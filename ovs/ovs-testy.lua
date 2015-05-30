#!/usr/local/bin/luajit

package.path = package.path..";../core/?.lua;../?.lua;"

local Kernel = require("core.kernel"){exportglobal = true}
local asyncio = require("core.asyncio"){Kernel=Kernel, exportglobal = true}

if (arg[1] ~= nil) then
	local f, err = loadfile(arg[1])
	
	if not f then
		print("Error loading file: ", arg[1], err)
		return false, err;
	end
	
	run(f);
end

