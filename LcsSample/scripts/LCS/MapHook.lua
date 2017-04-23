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
import "Scripts/LCS/SharedCreator.lua"
import "Scripts/LCS/MapCreator.lua"

local jsonSource = nil
local mapCreator = nil
local sharedCreator = nil
local currentMap = ""
local currentJsonfile = ""

--called when map is loaded
function MapHook(entity,obj)
	
	Debug:Assert( currentMap ~= "", "Use LcsLoadMap(mapfile) to load maps. !!!NOT!!! Map:Load(mapfile)" )

	-- first time setup
	if jsonSource == nil then
		FileSystem:CreateDir( "Scripts/LCS/temp" ) -- for temporay lua files

		jsonSource = JsonSource:create()
		Debug:Assert( jsonSource ~= nil, "Failed to create JsonSource" )
		jsonSource:process(currentJsonfile)

		sharedCreator = SharedCreator:create(jsonSource)
		Debug:Assert( sharedCreator ~= nil, "Failed to create SharedCreator" )
		sharedCreator:process()

		mapCreator = MapCreator:create(jsonSource,currentMap)
		Debug:Assert( mapCreator ~= nil, "Failed to create MapCreator" )
		mapCreator:process()
		
	end

	sharedCreator:processEntity(entity)
	mapCreator:processEntity(entity)
end

function LcsLoadMap( mapfile, jsonSource  )
	currentMap = mapfile
	currentJsonfile = jsonSource
	local wasLoaded = Map:Load(mapfile, "MapHook")
	Debug:Assert( wasLoaded, "Failed to load map " .. mapfile ) 
end