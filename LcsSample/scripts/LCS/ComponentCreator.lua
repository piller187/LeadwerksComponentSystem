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

import "Scripts/LCS/LcsUtils.lua"

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

function ComponentCreator:paragraph(title)
	return
	"---\n" ..
	"--- " .. title .. "\n" ..
	"---\n" ..
	"\n"
end

function ComponentCreator:processComponent(component)

	-- validation
	if  component == nil
	or	component.name == nil 
	or 	component.name == "" then
		return
	end
	
	-- add template script
	-- declaration
	local code = self:paragraph( "Created by Leadwerks Component System")
	code = code .. 
	"import \"Scripts/LCS/EventManager.lua\"\n\n" ..
	"if " .. component.name .. " ~= nil then return end\n" ..
	component.name .. " = {}\n" ..
	"\n"
	
	
	-- values
	code = code .. self:paragraph("Values")
	if component.values ~= nil and #component.values > 0 then
		for k,v in pairs(component.values) do
			if 	v.name ~= nil and v.name ~= "" 
			and	v.value ~= nil and v.value ~= ""  
			and	v.type ~= nil and v.type ~= "" then 
				code = code ..
				component.name .. "." .. v.name .. " = " .. jvalueToStr(v.type,v.value) .. "\n"
			end
		end
		code = code .. component.name .. ".owner = nil\n"
		code = code .. "\n"
	end
	
	-- events declaration
	code = code .. self:paragraph("Events")
	if component.events ~= nil and #component.events > 0 then
		for k,v in pairs(component.events) do
			if 	v.name ~= nil and v.name ~= "" then 
				code = code .. component.name .. ".on" .. v.name .. " = nil\n"
			end
		end
		code = code .. "\n"
	end
	
	-- create
	code = code .. self:paragraph("Public")
	code = code .. 
	"function " .. component.name .. ":create(owner)\n" ..
	"\tlocal obj = {}\n" ..
    "\tsetmetatable(obj, self)\n" ..
    "\tself.__index = self\n\n" ..
	"\tself.owner = owner\n\n"
	
	-- events creation inside create function
	if component.events ~= nil and #component.events > 0 then
		for k,v in pairs(component.events) do
			code = code .. "\tself.on" .. v.name .. "=EventManager:create()\n"
		end
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
	"function " .. component.name .. ":updatePhysics()\n" ..
	"end\n" ..
	"\n" ..
	"function " .. component.name .. ":overlap(entity)\n" ..
	"end\n" ..
	"\n" ..
	"function " .. component.name .. ":collision(entity, position, normal, speed)\n" ..
	"end\n"  ..
	"\n" ..
	"function " .. component.name .. ":draw()\n" ..
	"end\n" ..
	"\n" ..
	"function " .. component.name .. ":drawEach(camera)\n" ..
	"end\n" ..
	"\n" ..
	"function " .. component.name .. ":postRender(context)\n" ..
	"end\n" ..
	"\n" ..
	"function " .. component.name .. ":detach()\n" ..
	"end\n" ..
	"\n" ..
	"function " .. component.name .. ":cleanup(context)\n" ..
	"end\n" ..
	"\n"
	
	-- actions
	code = code .. self:paragraph("Actions")
	if component.actions ~= nil and #component.actions > 0 then
		for k,v in pairs(component.actions) do
			if v.name ~= nil and v.name ~= "" then 
				code = code .. "function " .. component.name .. ":do" .. v.name .. "("
				if 	v.arg ~= nil and v.arg ~= "" then
					code = code .. v.arg
				end
				code = code .. 
				")\n" ..
				"end\n" ..
				"\n"
			end
		end
	end
	code = code .. self:paragraph("Private")
	

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