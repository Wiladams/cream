--[[
	Queue
--]]
local Queue = {}
setmetatable(Queue, {
	__call = function(self, ...)
		return self:new(...);
	end,
});

local Queue_mt = {
	__index = Queue;
}

function Queue.init(self, first, last, name)
	first = first or 1;
	last = last or 0;

	local obj = {
		first=first, 
		last=last, 
		name=name};

	setmetatable(obj, Queue_mt);

	return obj
end

function Queue.new(self, first, last, name)
	first = first or 1
	last = last or 0

	return self:init(first, last, name);
end



function Queue.enqueue(self, value)
	--self.MyList:PushRight(value)
	local last = self.last + 1
	self.last = last
	self[last] = value

	return value
end

function Queue.pushFront(self,value)
	-- PushLeft
	local first = self.first - 1;
	self.first = first;
	self[first] = value;
end

function Queue.dequeue(self, value)
	-- return self.MyList:PopLeft()
	local first = self.first

	if first > self.last then
		return nil, "list is empty"
	end
	
	local value = self[first]
	self[first] = nil        -- to allow garbage collection
	self.first = first + 1

	return value	
end

function Queue.length(self)
	return self.last - self.first+1
end

-- Returns an iterator over all the current 
-- values in the queue
function Queue.Entries(self, func, param)
	local starting = self.first-1;
	local len = self:length();

	local closure = function()
		starting = starting + 1;
		return self[starting];
	end

	return closure;
end


return Queue;
