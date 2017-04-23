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
			self:processEntity(entity, v, components, msgpool)
		end
	end
end

--
-- Internals
--
function EntityCreator:processEntity(entity, jent, components, msgpool)
	
	if  jent.name == nil
	or	jent.name == "null" 
	or 	jent.name == "" then
		return
	end
	
	local entname = entity:GetKeyValue("name")
	
	-- add template script
	entity:SetScript( "scripts/LCS/ENTITY.lua" )

	-- key values
	Debug:Assert(jent.key_values ~= nil, "'key_values' are missing in JSON '" .. jent.name .. "'" )
	for k,key in pairs(jent.key_values) do
		entity:SetKeyValue( key.key, key.value )
		Debug:Assert( entity:GetKeyValue(key.key) ~= "", "Failed to register value " .. key.key .. " in " .. entname )
	end

	local script = entity.script
	Debug:Assert( script ~= nil, "Failed to add script to " .. entname )
	
	if script.components == nil then
		script.components = {}
	end
	Debug:Assert( script.components ~= nil, "Failed to add components to script " .. entname )
	
	-- messages
	Debug:Assert(jent.messages ~= nil, "'messages' are missing in JSON '" .. jent.name .. "' for " .. entname )
	for k,msg in pairs(jent.messages) do
		Debug:Assert( msg.name ~= nil and msg.name ~= "", "'name' not defined in JSON messages for " .. entname )
		local name = msg.name
		Debug:Assert( msgpool[name] ~= nil , "Message '" .. name .. " is missing in " .. entname )		
		script.components[name] = msgpool[name]
	end
	
	-- components
	Debug:Assert(jent.components ~= nil, "'components' are missing in JSON '" .. jent.name .. "' for " .. entname )
	for k,comp in pairs(jent.components) do
		Debug:Assert( comp.name ~= nil and comp.name ~= "", "'name' not defined in JSON components for " .. entname )
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
	Debug:Assert(jent.hookups ~= nil, "'hookups' are missing in JSON '" .. jent.name .. "' for " .. entname ) 
	for k,hooks in pairs(jent.hookups) do
			Debug:Assert( hooks.source ~= nil and hooks.source ~= "", "'source' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.destination ~= nil and hooks.destination ~= "", "'destination' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.source_event ~= nil and hooks.source_event ~= "", "'source_event' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.destination_action ~= nil and hooks.destination_action ~= "", "'destination_action' not defined in JSON hookups for " .. entname )
			
			local src = nil
			if hooks.source == "self" then
				src = entity.script
			else
				src = script.components[hooks.source]
			end
			Debug:Assert( src ~= nil, hooks.source .. " is missing as source hookup for " .. entname )
			
			local dst = nil
			if hooks.destination == "self" then
				dst = entity.script
			else 
				dst = script.components[hooks.destination]
			end
			Debug:Assert( dst ~= nil, hooks.destination .. " is missing as destination hookup for " .. entname )

			local ev = "on"..hooks.source_event
			local ac = "do"..hooks.destination_action
			Debug:Assert( src[ev] ~= nil,  ev .. " event not found in " .. hooks.source .. " when processing hookups in " .. entname )
			Debug:Assert( dst[ac] ~= nil,  ac .. " action not found in " .. hooks.destination .. " when processing hookups in " .. entname  )
			
			src[ev]:subscribe( dst, dst[ac])
	end

end