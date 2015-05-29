-- test_reflect.lua

local ffi = require("ffi")
local reflect = require("reflect")
local reform = require("reflect_util")
--local ljsys = require("ljsyscall.syscall")
local ssl = require("ssl_ffi")

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

local function showme(cname, libhint)
	local success, atype = nil;

	if libhint then
		success, atype = pcall(function() return reflect.typeof(libhint[cname]) end);
		if success and atype ~= nil then
			return reform(atype)
		end
	end

	-- first try to look it up as a function or constant in standard libraries
	success, atype = pcall(function() return reflect.typeof(ffi.C[cname]) end);

	if success then 
		return reform(atype);
	end

	-- if that didn't work, then try to look it up as a type
	success, atype = pcall(function() return reflect.typeof(ffi.typeof(cname)) end);

	if success then
		return reform(atype)
	end

	-- if that didn't work, then look it up in the hinted library
	-- if there is one

	return false, atype;
end


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
--	"struct funkyname",
--"SSL_CTX_use_certificate_file",
	{name = "SSL_library_init", lib=ssl.SSLLib},
};

local function test_ssl()
	print("SSL:", #ssl, ssl.SSLLib)
for k,v in pairs(ssl) do
	print(k,v);
end

	local res = ssl.SSLLib.SSL_library_init();
	print(res);
end

local function main() 
	for _, item in ipairs(lookups) do
		local success, err = showme(item.name, item.lib)

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
