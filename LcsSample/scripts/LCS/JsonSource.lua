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

--[[
	Class: JsonSource
	
	Reads a Json Source file and converts it 
	to LUA tables
]]

if JsonSource ~= nil then return end
JsonSource = {}

--
-- Variables used
--
JsonSource.jsonTable = {}

JSON = nil -- GLOBAL JSON


--
-- Public methods
--

--[[
	Function: create()
	
	Create an instance of the class
	and initalizes the Global JSON object 
]]
function JsonSource:create()
	local obj = {}
    self.__index = self
	
	-- one-time load of the routines
	if JSON == nil then 
		JSON = assert(loadfile "Scripts/LCS/JSON.lua")()
	end
	
	for k, v in pairs(JsonSource) do
		obj[k] = v
	end

    return obj
end

--[[
	Function: process(file)
	
	Process the JSON file and convert it 
	into tables
	
	Parameters:
	
	file - The JSON file to process
]]
function JsonSource:process(file)
	
	local stream = assert(io.open(file, "r"))
	Debug:Assert( stream ~= nil, "JsonSource failed to read " .. file )
	--

	local jstring = stream:read("*a")
	Debug:Assert( stream ~= nil, "JsonSource " .. file .. " was empty" )

	self.jsonTable = JSON:decode(jstring)
	Debug:Assert( self.jsonTable ~= nil, "Failed to create jsonTable while decoding " .. file )

	--
	stream:close()

	Debug:Assert( 	self.jsonTable.gameobjects ~= nil
				or  #self.jsonTable.gameobjects == 0 , "game_objects are missing in " .. file )
end

--[[
	Function: getGameObjects()
	
	Return the table of GameObjects

	Returns:
	
	Table of GameObjects
]]
function JsonSource:getGameObjects()
	return self.jsonTable.gameobjects
end

--[[
	Function: getRoot()
	
	Return the Json Root

	Returns:
	
	Json root
]]
function JsonSource:getRoot()
	return self.jsonTable;
end

--[[
	Function: getComponent(name)
	
	Return a named component
	
	Parameters: 
	
	component - the name of the component
	
	Returns: 
	
	The Component or nil if not found
]]
function JsonSource:getComponent(name)
	for k1,v1 in pairs(self.jsonTable.gameobjects) do
		for k2, v2 in pairs( v1.components ) do
			if v2.name == name then
				return v2
			end
		end
	end
end