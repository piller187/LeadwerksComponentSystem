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

--[[ 

Class: ComponentCreator

Creates a component LUA file using GameObject information

from the JSON project file. This Component will be generated with 

folling features. All events given by the JSON GameObject will be 
added as _"onSourceEvent"_ . 

Follwing functions will be available


- *init()*
- *attach(entity)*
- *update()*
- *updatePhysics()*
- *overlap(entity)*
- *draw()*
- *drawEach(camera)*
- *postRender(context)*
- *detach()*
- *doCollision( arg )*

There will also be a _"doEvent"_ function per defined event

See Also:

<ENTITY>

<GameObject>

]]


if ComponentCreator ~= nil then return end
ComponentCreator = {}

--[[

Function: create()

Creates an instance of the class

Returns: 

The created instance
]]

function ComponentCreator:create()
	local obj = {}
    self.__index = self
	
	for k, v in pairs(ComponentCreator) do
		obj[k] = v
	end

    return obj
end


--[[

Function: createComponent( classname, hooks, path )

Creates a component using the JSON GameObject Hooks
The component will be create as file given by the path

Parameters: 

classname - Name of the component class to be created

hooks - hookup part of a JSON GameObject

path - Name of file to be created

]]

function ComponentCreator:createComponent( classname, hooks, values, path )
	
	
	if 	classname == nil 
	or	classname == ""
	or	hooks == nil
	or 	#hooks == 0 
	or  path == nil
	or  path == "" then
		return
	end

	local code = ""
	code = self:addLine( code, "---" )
	code = self:addLine( code, "--- Created by Leadwerks Component System" )
	code = self:addLine( code, "---" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "import \"Scripts/LCS/EventManager.lua\"" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "if " .. classname .. "~= nil then return end" )
	code = self:addLine( code, classname .. " = {}" )
	code = self:addLine( code, classname .. ".name = \"" .. classname .."\"" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "---" )
	code = self:addLine( code, "--- Public" )
	code = self:addLine( code, "---" )
	code = self:addLine( code, "function " .. classname .. ":init()" )
	code = self:addLine( code, "\tlocal obj = {}" )
	code = self:addLine( code, "\tself.__index = self" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "\tself.entity = nil" )
	code = self:addLine( code, "" )
	code = self:addEvents( code, classname, hooks) 
	code = self:addLine( code, "" )
	code = self:addLine( code, "\tfor k, v in pairs(" .. classname ..") do" )
	code = self:addLine( code, "\t\tobj[k] = v" )
	code = self:addLine( code, "\tend" )
	code = self:addLine( code, "\treturn obj" )
	code = self:addLine( code, "end")
	code = self:addLine( code, "")
	code = self:addLine( code, "function " .. classname .. ":attach(entity)")
	code = self:addLine( code, "	-- Init variables here")
	code = self:addLine( code, "	self.entity = entity")
	code = self:addLine( code, "" )
	code = self:addValues( code, values )
	code = self:addLine( code, "" )
	code = self:addLine( code, "	-- Subscribe for collisions" )
	code = self:addLine( code, "	-- self.entity.onCollision:subscribe( self, self.doCollision)" )
	code = self:addLine( code, "end" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "function " .. classname .. ":update()" )
	code = self:addLine( code, "end" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "function " .. classname .. ":updatePhysics()" )
	code = self:addLine( code, "end" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "function " .. classname .. ":overlap(entity)" )
	code = self:addLine( code, "end" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "function " .. classname .. ":draw()" )
	code = self:addLine( code, "end" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "function " .. classname .. ":drawEach(camera)" )
	code = self:addLine( code, "end" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "function " .. classname .. ":postRender(context)" )
	code = self:addLine( code, "end" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "function " .. classname .. ":detach()" )
	code = self:addLine( code, "end" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "---" )
	code = self:addLine( code, "--- Actions" )
	code = self:addLine( code, "---" )
	code = self:addActions(code, classname, hooks) 
	code = self:addSaveFunction(code, classname, values)
	code = self:addLine( code, "" )
	code = self:addLoadFunction(code, classname, values)
	code = self:addLine( code, "" )
	code = self:addLine( code, "-- Handle subscribed collision " )
	code = self:addLine( code, "-- arg = { Owner:entity, Entity:entity, Distance:number, Pos:Vec3, Normal:Vec3, Speed=number}" ) 
	code = self:addLine( code, "--[[" )
	code = self:addLine( code, "function " .. classname .. ":doCollision( arg )" )
	code = self:addLine( code, "end" )
	code = self:addLine( code, "]]" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "---" )
	code = self:addLine( code, "--- Private" )
	code = self:addLine( code, "---" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "--- EOF ---" )
	
	local file = io.open(path,"w")
	if file ~= nil then
		file:write(code)
		file:close()
	end
end

function ComponentCreator:addLine(code, line)
	if line == nil or line == "" then code = code .. "\n" 
	else code = code .. line .. "\n" end
	return code
end

function ComponentCreator:addEvents(code, classname, hooks)
	code = self:addLine(code, "\t--- Events" )
	for k,v in pairs(hooks) do
		if 	v.source == classname
		and v.source_event ~= nil 
		and v.source_event ~= "" then
			if string.find(code, "self.on" .. v.source_event .. " = EventManager" ) == nil then
				code = self:addLine( code, "\tself.on" .. v.source_event .. " = EventManager:create()")
			end
		end
		if 	v.destination == classname
		and v.destination_action ~= nil 
		and v.destination_action~= "" then
			if string.find(code, "self.on" .. v.destination_action .. " = EventManager" ) == nil then
				code = self:addLine( code, "\tself.on" .. v.destination_action .. " = EventManager:create()")
			end
		end
	end
	return code 
end


function ComponentCreator:addValues(code, values )
	if values ~= nil then 
		code = self:addLine(code, "\t--- Values" )
		for k,v in pairs(values) do
			if 	v.name ~= nil 	and v.name ~= "" 
			and v.value ~= nil 	and v.value ~= "" 
			and v.type ~= nil 	and v.type ~= ""
			and isValidJsonType(v.type)
			then
				code = self:addLine( code, "\tself." .. v.name .. " = " .. jvalueToStr(v.type, v.value) ) 
			end
		end
	end
	return code 
end

function ComponentCreator:addSaveFunction( code, classname, values )
	code = self:addLine(code, "function " .. classname .. ":doSave(args)" )
	if values ~= nil then 
		code = self:addLine( code, "\targs.Table."..classname.."={}")
		for k,v in pairs(values) do
			if 	v.name ~= nil 	and v.name ~= "" 
			and v.value ~= nil 	and v.value ~= "" 
			and v.type ~= nil 	and v.type ~= ""
			and v.store ~= nil 	and v.store ~= "" and v.store == "true" 
			then
				code = self:addLine( code, "\targs.Table."..classname.."."..v.name.." = self." .. v.name ) 
			end
		end
	end
	code = self:addLine(code, "end" )
	
	code = self:addLine(code, "" )
	
	code = self:addLine(code, "function " .. classname .. ":doSaveDone()" )
	code = self:addLine(code, "\t-- Called when ALL components are saved" )
	code = self:addLine(code, "end" )
	
	return code 
end

function ComponentCreator:addLoadFunction( code, classname, values )
	code = self:addLine(code, "function " .. classname .. ":doLoad(args)" )
	if values ~= nil then 
		for k,v in pairs(values) do
			if 	v.name ~= nil 	and v.name ~= "" 
			and v.value ~= nil 	and v.value ~= "" 
			and v.type ~= nil 	and v.type ~= ""
			and v.store ~= nil 	and v.store ~= "" and v.store == "true"
			then
				code = self:addLine( code, "\tself."..v.name.."=args.Table."..classname.."."..v.name)
			end
		end
	end
	code = self:addLine(code, "end" )

	code = self:addLine(code, "" )
	
	code = self:addLine(code, "function " .. classname .. ":doLoadDone()" )
	code = self:addLine(code, "\t-- Called when ALL components are loaded" )
	code = self:addLine(code, "end" )
	
	return code 
end


function ComponentCreator:addActions(code, classname, hooks)
	for k,v in pairs(hooks) do
		if 	v.source == classname
		and v.source_event ~= nil 
		and v.source_event ~= "" then
			if string.find(code, ":do" .. v.source_event ) == nil then
				code = self:addLine( code, "function " ..classname.. ":do" .. v.source_event .. "(args)")
				code = self:addLine( code, "\tDebug:Assert( false, \"TODO! Add code in function " .. classname .. ":do" .. v.source_event .. "(args)\" )" )
				code = self:addLine( code, "end")
				code = self:addLine( code, "")
				code = self:addLine( code, "")
			end
		end
		if 	v.destination == classname
		and v.destination_action ~= nil 
		and v.destination_action ~= "" then
			if string.find(code, ":do" .. v.destination_action ) == nil then
				code = self:addLine( code, "function " ..classname.. ":do" .. v.destination_action .. "(args)")
				code = self:addLine( code, "\tDebug:Assert( false, \"TODO! Add code in function " .. classname .. ":do" .. v.destination_action .. "(args)\" )" )
				code = self:addLine( code, "end")
				code = self:addLine( code, "")
				code = self:addLine( code, "")
			end
		end
	end
	return code 
end