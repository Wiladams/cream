--libopenvswitch.lua
local ffi = require("ffi")

local exports = {
	Lib = ffi.load("openvswitch")
}


local function appendTable(dst, src)
	for k,v in pairs(src) do
		dst[k] = v;
	end
end

local function import(dst, name)
	local success, imports = pcall(function() return require(name) end)
	if success and type(imports) == "table"  then
		appendTable(dst, imports);
	end
end


import(exports, "ovs.lib.command_line")
import(exports, "ovs.lib.hmap")
import(exports, "ovs.lib.json")
import(exports, "ovs.lib.list")
import(exports, "ovs.lib.shash")

setmetatable(exports, {
	__call=function(self)
		for k,v in pairs(self) do
			_G[k] = v;
		end
	end,
	})

return exports
