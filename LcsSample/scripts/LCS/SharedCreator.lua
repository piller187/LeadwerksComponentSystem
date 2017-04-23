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
import "Scripts/LCS/EntityCreator.lua"
import "Scripts/LCS/ComponentCreator.lua"
import "Scripts/LCS/MessageCreator.lua"

if SharedCreator ~= nil then return end
SharedCreator = {}

SharedCreator.entCreator = nil
SharedCreator.messageCreator = nil
SharedCreator.componentCreator = nil
SharedCreator.jsonSource = nil

function SharedCreator:create(jsonSource)
	obj = {}
    setmetatable(obj, self)
    self.__index = self
	
	self.jsonSource = jsonSource
	
	self.entCreator = EntityCreator:create()
	Debug:Assert( self.entCreator ~= nil, "SharedCreator failed to create EntityCreator" )
	
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
	self.messageCreator:process(self.jsonSource:getSharedMessages())
	self.componentCreator:process(self.jsonSource:getSharedComponents())
end

function SharedCreator:processEntity(entity)
	self.entCreator:process(	entity,
						self.jsonSource:getSharedEntitys(),
						self.jsonSource:getSharedComponents(), 
						self.messageCreator:getMessagePool() )
end