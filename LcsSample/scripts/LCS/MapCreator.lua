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

if MapCreator ~= nil then return end
MapCreator = {}

MapCreator.entCreator = nil
MapCreator.messageCreator = nil
MapCreator.componentCreator = nil
MapCreator.jsonSource = nil
MapCreator.map = ""

function MapCreator:create(jsonSource,map)
	obj = {}
    setmetatable(obj, self)
    self.__index = self
	self.jsonSource = jsonSource
	self.map = FileSystem:StripAll(map)
	
	self.entCreator = EntityCreator:create()
	Debug:Assert( self.entCreator ~= nil, "MapCreator failed to create EntityCreator" )
	
	self.messageCreator = MessageCreator:create()
	Debug:Assert( self.messageCreator ~= nil, "MapCreator failed to create MessageCreator" )

	self.componentCreator = ComponentCreator:create()
	Debug:Assert( self.componentCreator ~= nil, "MapCreator failed to create ComponentCreator" )

	for k, v in pairs(MapCreator) do
		obj[k] = v
	end

    return obj
end

function MapCreator:process()
	self.messageCreator:process(self.jsonSource:getMapMessages(self.map))
	self.componentCreator:process(self.jsonSource:getMapComponents(self.map))
end

function MapCreator:processEntity(entity)
	self.entCreator:process(	entity,
						self.jsonSource:getMapEntitys(self.map),
						self.jsonSource:getMapComponents(self.map), 
						self.messageCreator:getMessagePool() )
end