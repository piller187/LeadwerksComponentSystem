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

local jsonSource = nil
local creator = nil
local currentJsonfile = ""

------------------------------------------------------
-- CALL THIS INSTEAD OF CALLING 'Map:Load' DIRECTLY --
------------------------------------------------------
function LcsLoadMap( mapfile, jsonSource  )
	currentJsonfile = jsonSource
	local wasLoaded = Map:Load(mapfile, "MapHook")
	Debug:Assert( wasLoaded, "Failed to load map " .. mapfile ) 
end

--called when map is loaded
function MapHook(entity,obj)
	
	Debug:Assert( currentJsonfile ~= "", "Use LcsLoadMap(mapfile,jsonSource) to load maps. !!!NOT!!! Map:Load(mapfile)" )

	-- first time setup
	if jsonSource == nil then
		
		-- create and decode the json file
		jsonSource = JsonSource:create()
		Debug:Assert( jsonSource ~= nil, "Failed to create JsonSource" )
		
		jsonSource:process(currentJsonfile)
		
		-- initialize the game creation object
		creator = EntityCreator:create(jsonSource)
	end

	-- process this entity
	-- must have at least a name!
	if entity:GetKeyValue("name") ~= "" then
		creator:process(entity)
	end
end