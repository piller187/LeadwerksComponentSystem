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

if MessageCreator ~= nil then return end
MessageCreator = {}

--
-- Variables used
--
MessageCreator.shared = {}

--
-- Public methods
--
function MessageCreator:create()
	local obj = {}
    setmetatable(obj, self)
    self.__index = self
	
	for k, v in pairs(MessageCreator) do
		obj[k] = v
	end

    return obj
end

function MessageCreator:process(messages)
	for k,message in pairs(messages) do
		self:processMessage(message)
	end
end

function MessageCreator:processMessage(message)

	if  message.name == nil
	or 	message.name == "" then
		return
	end
	
	-- declaration
	local code = "" ..
	"import \"Scripts/LCS/EventManager.lua\"\n" ..
	"if " .. message.name .. " ~= nil then return end\n" ..
	message.name .. " = {}\n" ..
	"\n"
	
	-- events declaration
	Debug:Assert(message.events ~= nil, "Events are missing in JSON for '" ..message.name .. "'" )
	for k,v in pairs(message.events) do
		if v.name ~= nil and v.name ~= "" then
			code = code .. message.name .. ".on" .. v.name .. " = nil\n"
		end
	end
	code = code .. "\n"
	
	-- create
	code = code .. 
	"function " .. message.name .. ":create()\n" ..
	"\tlocal obj = {}\n" ..
    "\tsetmetatable(obj, self)\n" ..
    "\tself.__index = self\n\n"
	
	-- events creation inside create function
	if message.events ~= nil and #message.events > 0 then 
		for k,v in pairs(message.events) do
			code = code .. "\tself.on" .. v.name .. "=EventManager:create()\n"
		end
	end
	code = code .. "\n"
	
	-- finish create
	code = code ..
	"\tfor k, v in pairs(" .. message.name .. ") do\n" ..
	"\t\tobj[k] = v\n" ..
	"\tend\n" ..
    "\treturn obj\n" ..
	"end\n" ..
	"\n"
	
	-- actions
	if message.events ~= nil and #message.events >  0 then
		for k,v in pairs(message.events) do
			if v.name ~= nil and v.name ~= "" then
				code = code .. "function " .. message.name .. ":do" .. v.name .. "("
				if 	v.arg ~= nil and v.arg ~= ""  then
					code = code .. v.argument 
				end
				code = code .. 
				")\n" ..
				"\tself.on" .. v.name .. ":raise(" 
				if 	v.arg ~= nil and v.arg ~= "" then 
						code = code .. v.argument 
				end
				code = code .. 
				")\n" ..
				"end\n" ..
				"\n"
			end
		end
	end
	-- save to temp so it can be checked 
	self:save(code)
	
	import("Scripts/LCS/temp/message.lua")
	local a = _G[message.name]
	if a ~= nil then
		a:create()
		self.shared[message.name] = a
	end
end

function MessageCreator:save(code)
	local file = io.open( "Scripts/LCS/temp/message.lua", "w" )
	Debug:Assert( file ~= nil, "Faild to create 'LCS/temp/message.lua'")
	file:write(code)
	file:close()
end


function MessageCreator:getMessagePool()
	return self.shared
end