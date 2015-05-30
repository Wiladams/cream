
local function waiter(num)
	num = num or 0

	local function closure()
		print(string.format("WAITED: %d", num))
	end

	return closure;
end

local function main()
	print("MAIN, TaskID: ", getCurrentTaskID());
	
	for i=1,4 do
		onSignal(waiter(i),"waiting")
	end

	-- sleep a bit giving waiter a chance to register
	-- for their signals
	sleep(500);

print("4 waiters spawned");
	print("signalOne, result: ", signalOne("waiting"));
print("After signalOne");
	sleep(2000)

	signalAll("waiting")
	sleep(2000);

	print("SLEEP AFTER signalAll")

	exit();
end

main()
 
