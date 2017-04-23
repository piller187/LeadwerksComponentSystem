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

LCS_SOURCE = ""

local jsonSource = nil
local entCreator = nil
local messageCreator = nil
local componentCreator = nil
		
--called when map is loaded
function MapHook(entity,obj)

	-- first time setup
	if jsonSource == nil then
		FileSystem:CreateDir( "Scripts/LCS/temp" )
		
		jsonSource = JsonSource:create()
		Debug:Assert( jsonSource ~= nil, "Failed to create JsonSource" )
		jsonSource:process(LCS_SOURCE)
		
		entCreator = EntityCreator:create(jsonSource:getEntitys())
		Debug:Assert( entCreator ~= nil, "Failed to create EntityCreator" )
		
		messageCreator = MessageCreator:create()
		Debug:Assert( messageCreator ~= nil, "Failed to create MessageCreator" )
		messageCreator:process(jsonSource:getMessages())

		componentCreator = ComponentCreator:create()
		Debug:Assert( componentCreator ~= nil, "Failed to create ComponentCreator" )
		componentCreator:process(jsonSource:getComponents())
	end

	entCreator:process(	entity,
						jsonSource:getEntitys(),
						jsonSource:getComponents(), 
						messageCreator:getMessagePool() )
end