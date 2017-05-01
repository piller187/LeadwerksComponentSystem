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

import "Scripts/LCS/GameObject.lua"
import "Scripts/LCS/LcsUtils.lua"

if EntityCreator ~= nil then return end
EntityCreator = {}


--
-- Public methods
--
function EntityCreator:create(json)
	local obj = {}
    setmetatable(obj, self)
    self.__index = self

	self.persistent = {}
	self.gameobjects = json:getGameObjects()
	
	for k, v in pairs(EntityCreator) do
		obj[k] = v
	end

    return obj
end

function EntityCreator:process(entity)
	for k,v in pairs(self.gameobjects) do
		if v.name == entity:GetKeyValue("name") then 
			self:createObject(entity,v) 
		end
	end
end
	
function EntityCreator:createObject(entity,gameobject)
	
	local entname = entity:GetKeyValue("name")

	-- always attach the template script
	entity:SetScript( "scripts/LCS/Templates/ENTITY.lua" )
	
	-- persistent
	if 	gameobject.persistent == "true" then 
	
		-- attach to existing
		if self.persistent[gameobject.name] ~= nil then
			self.persistent[gameobject.name]:attach(entity)
	
		-- create, attach and store
		else 
			self.persistent[gameobject.name] = GameObject:create(entity,gameobject)
			self.persistent[gameobject.name]:attach(entity)
		end
		
		entity.script.gameobject = self.persistent[gameobject.name] 
		
	-- non-persisent
	else
		entity.script.gameobject = GameObject:create(entity,gameobject)
		entity.script.gameobject:attach(entity)

	end
end