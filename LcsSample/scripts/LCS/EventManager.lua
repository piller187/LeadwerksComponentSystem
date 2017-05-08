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
function EventManager:subscribe(owner, method, filterFunction)
	if method == nil then System:Print( debug.traceback() ) end
	Debug:Assert( owner ~= nil, "Calling EventManager:subscribe with Null-Owner" )
	Debug:Assert( method ~= nil, "Calling EventManager:subscribe with Null-Method")
	EventManagerID = EventManagerID+1
	
	local filter = nil 
	if filterFunction ~= nil then 
		filter= assert(loadstring(filterFunction))()
	end
		
	table.insert(self.handlers, { 
			Id = EventManagerID, 
			Owner = owner, 
			Method = method, 
			FilterFunction = filter })

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
			if	handler.FilterFunction ~= nil then
				if handler.FilterFunction(args) then
					handler.Method(handler.Owner, args)
				end
			else
				handler.Method(handler.Owner, args)
			end
		end
	end
end