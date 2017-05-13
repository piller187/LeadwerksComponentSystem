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

--[[
	Class: EntityCreator
	
	Create a GameObject that's attached to an entity
	This is done by checking for the entity name in 
	the JSON Source array of GameObjects. 
	
	If a GameObject with that name is found the GameObject
	is created and attached to the entity as Script.gameobject

	The GameObject will contain everything defined in 
	the Json gameobject.
	
	Used by:
	
	<MapHook(entity, obj)>
]]
if EntityCreator ~= nil then return end
EntityCreator = {}


--
-- Public methods
--

--[[
	Function: create(json)
	
	Create an instance for the given JSON Source 
	
	Returns:
	
	A new instance of the class
	
	Example:
	
	>-- create and decode the json file
	>jsonSource = JsonSource:create()
	>jsonSource:process("MyGame.json")
	>gameobjects = json:getGameObjects()
]]

function EntityCreator:create(json)
	local obj = {}
    self.__index = self

	self.persistent = {}
	self.gameobjects = json:getGameObjects()
	
	for k, v in pairs(EntityCreator) do
		obj[k] = v
	end

    return obj
end

--[[
	Function: process(entity)
	
	Processes the entity and create its GameObject
	
	The entity name must be found among the GameObjects
	in order to create anything
	
	If the GameObject is flagged as 'persistent'
	it will be stored and reused when loading another map.
]]
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
			self.persistent[gameobject.name] = GameObject:init()
			self.persistent[gameobject.name]:build(entity,gameobject)
			self.persistent[gameobject.name]:attach(entity)
		end
		
		entity.script.gameobject = self.persistent[gameobject.name] 
		
	-- non-persisent
	else
		entity.script.gameobject = GameObject:init()
		entity.script.gameobject:build(entity,gameobject)
		entity.script.gameobject:attach(entity)
	end
	entity.script.onReceiveMessage = EventManager:create()
	entity.script.onReceiveMessage:subscribe(entity.script.gameobject, entity.script.gameobject.ReceiveMessage )
end