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

if ComponentCreator ~= nil then return end
ComponentCreator = {}

--
-- Variables used
--

--
-- Public methods
--
function ComponentCreator:create()
	local obj = {}
    setmetatable(obj, self)
    self.__index = self
	
	for k, v in pairs(ComponentCreator) do
		obj[k] = v
	end

    return obj
end

function ComponentCreator:process(components)
	for k,component in pairs(components) do
		self:processComponent(component)
	end
end

function ComponentCreator:processComponent(component)
	
	if  component.name == nil
	or	component.name == "null" 
	or 	component.name == "" then
		return
	end
	
	
	-- add template script
	Debug:Assert(component.name ~= nil and component.name ~= "", "'name' is missing in JSON Message" )

	-- declaration
	local code = "" ..
	"import \"Scripts/LCS/EventManager.lua\"\n" ..
	"if " .. component.name .. " ~= nil then return end\n" ..
	component.name .. " = {}\n" ..
	"\n"
	
	-- values
	Debug:Assert(component.values ~= nil, "'values' are missing in JSON " .. component.name )
	for k,v in pairs(component.values) do
		code = code ..
		component.name .. "." .. v.key .. " = " .. v.value .. "\n"
	end
	code = code .. component.name .. ".entity = nil\n"
	code = code .. "\n"
	
	-- events declaration
	Debug:Assert(component.events ~= nil, "Events are missing in JSON for '" ..component.name .. "'" )
	for k,v in pairs(component.events) do
		code = code .. component.name .. ".on" .. v.name .. " = nil\n"
	end
	code = code .. "\n"
	
	-- create
	code = code .. 
	"function " .. component.name .. ":create(entity)\n" ..
	"\tlocal obj = {}\n" ..
    "\tsetmetatable(obj, self)\n" ..
    "\tself.__index = self\n\n" ..
	"\tself.entity = entity\n\n"
	
	-- events creation inside create function
	for k,v in pairs(component.events) do
		code = code .. "\tself.on" .. v.name .. "=EventManager:create()\n"
	end
	code = code .. "\n"
	
	-- finish create
	code = code ..
	"\tfor k, v in pairs(" .. component.name .. ") do\n" ..
	"\t\tobj[k] = v\n" ..
	"\tend\n" ..
    "\treturn obj\n" ..
	"end\n" ..
	"\n"
	
	-- component functions
	code = code ..
	"function " .. component.name .. ":update()\n" ..
	"end\n" ..
	"\n" ..
	"function " .. component.name .. ":physUpdate()\n" ..
	"end\n" ..
	"\n" ..
	"function " .. component.name .. ":draw(context)\n" ..
	"end\n" ..
	"\n" ..
	"function " .. component.name .. ":destroy()\n" ..
	"end\n" ..
	"\n" ..
	"function " .. component.name .. ":onCollision(entity, position, normal, speed)\n" ..
	"end\n"  ..
	"\n"
	
	-- actions
	if component.actions ~= nil then
		for k,v in pairs(component.actions) do
			code = code .. "function " .. component.name .. ":do" .. v.name .. "("
			if 	v.arg ~= nil 
			and v.arg ~= ""
			and v.arg ~= "null" then
				code = code .. v.arg
			end
			code = code .. 
			")\n" ..
			"end\n" ..
			"\n"
		end
	end
	-- save if not existing already
	local f= io.open(component.path,"r")
	if f==nil then
		self:save(component.path, code)
	else
		f:close()
	end
	
	import(component.path)
	local a = _G[component.name]
	Debug:Assert( a ~= nil, "Failed to create " .. component.name )
end

function ComponentCreator:save(path,code)
	local file = assert(io.open( path, "w" ))
	Debug:Assert( file ~= nil, "Failed to create " .. path )
	file:write(code)
	file:close()
end