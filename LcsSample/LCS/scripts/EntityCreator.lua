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


if EntityCreator ~= nil then return end
EntityCreator = {}

--
-- Variables used
--
EntityCreator.template = "lcs/templates/ENTITY.lua"

--
-- Public methods
--
function EntityCreator:create()
	local obj = {}
    setmetatable(obj, self)
    self.__index = self
	
	for k, v in pairs(EntityCreator) do
		obj[k] = v
	end

    return obj
end

function EntityCreator:process(entity, entitys, components, msgpool )
	for k,v in pairs(entitys) do
		if v.name == entity:GetKeyValue("name") then
			self:processEntity(entity, v, msgpool)
		end
	end
end

--
-- Internals
--
function EntityCreator:processEntity(entity, jent, components, msgpool)
	
	-- add template script
	entity:SetScript( "lcs/templates/ENTITY.lua" )

	-- key values
	Debug:Assert(jent.key_values ~= nil, "'key_values' are missing in JSON '" .. jent.name .. "'" )
	for k,key in pairs(jent.key_values) do
		entity:SetKeyValue( key.name, key.value )
	end

	local script = entity.script
	Debug:Assert( script ~= nil, "Failed to add script to " .. entity:GetKeyValue("name") )
	
	if script.components == nil then
		script.components = {}
	end
	Debug:Assert( script.components ~= nil, "Failed to add components to script " .. entity:GetKeyValue("name") )
	
	-- messages
	Debug:Assert(jent.messages ~= nil, "'messages' are missing in JSON '" .. jent.name .. "' for " .. entity:GetKeyValue("name" ) )
	for k,msg in pairs(jent.messages) do
		Debug:Assert( msg.name ~= nil and msg.name ~= "", "'name' not defined in JSON messages for " .. entity:GetKeyValue("name" ) )
		local name = msg.name
		Debug:Assert( self.shared[name] ~= nil , "Failed to create message '" .. name .. "' for " .. entity:GetKeyValue("name" ) )		
		script.components[name] = msgpool[name]
	end
	
	-- components
	Debug:Assert(jent.components ~= nil, "'components' are missing in JSON '" .. jent.name .. "' for " .. entity:GetKeyValue("name" ) )
	for k,comp in pairs(jent.components) do
		Debug:Assert( comp.name ~= nil and comp.name ~= "", "'name' not defined in JSON components for " .. entity:GetKeyValue("name" ) )
		Debug:Assert( comp.path ~= nil and comp.path ~= "", "'path' not defined in JSON components for " .. entity:GetKeyValue("name" ) )
		for k,c in pairs(components) do
			if c.name == comp.name then 
				import(c.path)
				break
			end
		end
		script.components[comp.name] = _G[comp.name]:create(entity)
		Debug:Assert(script.components[comp.name] ~= nil , "Failed to create component '" .. comp.name .. "'" )		
	end
	
	-- debug 
	for k,v in pairs(entity.script.components) do
		if v == nil then 
			System:Print( k )
		end
	end
	
	-- hookups
	Debug:Assert(jent.hookups ~= nil, "'hookups' are missing in JSON '" .. jent.name .. "' for " .. entity:GetKeyValue("name" ) ) 
	for k,hooks in pairs(jent.hookups) do
			Debug:Assert( hooks.source ~= nil and hooks.source ~= "", "'source' not defined in JSON hookups for " .. entity:GetKeyValue("name" ) )
			Debug:Assert( hooks.destination ~= nil and hooks.destination ~= "", "'destination' not defined in JSON hookups for " .. entity:GetKeyValue("name" ) )
			Debug:Assert( hooks.source_event ~= nil and hooks.source_event ~= "", "'source_event' not defined in JSON hookups for " .. entity:GetKeyValue("name" ) )
			Debug:Assert( hooks.destination_action ~= nil and hooks.destination_action ~= "", "'destination_action' not defined in JSON hookups for " .. entity:GetKeyValue("name" ) )
			
			local src = nil
			if hooks.source == "self" then
				src = entity.script
			else
				src = script.components[hooks.source]
			end
			Debug:Assert( src ~= nil, hooks.source .. " is missing as source hookup for " .. entity:GetKeyValue("name" ) )
			
			local dst = nil
			if hooks.destination == "self" then
				dst = entity.script
			else 
				dst = script.components[hooks.destination]
			end
			Debug:Assert( dst ~= nil, hooks.destination .. " is missing as destination hookup for " .. entity:GetKeyValue("name" ) )

			src[hooks.source_event]:subscribe( dst, dst[hooks.destination_action])
	end

end