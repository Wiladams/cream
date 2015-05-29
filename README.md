# cream
Concurrent Runtime Environment And Modules

This is a project that builds upon schedlua to create a simple 
runtime environment that leverages lua co-routines for concurrent
program execution.  This is very similar to TINN, but is focused
on Linux in this case.

There are several modules pulled in from various other projects.
The largest of these is probably the ljsyscall functions.  This is
used to gain portability across multiple flavors of *NIX where
that matters.

In addition, there are other modules such as serpent, fun, dkjson,
reflect, and the like which are pulled in for their convenience in
one form or another performing some specific useful task.

In addition to core modules, which are mean to be leveraged by new code,
there are several interop modules, starting with "open vSwitch (ovs)".
These modules are here for convenience of scripting together interesting
solutions using nothing more than shared libraries on a distro, and 
whatever is included here.

In general, cream tries to make everying readily available from luajit,
without requiring the compilation of any additional code, other than the
modules which are already compiled for the platform it's running on.

Here's an example of using the json routines found within the 
openvswitch library:

```lua
local libovs = require("lib.libopenvswitch");
libovs();	-- make things global

local function test_jsonfromstring()

	local j = json_from_string(jsonsample1);
	print(j);
	print("==== JSON RECODE ====")
	local str = json_to_string(j, JSSF_PRETTY);
	if str ~= nil then
		print(ffi.string(str))
	else
		print("JSON SERIALIZATION FAILED...")
	end
end
```

Notice here that the 'json' routines are used just like they are if
you were writing 'C' code, only it's easier because you don't have to 
worry about memory allocation as much.  The bulk of the library interop
routines go towards making these extensive and sometimes esoteric libraries
fairly easy to use in the lua environment, which accelerates the ability
to rapidly prototype stuff.

