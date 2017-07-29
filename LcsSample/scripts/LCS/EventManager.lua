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
EventManager.coroutines = {}
EventManager.useCoRoutines = true

function EventManager:create()
	obj = {}
    self.__index = self
	self.handlers = {}
	
	for k, v in pairs(EventManager) do
		obj[k] = v
	end

    return obj
end

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
		if string.sub(arguments,1,9) == "function(" then
			args = assert(loadstring("return " .. arguments))()
		else
			args = arguments
		end
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

function EventManager:unsubscribe(id) -- the id returned when subscribing
	for i = 1, #self.handlers do
		if  self.handlers[i].Id == id then
			table.remove(self.handlers, i)
			return
		end
	end
end

function EventManager:raise(args)
	if self.useCoRoutines then
		for i = 1, #self.handlers do
			local handler = self.handlers[i]
			if handler ~= nil then
				if	isValidString(handler.Filter) then 
					if handler.Filter(args) then
						local co = coroutine.create(handler.Method)
						local status, err = coroutine.resume(co, handler.Owner, self:createArguments(handler,args) )
						if status == false then
							System:Print("ERROR: "..err)
							error("Check log for error.")
						end
						if coroutine.status(co) ~= "dead" then
							table.insert( EventManager.coroutines, co )
						end
					end
					
					-- we only call the post function if we have a filter so we don't have to filter again
					if handler.PostFunction ~= nil then
						handler.PostFunction(arguments)
					end
				else
					local co = coroutine.create(handler.Method)
					local status, err = coroutine.resume(co, handler.Owner, self:createArguments(handler,args) )
					if status == false then
						System:Print("ERROR: "..err)
					error("Check log for error.")
					end
					
					if coroutine.status(co) ~= "dead" then
						table.insert( EventManager.coroutines, co )
					end
				end
			end
		end
	else
		for i = 1, #self.handlers do
			local handler = self.handlers[i]
			if handler ~= nil then
				if	isValidString(handler.Filter) then 
					if handler.Filter(args) then
						handler.Method( handler.Owner, self:createArguments(handler,args) )
						if handler.PostFunction ~= nil then
							handler.PostFunction(arguments)
						end			
					end
				else
					handler.Method( handler.Owner, self:createArguments(handler,args) )
				end
			end
		end
	end
end

function EventManager:update()
	for i = #EventManager.coroutines, 1, -1 do
		local co = EventManager.coroutines[i]
		local status, err = coroutine.resume(co) 
		if status == false then
            System:Print("ERROR: "..err)
			error("Check log for error.")
        end
		if coroutine.status(co) == "dead" then
			table.remove(EventManager.coroutines, i)
		end
	end
end


function EventManager:createArguments(handler, args)
			
		local arguments = {}
		if args ~= nil then 
			arguments = args
		end
		
		-- merge with handler args if any
		if  isValidString(handler.Arguments) then
			local tp = type(handler.Arguments) 
			if tp ==  "table" then
				mergeTo(arguments, handler.Arguments(args,handler.Owner) )
			elseif tp == "function" then
				handler.Arguments(args,handler.Owner)
			end
		end
		
		-- merge with handler post if any
		if 	isValidString(handler.PostFunction) then
			mergeTo(arguments, handler.PostFunction(args,handler.Owner) )
		end		
		
		return arguments
end