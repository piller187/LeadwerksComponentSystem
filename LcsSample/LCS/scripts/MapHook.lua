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

import "LCS/scripts/JsonSource.lua"
import "LCS/scripts/EntityCreator.lua"
import "LCS/scripts/ComponentCreator.lua"
import "LCS/scripts/MessageCreator.lua"

LCS_SOURCE = ""

local jsonSource = nil
local entCreator = nil

--called when map is loaded
function MapHook(entity,obj)

	-- first time setup
	if jsonSource == nil then
		jsonSource = JsonSource:create()
		Debug:Assert( jsonSource ~= nil, "Failed to create JsonSource" )
		jsonSource:process(LCS_SOURCE)
		
		entCreator = EntityCreator:create(jsonSource:getEntitys())
		Debug:Assert( entCreator ~= nil, "Failed to create EntityCreator" )
		
		local componentCreator = ComponentCreator:create()
		Debug:Assert( componentCreator ~= nil, "Failed to create ComponentCreator" )
		componentCreator:process(jsonSource:getComponents())
		
		local messageCreator = ComponentCreator:create()
		Debug:Assert( messageCreator ~= nil, "Failed to create MessageCreator" )
		componentCreator:process(jsonSource:getMessages())
	end

	if 	entity.script ~= nil then
		entCreator:process(	entity,
							jsonSource:getEntitys(),
							jsonSource:getComponents(), 
							jsonSource:getMessagePool() )
	end
end