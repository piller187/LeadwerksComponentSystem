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

if GameObject ~= nil then return end
GameObject = {}

local Messages = {}

--
-- Public methods
--
function GameObject:create(entity,jsonGameObject)
	local obj = {}
    self.__index = self
	
	self.entity = entity
	self.components = {}
	self:createFromJson(entity,jsonGameObject)
	
	for k, v in pairs(GameObject) do
		obj[k] = v
	end

    return obj
end


function GameObject:attach(entity)
		
	self.entity = entity
	self.entity.script.gameobject = self
	
	-- re-attach entity to components
	for k,v in pairs(self.components) do
		if v.attach ~= nil then v:attach(entity) end
	end
end
	
function GameObject:createFromJson(entity, gameobject)

	self.entity = entity
	self.entity.script.gameobject = self
	
	local entname = self.entity:GetKeyValue("name")
	local script = self.entity.script
	
	-- add values
	if gameobject.values ~= nil and #gameobject.values > 0 then

		for k,v in pairs(gameobject.values) do

			if 	v.name ~= nil and v.name ~= "" 
			and v.value ~= nil and v.value ~= "" 
			and v.type ~= nil and v.type ~= "" then

				script[v.name]=jvalueToValue(v.type,v.value)
			end
		end
	end
	
	-- add messages
	if 	gameobject.messages ~= nil 
	and #gameobject.messages >  0 then
		
		for k,v in pairs(gameobject.messages) do

			if 	v.name ~= nil 
			and v.name ~= "" then

				-- needs creation?
				if Messages[v.name] == nil then
					import(v.path)
					Messages[v.name] = _G[v.name]:init()
				end
				-- add to components
				self.components[v.name] = Messages[v.name]
				-- add as member
				script[v.name] = self.components[v.name] 
			end
		end
	end
	
	-- add components
	if gameobject.components ~= nil and #gameobject.components >  0 then
		for k,comp in pairs(gameobject.components) do
			if 	comp.name ~= nil 
			and comp.name ~= "" then
				
				-- always create !
				import(comp.path)
				self.components[comp.name] = _G[comp.name]:init()
				script[comp.name] = self.components[comp.name]
			end
		end
	end
	
	-- hookups
	if 	gameobject.hookups ~= nil 
	and #gameobject.hookups > 0 then 
	
		for k,hooks in pairs(gameobject.hookups) do
			
			-- validate
			Debug:Assert( hooks.source ~= nil and hooks.source ~= "", "'source' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.destination ~= nil and hooks.destination ~= "", "'destination' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.source_event ~= nil and hooks.source_event ~= "", "'source_event' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.destination_action ~= nil and hooks.destination_action ~= "", "'destination_action' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.source ~= "self", "source='self' is not supported in hookups")
			Debug:Assert( hooks.destination  ~= "self", "destination='self' is not supported in hookups")
			
			-- get and verify source
			local src = self.components[hooks.source]
			Debug:Assert( src ~= nil, hooks.source .. " is missing as source hookup for " .. entname )
			
			-- get and verify destiation
			local dst = self.components[hooks.destination]
			Debug:Assert( dst ~= nil, hooks.destination .. " is missing as destination hookup for " .. entname )

			-- get and verify events and actions
			local ev = "on"..hooks.source_event
			local ac = "do"..hooks.destination_action
			Debug:Assert( src[ev] ~= nil,  ev .. " event not found in " .. hooks.source .. " when processing hookups in " .. entname )
			Debug:Assert( dst[ac] ~= nil,  ac .. " action not found in " .. hooks.destination .. " when processing hookups in " .. entname  )
			
			-- create hook
			src[ev]:subscribe( dst, dst[ac])
		end

	end
		-- persistent flag
	self.entity.script.gameobject.persistent = strToBool(gameobject.persistent)
	
	-- PostStart code
	if	gameobject.poststart ~= nil 
	and gameobject.poststart ~= "" then
		-- add PostStart code
		script.PostStart = loadstring("return function(self) " .. gameobject.poststart .. " end")(script)
		script.PostStart(script)
	end
end