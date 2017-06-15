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
import "Scripts/LCS/MessageGroup.lua"

local jsonSource = nil
local creator = nil
local currentJsonfile = ""

function LcsLoadMap( mapfile, jsonSourceFile  )
	if FileSystem:GetFileType("LCS/Temp")  ~= FileSystem.Dir then
		FileSystem:DeleteFile("LCS/Temp") -- just in case the file Temp exist
		FileSystem:CreateDir("LCS/Temp" )
	end
	
	if creator ~= nil then
		creator:reset()
	end
	currentJsonfile = jsonSourceFile
	local wasLoaded = Map:Load(mapfile, "MapHook")
	Debug:Assert( wasLoaded, "Failed to load map " .. mapfile ) 
	
	createMessageGroups( jsonSource, creator.objects ) 
	for k,v in pairs(creator.objects) do
		v:addHookups( jsonSource )
	end
end

function LcsSave()
	if 	creator ~= nil 
	and jsonSource ~= nil then
		local t = {}
		
		-- save Json declared values and user data
		for k,v in pairs(creator.objects) do
			v:save( t, jsonSource )
		end
		
		-- tell everything is saved
		for k,v in pairs(creator.objects) do
			for k1,v1 in pairs(v.components) do
				if v1.doSaveDone then v1:doSaveDone() end
			end
		end
		
		-- store result to file
		local stream = assert(io.open(creator.saveFile, "w"))
		Debug:Assert( stream ~= nil, "Failed saving to " .. creator.saveFile )
		local jstring = JSON:encode_pretty(t)
		stream:write( jstring )
		stream:flush()
		stream:close()
	end
end

function LcsLoad()
	if 	creator ~= nil 
	and jsonSource ~= nil then

		-- read from file
		local stream = io.open(creator.saveFile, "r")
		if stream == nil then return end
		Debug:Assert( stream ~= nil, "Failed loading from " .. creator.saveFile )
		local t = JSON:decode(stream:read("*all"))
		stream:flush();
		stream:close();
		
		-- load to gameobject and components
		for k,v in pairs(creator.objects) do
			v:load( t, jsonSource )
		end
		
		-- tell everything is loaded
		for k,v in pairs(creator.objects) do
			for k1,v1 in pairs(v.components) do
				if v1.doLoadDone then v1:doLoadDone() end
			end
		end
	end
end

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