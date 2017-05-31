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
import "Scripts/LCS/JsonValidator.lua"

local jsonSource = nil
local creator = nil
local currentJsonfile = ""

--[[
	Function: LcsLoadMap( mafile, jsonSource )
	
	Loads a map and creates all needed files and/or objects
	using the Project.Json file.

	Parameters:
	
	mapfile - path to Leadwerks map file
	jsonSource - path to LCS Json project file
	
	Important:

	CALL THIS INSTEAD OF CALLING 'Map:Load' DIRECTLY
	
	Example:
	
	>LcsLoadMap("Maps/start.map","MyGame.json")
	
]]
function LcsLoadMap( mapfile, jsonSource  )
	if FileSystem:GetFileType("LCS/Temp")  ~= FileSystem.Dir then
		FileSystem:DeleteFile("LCS/Temp") -- just in cast the file Temp exist
		FileSystem:CreateDir("LCS/Temp" )
	end
	
	currentJsonfile = jsonSource
	local wasLoaded = Map:Load(mapfile, "MapHook")
	Debug:Assert( wasLoaded, "Failed to load map " .. mapfile ) 
	
	for k,v in pairs(creator.objects) do
		System:Print( "@LCS: " .. v.name )
	end
end

--[[
	Function: LcsSave()
	
	Save all GameObject Values to a file 
]]
function LcsSave()
	if creator ~= nil then
		local t = {}
		for k,v in pairs(creator.objects) do
			if v.doSave then 
				v:doSave( {Table=t} ) 
			end
		end
		for k,v in pairs(creator.objects) do
			if v.doSaveDone then v:doSaveDone() end
		end
		local stream = assert(io.open(creator.saveFile, "w"))
		Debug:Assert( stream ~= nil, "Failed saving to " .. creator.saveFile )
		local jstring = JSON:encode_pretty(t)
		stream:write( jstring )
		stream:flush()
		stream:close()
	end
end

--[[
	Function: LcsLoad()
	
	Load all GameObject Values from a file 
]]
function LcsLoad()
	if creator ~= nil then
		local stream = assert(io.open(creator.saveFile, "r"))
		Debug:Assert( stream ~= nil, "Failed loading from " .. creator.saveFile )
		local t = JSON:decode(stream:read("*all"))
		stream:flush();
		stream:close();
		for k,v in pairs(creator.objects) do
			if v.doLoad then v:doLoad({Table=t}) end
		end
		for k,v in pairs(creator.objects) do
			if v.doLoadDone then v:doLoadDone() end
		end
	end
end

--[[
	Function: MapHook(entity, obj)
	
	Called by Map:Load for each entity loaded
	You may also call this anytime with a runtime generated
	entity and obj set to nil.
	
	This function will create GameObjects hooked to the entitys
	and their components, messages and make all hookups 
	
	The json source will be validated and give assertions if
	any errors are found
	
	Parameters:
	
	entity - entity loaded
	obj - ingnored

]]
function MapHook(entity,obj)
	
	Debug:Assert( currentJsonfile ~= "", "Use LcsLoadMap(mapfile,jsonSource) to load maps. !!!NOT!!! Map:Load(mapfile)" )

	-- first time setup
	if jsonSource == nil then
		
		-- create and decode the json file
		jsonSource = JsonSource:create()
		Debug:Assert( jsonSource ~= nil, "Failed to create JsonSource" )
		
		jsonSource:process(currentJsonfile)
		
		local jsonValidator = JsonValidator:create()
		jsonValidator:validate(jsonSource:getRoot())

		-- initialize the game creation object
		creator = EntityCreator:create(jsonSource)
	end

	-- process this entity
	-- must have at least a name!
	if entity:GetKeyValue("name") ~= "" then
		creator:process(entity)
	end
end