--kernel.lua

local Scheduler = require("core.scheduler")
local Functor = require("core.functor")
local alarm = require("alarm")




local Predicate = {}
setmetatable(Predicate, {
	__call = function(self, params)
		params = params or {}
		self.Kernel = params.Kernel;
		if params.exportglobal then
			self:globalize();
		end
		return self;
	end;
})

function Predicate.signalOnPredicate(self, pred, signalName)
	local function closure()
		local res = nil;
		repeat
			res = pred();
			if res == true then 
				return self.Kernel:signalAll(signalName) 
			end;

			self.Kernel:yield();
		until res == nil
	end

	return self.Kernel:spawn(closure)
end

function Predicate.waitForPredicate(self, pred)
	local signalName = "predicate-"..tostring(self.Kernel:getCurrentTaskID());
	self:signalOnPredicate(pred, signalName);
	return self.Kernel:waitForSignal(signalName);
end

function Predicate.when(self, pred, func)
	local function closure(lpred, lfunc)
		self:waitForPredicate(lpred)
		lfunc()
	end

	return self.Kernel:spawn(closure, pred, func)
end

function Predicate.whenever(self, pred, func)

	local function closure(lpred, lfunc)
		local signalName = "whenever-"..tostring(self.Kernel:getCurrentTaskID());
		local res = true;
		repeat
			self:signalOnPredicate(lpred, signalName);
			res = self.Kernel:waitForSignal(signalName);
			lfunc()
		until false
	end

	return self.Kernel:spawn(closure, pred, func)
end

function Predicate.globalize(self)
	_G["signalOnPredicate"] = Functor(Predicate.signalOnPredicate, Predicate);
	_G["waitForPredicate"] = Functor(Predicate.waitForPredicate, Predicate);
	_G["when"] = Functor(Predicate.when, Predicate);
	_G["whenever"] = Functor(Predicate.whenever, Predicate);

end


--[[
	Fiber, contains stuff related to a running fiber
--]]
local Task = {}

setmetatable(Task, {
	__call = function(self, ...)
		return self:create(...);
	end,
});

local Task_mt = {
	__index = Task,
}

function Task.init(self, aroutine, ...)

	local obj = {
		routine = coroutine.create(aroutine), 
	}
	setmetatable(obj, Task_mt);
	
	obj:setParams({...});

	return obj
end

function Task.create(self, aroutine, ...)
	-- The 'aroutine' should be something that is callable
	-- either a function, or a table with a meta '__call'
	-- implementation.  
	-- Checking with type == 'function'
	-- is not good enough as it will miss the meta __call cases

	return self:init(aroutine, ...)
end


function Task.getStatus(self)
	return coroutine.status(self.routine);
end

-- A function that can be used as a predicate
function Task.isFinished(self)
	return task:getStatus() == "dead"
end


function Task.setParams(self, params)
	self.params = params

	return self;
end

function Task.resume(self)
--print("Task, RESUMING: ", unpack(self.params));
	return coroutine.resume(self.routine, unpack(self.params));
end

function Task.yield(self, ...)
	return coroutine.yield(...)
end

--[[
	Kernel

	The glue of the system.  The kernel pulls all the constituent
	parts together.  I specifies the scheduler, creates tasks, and 
	handles signals.

--]]
local Kernel = {
	ContinueRunning = true;
	TaskID = 0;
	Scheduler = Scheduler();
	TasksSuspendedForSignal = {};

	Functor = Functor;
}

setmetatable(Kernel, {
    __call = function(self, params)
    	params = params or {}
    	params.Scheduler = params.Scheduler or self.Scheduler
    	
    	if params.exportglobal then
    		self:globalize();
    	end

    	self.Scheduler = params.Scheduler;

    	return self;
    end,
})

function Kernel.getNewTaskID(self)
	self.TaskID = self.TaskID + 1;
	return self.TaskID;
end

function Kernel.getCurrentTaskID(self)
	return self:getCurrentTask().TaskID;
end

function Kernel.getCurrentTask(self)
	return self.Scheduler:getCurrentTask();
end

function Kernel.spawn(self, func, ...)
	local task = Task(func, ...)
	task.TaskID = self:getNewTaskID();
	self.Scheduler:scheduleTask(task, {...});
	
	return task;
end

function Kernel.suspend(self, ...)
	self.Scheduler:suspendCurrentFiber();
	return self:yield(...)
end

function Kernel.yield(self, ...)
	return self.Scheduler:yield();
end


function Kernel.signalOne(self, eventName, ...)
	if not self.TasksSuspendedForSignal[eventName] then
		return false, "event not registered", eventName
	end

	local nTasks = #self.TasksSuspendedForSignal[eventName]
	if nTasks < 1 then
		return false, "no tasks waiting for event"
	end

	local suspended = self.TasksSuspendedForSignal[eventName][1];

	self.Scheduler:scheduleTask(suspended,{...});
	table.remove(self.TasksSuspendedForSignal[eventName], 1);

	return true;
end

function Kernel.signalAll(self, eventName, ...)
	if not self.TasksSuspendedForSignal[eventName] then
		return false, "event not registered"
	end

	local nTasks = #self.TasksSuspendedForSignal[eventName]
	if nTasks < 1 then
		return false, "no tasks waiting for event"
	end

	for i=1,nTasks do
		self.Scheduler:scheduleTask(self.TasksSuspendedForSignal[eventName][1],{...});
		table.remove(self.TasksSuspendedForSignal[eventName], 1);
	end

	return true;
end

function Kernel.waitForSignal(self, eventName)
	local currentFiber = self.Scheduler:getCurrentTask();

	if currentFiber == nil then
		return false, "not currently in a running task"
	end

	if not self.TasksSuspendedForSignal[eventName] then
		self.TasksSuspendedForSignal[eventName] = {}
	end

	table.insert(self.TasksSuspendedForSignal[eventName], currentFiber);

	return self:suspend()
end

function Kernel.onSignal(self, func, eventName)
	local function closure()
		self:waitForSignal(eventName)
		func();
	end

	return self:spawn(closure)
end



function Kernel.run(self, func, ...)

	if func ~= nil then
		self:spawn(func, ...)
	end

	while (self.ContinueRunning) do
		self.Scheduler:step();		
	end
end

function Kernel.halt(self)
	self.ContinueRunning = false;
end

function Kernel.globalize()
	Predicate:globalize();
	alarm:globalize();

	halt = Functor(Kernel.halt, Kernel);
    onSignal = Functor(Kernel.onSignal, Kernel);

    run = Functor(Kernel.run, Kernel);

    signalAll = Functor(Kernel.signalAll, Kernel);
    signalOne = Functor(Kernel.signalOne, Kernel);

    spawn = Functor(Kernel.spawn, Kernel);
    suspend = Functor(Kernel.suspend, Kernel);

    waitForSignal = Functor(Kernel.waitForSignal, Kernel);

    yield = Functor(Kernel.yield, Kernel);
end

Predicate({Kernel = Kernel})
alarm {Kernel=Kernel}

return Kernel;
