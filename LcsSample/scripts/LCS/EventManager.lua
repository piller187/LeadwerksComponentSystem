----------------------------------------------
-- Leadwerks Component System
-- http://leadwerks.com      	
-- - - - - - - - - - - - - - - - - - - - - - -
-- Free to use for all Leadwerks owners
-- and as always we take no responsibility
-- for anything that the usage of this can 
-- cause directly or indirectly. 
-- - - - - - - - - - - - - - - - - - - - - - -
-- Rick & Roland                       	
-----------------------------------------------

--[[
Class: EventManager


]]

local EventManagerID = 0

if EventManager ~= nil then return end
EventManager = {}
EventManager.coroutines = {}

--[[
Function: create()

Create an instance of the EventManager

Returns: 

The instance

]]
function EventManager:create()
	obj = {}
    self.__index = self
	self.handlers = {}
	
	for k, v in pairs(EventManager) do
		obj[k] = v
	end

    return obj
end

--[[
Function: subscribe(owner, method, arguments, filterFunction, postFunction)

Subscribe to an event

Parameters: 

	owner - owner of the method
	method - function/method to call on raise
	arguments - table or string of arguments
	filterFunction - function called for enable/disable the event
	postFunction - callback 
	
Returns:

	A number the identifies the event. Can be used to remove a subscribtion
]]
function EventManager:subscribe(owner, method, arguments, filterFunction, postFunction)
	if method == nil then 
		System:Print( debug.traceback() ) 
	end
	
	Debug:Assert( owner ~= nil, "Calling EventManager:subscribe with Null-Owner" )
	Debug:Assert( method ~= nil, "Calling EventManager:subscribe with Null-Method")
	
	EventManagerID = EventManagerID+1
	
	local filter = nil 
	if filterFunction ~= nil then 
		filter = assert(loadstring("return " .. filterFunction))()
	end

	local postFunc = nil 
	if postFunction ~= nil then 
		postFunc= assert(loadstring("return " .. postFunction))()
	end

	local args = nil 
	if arguments ~= nil then 
		args = assert(loadstring("return " .. arguments))()
	end
		
	table.insert(self.handlers, { 
			Id = EventManagerID, 
			Owner = owner, 
			Method = method, 
			Arguments = args,
			Filter = filter,
			PostFunction = postFunc })

	return EventManagerID
end

--[[
Function: unsubscribe(id)

Unsubscribe an event

Parameters: 

	id - identification on the event
	
See Also:
	<subscribe(owner, method, arguments, filterFunction, postFunction)>
]]
function EventManager:unsubscribe(id) -- the id returned when subscribing
	for i = 1, #self.handlers do
		if  self.handlers[i].Id == id then
			table.remove(self.handlers, i)
			return
		end
	end
end

--[[
Function: raise(args)

Raise an event which will be caught by all subscribers

Parameters: 

	args - argument send with the envent
	
See Also:
	<subscribe(owner, method, arguments, filterFunction, postFunction)>
	
Argument: 
	An argument MUST be a table
	
Example: 
	>self.onEvent:raise( { Speed=10, Message="run" } ) -- arguments must be table

]]
function EventManager:raise(args)
	for i = 1, #self.handlers do
		local handler = self.handlers[i]
		if handler ~= nil then
				
			if	handler.Filter ~= nil 
			and	handler.Filter ~= "" then 
				if handler.Filter(args) then
					local co = coroutine.create(handler.Method)
					coroutine.resume(co, handler.Owner, self:createArguments(handler,args) )
					if coroutine.status(co) ~= "dead" then
						table.insert( EventManager.coroutines, co )
					end
				end
			else
				local co = coroutine.create(handler.Method)
				coroutine.resume(co, handler.Owner, self:createArguments(handler,args) )
				if coroutine.status(co) ~= "dead" then
					table.insert( EventManager.coroutines, co )
				end
			end
		end
	end
end

--[[
Function: update()

Updates the EventManager

]]
function EventManager:update()
	for i = #EventManager.coroutines, 1, -1 do
		local co = EventManager.coroutines[i]
		coroutine.resume(co) 
		if coroutine.status(co) == "dead" then
			table.remove(EventManager.coroutines, i)
		end
	end
end


function EventManager:createArguments(handler, args)
			
		if args == nil then 
			local arguments = {}
		else
			local arguments = args
		end
		
		-- merge with handler args if any
		if 	handler.Arguments ~= nil
		and handler.Arguments ~= "" then
			mergeTo(arguments, handler.Arguments(args) )
		end
		
		-- merge with handler post if any
		if 	handler.PostFunction ~= nil
		and handler.PostFunction ~= "" then
			mergeTo(arguments, handler.PostFunction(args) )
		end		
		
		return arguments
end