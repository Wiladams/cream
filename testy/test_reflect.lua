-- test_reflect.lua

local ffi = require("ffi")
local reflect = require("reflect")
local reform = require("reflect_util")
local ljsys = require("ljsyscall.syscall")
--local linux = require("linux")

ffi.cdef[[
void * malloc(int size);
void free(void *);

typedef struct foobar {
	int foo;
	int bar;
	char *bazz;
} foobar;

struct funkyname {
  char sysname[65];
  char nodename[65];
  char release[65];
  char version[65];
  char machine[65];
  unsigned char domainname[65];
};
]]

local function showme(cname)
	-- first try to look it up as a function or constant
	local success, atype = pcall(function() return reflect.typeof(ffi.C[cname]) end);

	if success then 
		return reform(atype);
	end

	-- if that didn't work, then try to look it up as a type
	local success, atype = pcall(function() return reflect.typeof(ffi.typeof(cname)) end);

	if not success then
		return false, atype;
	end

	return reform(atype);
end


local function main()
	local lookups = {
--	"malloc",
--	"free",
--	"struct foobar",
--	"foobar",
--	"flipper",
--	"struct timespec",
--	"epoll_data_t",
--	"clockid_t",
--	"clock_getres",
--	"clock_nanosleep",
--	"lchmod",
--	"struct utsname",
	"struct funkyname",
};

	for _, item in ipairs(lookups) do
		local success, err = showme(item)

		if not success then
			print(string.format("LOOKUP: %15s  ERROR: %s", item, tostring(err)));
		else
			print(string.format("LOOKUP: %15s", item))
			print(success);
		end
	end

	halt();
end

return main()
