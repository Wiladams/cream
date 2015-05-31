
local OptionParser = require("std.optparse") 

local parser = OptionParser[[
 any text VERSION
 Additional lines of text to show when the --version
 option is passed.

 Several lines or paragraphs are permitted.

 Usage: PROGNAME

 Banner text.

 Optional long description text to show when the --help
 option is passed.

 Several lines or paragraphs of long description are permitted.

Options:

   -b                       a short option with no long option
       --long               a long option with no short option
       --another-long       a long option with internal hypen
   -v, --verbose            a combined short and long option
   -n, --dryrun, --dry-run  several spellings of the same option
   -u, --name=USER          require an argument
   -o, --output=[FILE]      accept an optional argument
       --version            display version information, then exit
       --help               display this help, then exit

 Footer text.  Several lines or paragraphs are permitted.

 Please report bugs at bug-list@yourhost.com
--]]

_G.arg, _G.opts = parser:parse (_G.arg)

local function printTable(tbl, title)
	if title then 
		print(title)
	end

	if not table then return end

	for k,v in pairs(tbl) do
		print(k,v)
	end
end

print("==== PARSED OPTIONS ====")
print("opts: ", opts)
printTable(opts)



exit();
