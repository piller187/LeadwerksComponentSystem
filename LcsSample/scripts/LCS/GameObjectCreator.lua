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

if GameObjectCreator ~= nil then return end
GameObjectCreator = {}

--
-- Variables used
--

--
-- Public methods
--
function GameObjectCreator:create()
	local obj = {}
    setmetatable(obj, self)
    self.__index = self
	
	for k, v in pairs(GameObjectCreator) do
		obj[k] = v
	end

    return obj
end

function GameObjectCreator:process(entity, entitys, components, msgpool )
	if entitys ~= nil and #entitys > 0 then
		for k,v in pairs(entitys) do
			if v.name == entity:GetKeyValue("name") then
				self:processEntity(entity, v, components, msgpool)
			end
		end
	end
end

--
-- Internals
--
function GameObjectCreator:processEntity(entity, gameobject, components, msgpool)
	
	local entname = entity:GetKeyValue("name")
	
	-- add template script
	entity:SetScript( "scripts/LCS/GAMEOBJECT.lua" )

	-- key values
	if gameobject.key_values ~= nil and #gameobject.key_values > 0 then
		for k,v in pairs(gameobject.key_values) do
			if 	v.key ~= nil and v.key ~= "" 
			and v.value ~= nil and v.value ~= ""
			and v.type ~= nil and v.type ~= "" then
				entity:SetKeyValue(v.key, jvalueToStr(v.type,v.value))
			end
		end
	end
	
	local script = entity.script
	Debug:Assert( script ~= nil, "Failed to add script to " .. entname )

	
	-- values
	if gameobject.values ~= nil and #gameobject.values > 0 then
		for k,v in pairs(gameobject.values) do
			if 	v.name ~= nil and v.name ~= "" 
			and v.value ~= nil and v.value ~= "" 
			and v.type ~= nil and v.type ~= "" then
				script[v.name]=jvalueToValue(v.type,v.value)
			end
		end
	end
	
	-- components list
	if script.components == nil then
		script.components = {}
	end
	Debug:Assert( script.components ~= nil, "Failed to add components to script " .. entname )
	
	-- messages
	if gameobject.messages ~= nil and #gameobject.messages >  0 then
		for k,v in pairs(gameobject.messages) do
			if v.name ~= nil and v.name ~= "" then
				if msgpool[v.name] then
					script.components[v.name] = msgpool[v.name]
				end
			end
		end
	end
	
	-- components
	if gameobject.components ~= nil and #gameobject.components >  0 then
		for k,comp in pairs(gameobject.components) do
			if comp.name ~= nil and comp.name ~= "" then
				for k,c in pairs(components) do
					if c.name == comp.name then 
						import(c.path)
						break
					end
				end
				script.components[comp.name] = _G[comp.name]:create(entity)
				script[comp.name] = script.components[comp.name] 
			end
		end
	end
	
	-- hookups
	if gameobject.hookups ~= nil and #gameobject.hookups > 0 then 
		for k,hooks in pairs(gameobject.hookups) do
			Debug:Assert( hooks.source ~= nil and hooks.source ~= "", "'source' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.destination ~= nil and hooks.destination ~= "", "'destination' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.source_event ~= nil and hooks.source_event ~= "", "'source_event' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.destination_action ~= nil and hooks.destination_action ~= "", "'destination_action' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.source ~= "self", "source='self' is not supported in hookups")
			Debug:Assert( hooks.destination  ~= "self", "destination='self' is not supported in hookups")
			
			local src = script.components[hooks.source]
			Debug:Assert( src ~= nil, hooks.source .. " is missing as source hookup for " .. entname )
			
			local dst = script.components[hooks.destination]
			Debug:Assert( dst ~= nil, hooks.destination .. " is missing as destination hookup for " .. entname )

			local ev = "on"..hooks.source_event
			local ac = "do"..hooks.destination_action
			Debug:Assert( src[ev] ~= nil,  ev .. " event not found in " .. hooks.source .. " when processing hookups in " .. entname )
			Debug:Assert( dst[ac] ~= nil,  ac .. " action not found in " .. hooks.destination .. " when processing hookups in " .. entname  )
			
			src[ev]:subscribe( dst, dst[ac])
		end
	end
	
		-- PostStart code
	if gameobject.poststart ~= nil and gameobject.poststart ~= "" then
		entity.script.PostStart = loadstring("return function(self) " .. gameobject.poststart .. " end")(entity.script)
		entity.script.PostStart(entity.script)
	end
end