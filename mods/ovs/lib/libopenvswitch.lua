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
	local success, imports = pcall(require(name))
	if success and type(imports) == "table"  then
		appendTable(dst, imports);
	end
end

import(exports, "shash")

return exports
