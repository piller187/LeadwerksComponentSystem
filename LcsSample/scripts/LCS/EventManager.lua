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

-- returns an ID that can be use for unsubsribing
function EventManager:subscribe(owner, method, arguments, filterFunction)
	if method == nil then 
		System:Print( debug.traceback() ) 
	end
	
	Debug:Assert( owner ~= nil, "Calling EventManager:subscribe with Null-Owner" )
	Debug:Assert( method ~= nil, "Calling EventManager:subscribe with Null-Method")
	
	EventManagerID = EventManagerID+1
	
	local func = nil 
	if filterFunction ~= nil then 
		func = assert(loadstring("return " .. filterFunction))()
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
			Function = filter })

	return EventManagerID
end

function EventManager:unsubscribe(id) -- the id returned when subscribing
	for i = 1, #self.handlers do
		if  self.handlers[i].Id == id then
			table.remove(self.handlers, i)
			return
		end
	end
end

function EventManager:raise(args)
	for i = 1, #self.handlers do
		local handler = self.handlers[i]
		if handler ~= nil then
			
			local arguments = args
			if 	handler.Arguments ~= nil
			and handler.Arguments ~= "" then
				local handlerArgs = handler.Arguments(args)
				local handlertype = type(handlerArgs)
				local argstype = type(args)
				if 	type(handlerArgs) == "table" 
				and type(args) == "table" then
					for k,v in pairs(handlerArgs) do
						arguments[k]=v
					end
				
				elseif 	type(handlerArgs) == "string" 
				and		type(args) == "string" then
					arguments = arguments .. "," .. handlerArgs
				end
			end
				
			if	handler.FilterFunction ~= nil 
			and	handler.FilterFunction ~= "" then 
				if handler.FilterFunction(args) then
					handler.Method(handler.Owner, arguments)
				end
			else
				handler.Method(handler.Owner, arguments)
			end
		end
	end
end