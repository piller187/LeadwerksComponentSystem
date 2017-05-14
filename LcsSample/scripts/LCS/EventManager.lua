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

function EventManager:create()
	obj = {}
    setmetatable(obj, self)
    self.__index = self
	self.handlers = {}
	for k, v in pairs(EventManager) do
		obj[k] = v
	end

    return obj
end

--[[
Function: subscribe(owner, method, arguments, filterFunction)

Subscribe to an event

Parameters: 

	owner - owner of the method
	method - function/method to call on raise
	arguments - table or string of arguments
	filterFunction - function called for enable/disable the event
	
Returns:

	A number the identifies the event. Can be used to remove a subscribtion
]]
function EventManager:subscribe(owner, method, arguments, filterFunction)
	Debug:Assert( owner ~= nil, "Calling EventManager:subscribe with Null-Owner" )
	Debug:Assert( method ~= nil, "Calling EventManager:subscribe with Null-Method")
	
	EventManagerID = EventManagerID+1
	
	local filter = nil 
	if filterFunction ~= nil then 
		filter = assert(loadstring("return " .. filterFunction))()
	end

	local args = nil 
	if arguments ~= nil then 
		local f = "return " .. arguments
		args = assert(loadstring(f))()
	end
		
	table.insert(self.handlers, { 
			Id = EventManagerID, 
			Owner = owner, 
			Method = method, 
			Arguments = args,
			Filter = filter })

	return EventManagerID
end

--[[
Function: unsubscribe(id)

Unsubscribe an event

Parameters: 

	id - identification on the event
	
See Also:
	<subscribe(owner, method, arguments, filterFunction)>
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
	<subscribe(owner, method, arguments, filterFunction)>
	
Argument: 
	An argument can be a table or just a value
	
Example: 
	>self.onEvent:raise( 10 ) -- a value
	
	>self.onEvent:raise( "run" ) -- a string 
	
	>self.onEvent:raise( { Speed=10, Message="run" } ) -- a table

]]
function EventManager:raise(args)
	for i = 1, #self.handlers do
		local handler = self.handlers[i]
		if handler ~= nil then
			
			local arguments = args
			
			if 	handler.Arguments ~= nil
			and handler.Arguments ~= "" then
				
				-- there is an JSON argument
				local handlerArgs = handler.Arguments(args)
				if 	type(handlerArgs) == "table" 
				and type(args) == "table" then
					-- overwrite any JSON argument with an incoming argument
					for k,v in pairs(handlerArgs) do
						local argv = v
						for k2, v2 in pairs(args) do 
							if k == k2 then
								argv = v2
								break
							end
						end
						arguments[k]=argv
					end
				else
					arguments = args
				end
			end
				
			if	handler.Filter ~= nil 
			and	handler.Filter ~= "" then 
				if handler.Filter(args) then
					handler.Method(handler.Owner, arguments)
				end
			else
				handler.Method(handler.Owner, arguments)
			end
		end
	end
end