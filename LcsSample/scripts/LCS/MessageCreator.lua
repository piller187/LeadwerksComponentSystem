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

if MessageCreator ~= nil then return end
MessageCreator = {}

--
-- Public methods
--
function MessageCreator:create()
	local obj = {}
    self.__index = self
	
	for k, v in pairs(MessageCreator) do
		obj[k] = v
	end

    return obj
end


function MessageCreator:createComponent( classname, hooks, path )
	
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
	code = self:addLine( code, "" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "---" )
	code = self:addLine( code, "--- Public" )
	code = self:addLine( code, "---" )
	code = self:addLine( code, "function " .. classname .. ":init()" )
	code = self:addLine( code, "\tlocal obj = {}" )
	code = self:addLine( code, "\tself.__index = self" )
	code = self:addLine( code, "" )
	code = self:addEvents( code, classname, hooks) 
	code = self:addLine( code, "" )
	--code = self:addHookups( code, classname, hooks) 
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "\t-- Init non-entity related things here" )
	--code = self:addLine( code, "\tself.name = \"" .. classname .."\"" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "\tfor k, v in pairs(" .. classname ..") do" )
	code = self:addLine( code, "\t\tobj[k] = v" )
	code = self:addLine( code, "\tend" )
	code = self:addLine( code, "\treturn obj" )
	code = self:addLine( code, "end")
	code = self:addLine( code, "")
	--code = self:addLine( code, "function " .. classname .. ":attach(entity)")
	--code = self:addLine( code, "	-- Init entity related things here")
	--code = self:addLine( code, "	self.entity = entity")
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "	-- Subscribe for collisions" )
	--code = self:addLine( code, "	-- self.entity.onCollision:subscribe( self, self.doCollision)" )
	--code = self:addLine( code, "end" )
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "function " .. classname .. ":update()" )
	--code = self:addLine( code, "end" )
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "function " .. classname .. ":updatePhysics()" )
	--code = self:addLine( code, "end" )
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "function " .. classname .. ":overlap(entity)" )
	--code = self:addLine( code, "end" )
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "function " .. classname .. ":draw()" )
	--code = self:addLine( code, "end" )
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "function " .. classname .. ":drawEach(camera)" )
	--code = self:addLine( code, "end" )
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "function " .. classname .. ":postRender(context)" )
	--code = self:addLine( code, "end" )
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "function " .. classname .. ":detach()" )
	--code = self:addLine( code, "end" )
	--code = self:addLine( code, "" )
	code = self:addLine( code, "---" )
	code = self:addLine( code, "--- Actions" )
	code = self:addLine( code, "---" )
	code = self:addActions(code, classname, hooks) 
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "-- Handle subscribed collision " )
	--code = self:addLine( code, "-- arg = { Owner:entity, Entity:entity, Distance:number, Pos:Vec3, Normal:Vec3, Speed=number}" ) 
	--code = self:addLine( code, "--[[" )
	--code = self:addLine( code, "function " .. classname .. ":doCollision( arg )" )
	--code = self:addLine( code, "end" )
	--code = self:addLine( code, "]]" )
	--code = self:addLine( code, "" )
	--code = self:addLine( code, "---" )
	--code = self:addLine( code, "--- Private" )
	--code = self:addLine( code, "---" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "" )
	code = self:addLine( code, "--- EOF ---" )
	
	local file = io.open(path,"w")
	if file ~= nil then
		file:write(code)
		file:close()
	end
end

function MessageCreator:addLine(code, line)
	if line == nil or line == "" then code = code .. "\n" 
	else code = code .. line .. "\n" end
	return code
end

function MessageCreator:addEvents(code, classname, hooks)
	code = self:addLine(code, "\t--- Events" )
	for k,v in pairs(hooks) do
		if 	v.source == classname
		and v.source_event ~= nil 
		and v.source_event ~= "" then
			code = self:addLine( code, "\tself.on" .. v.source_event .. " = EventManager:create()")
		end 		
		if 	v.destination == classname
		and v.destination_action ~= nil 
		and v.destination_action~= "" then
			code = self:addLine( code, "\tself.on" .. v.destination_action .. " = EventManager:create()")
		end 		
	end
	return code 
end

--function MessageCreator:addHookups(code, classname, hooks)
--	code = self:addLine(code, "\t--- Hookups" )
--	for k,v in pairs(hooks) do
--		if 	v.source == classname
--		and v.source_event ~= nil 
--		and v.source_event ~= "" then
--			code = self:addLine( code, "\tself.on" .. v.source_event .. ":subscribe( self, self.do" .. v.source_event .. " )" )
--		end 		
--		if 	v.destination == classname
--		and v.destination_action ~= nil 
--		and v.destination_action ~= "" then
--			code = self:addLine( code, "\tself.on" .. v.destination_action .. ":subscribe( self, self.do" .. v.destination_action .. " )" )
--		end 		
--	end
--	return code 
--end

function MessageCreator:addActions(code, classname, hooks)
	for k,v in pairs(hooks) do
		if 	v.source == classname
		and v.source_event ~= nil 
		and v.source_event ~= "" then
			code = self:addLine( code, "function " ..classname.. ":do" .. v.source_event .. "(args)")
			code = self:addLine( code, "\tself.on" .. v.source_event .. ":raise(args)" )
			code = self:addLine( code, "end")
			code = self:addLine( code, "")
			code = self:addLine( code, "")
		end 		
		if 	v.destination == classname
		and v.destination_action ~= nil 
		and v.destination_action ~= "" then
			code = self:addLine( code, "function " ..classname.. ":do" .. v.destination_action .. "(args)")
			code = self:addLine( code, "\tself.on" .. v.destination_action .. ":raise(args)" )
			code = self:addLine( code, "end")
			code = self:addLine( code, "")
			code = self:addLine( code, "")
		end 		
	end
	return code 
end