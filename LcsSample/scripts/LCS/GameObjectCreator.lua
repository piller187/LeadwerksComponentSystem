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
GameObjectCreator.peristant = {}
GameObjectCreator.messages = {}
GameObjectCreator.gameobjects = nil

--
-- Public methods
--
function GameObjectCreator:create(json)
	local obj = {}
    setmetatable(obj, self)
    self.__index = self
	
	self.gameobjects = json:getGameObjects()
	
	for k, v in pairs(GameObjectCreator) do
		obj[k] = v
	end

    return obj
end

function GameObjectCreator:process(entity)
	
	local entname = entity:GetKeyValue("name")
	
	for k,v in pairs(self.gameobjects) do
		if v.name == entname then self:createObject(entity,v) end
	end
end
	
function GameObjectCreator:createObject(entity,gameobject)
	
	local entname = entity:GetKeyValue("name")

	-- persistant?
	if 	gameobject.peristant  
	and self.peristant[gameobject.name] ~= nil then
		entity = self.peristant[gameobject.name]
		return
	end
	
	-- add template script
	entity:SetScript( "scripts/LCS/GAMEOBJECT.lua" )
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
	script.components = {}
	Debug:Assert( script.components ~= nil, "Failed to add components to script " .. entname )
	
	-- messages
	if gameobject.messages ~= nil and #gameobject.messages >  0 then
		for k,v in pairs(gameobject.messages) do
			if v.name ~= nil and v.name ~= "" then
				if self.messages[v.name] == nil then
					import(v.path)
					self.messages[v.name] = _G[v.name]:create()
				end
				script.components[v.name] = self.messages[v.name]
				script[v.name] = script.components[v.name] 
			end
		end
	end
	
	-- components
	if gameobject.components ~= nil and #gameobject.components >  0 then
		for k,comp in pairs(gameobject.components) do
			if comp.name ~= nil and comp.name ~= "" then
				import(comp.path)
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
	
	-- persistant?
	if 	gameobject.peristant  
	and self.peristant[gameobject.name] == nil then
		self.peristant[gameobject.name] = entity
		self.peristant[gameobject.name]:AddRef()
		return
	end
end