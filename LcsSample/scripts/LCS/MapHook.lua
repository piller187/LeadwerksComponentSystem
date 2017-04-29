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

local jsonSource = nil
local creator = nil

--called when map is loaded
function MapHook(entity,obj)
	
	Debug:Assert( currentMap ~= "", "Use LcsLoadMap(mapfile) to load maps. !!!NOT!!! Map:Load(mapfile)" )

	-- first time setup
	if jsonSource == nil then
		
		jsonSource = JsonSource:create()
		Debug:Assert( jsonSource ~= nil, "Failed to create JsonSource" )
		jsonSource:process(currentJsonfile)

		creator = GameObjectCreator:create(jsonSource)
	end

	creator:process(entity)
end

function LcsLoadMap( mapfile, jsonSource  )
	currentJsonfile = jsonSource
	local wasLoaded = Map:Load(mapfile, "MapHook")
	Debug:Assert( wasLoaded, "Failed to load map " .. mapfile ) 
end
