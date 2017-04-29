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

import "Scripts/LCS/JsonSource.lua"
import "Scripts/LCS/GameObjectCreator.lua"
import "Scripts/LCS/ComponentCreator.lua"
import "Scripts/LCS/MessageCreator.lua"

if SharedCreator ~= nil then return end
SharedCreator = {}

SharedCreator.gameObjectCreator = nil
SharedCreator.messageCreator = nil
SharedCreator.componentCreator = nil
SharedCreator.jsonSource = nil

function SharedCreator:create(jsonSource)
	obj = {}
    setmetatable(obj, self)
    self.__index = self
	
	self.jsonSource = jsonSource
	
	self.gameObjectCreator = GameObjectCreator:create()
	Debug:Assert( self.gameObjectCreator ~= nil, "SharedCreator failed to create GameObjectCreator" )
	
	self.messageCreator = MessageCreator:create()
	Debug:Assert( self.messageCreator ~= nil, "SharedCreator failed to create MessageCreator" )

	self.componentCreator = ComponentCreator:create()
	Debug:Assert( self.componentCreator ~= nil, "SharedCreator failed to create ComponentCreator" )
	
	for k, v in pairs(SharedCreator) do
		obj[k] = v
	end
	
    return obj
end

function SharedCreator:process()
	local messages = self.jsonSource:getSharedMessages() 
	if messages ~= nil then self.messageCreator:process(messages) end
	
	local components = self.jsonSource:getSharedComponents() 
	if components ~= nil then self.componentCreator:process(components) end
end

function SharedCreator:processEntity(entity)
	local gameobjects = self.jsonSource:getSharedGameObjects()
	if gameobjects ~= nil then
		self.gameObjectCreator:process(entity, gameobjects,
							self.jsonSource:getSharedComponents(), 
							self.messageCreator:getMessagePool() )
	end
end