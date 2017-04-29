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
-- source:string: path to JSON source file
function JsonSource:create()
	local obj = {}
    setmetatable(obj, self)
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

function JsonSource:process(file)
	
	local stream = io.open(file, "r")
	
	Debug:Assert( stream ~= nil, "JsonSource failed to read " .. file )
	local jstring = stream:read("*a")
	Debug:Assert( stream ~= nil, "JsonSource " .. file .. " was empty" )
	self.jsonTable = JSON:decode(jstring)
	stream:close()

	Debug:Assert( 	self.jsonTable.maps ~= nil
				or	#self.jsonTable.maps == 0, "maps are missing in " .. file )
	
	Debug:Assert( 	self.jsonTable.shared_gameobjects ~= nil
				or  #self.jsonTable.shared_gameobjects == 0 , "shared game_objects are missing in " .. file )
	
	Debug:Assert( 	self.jsonTable.shared_components ~= nil
				or	#self.jsonTable.shared_components == 0 , "shared components are missing in " .. file )
	
	Debug:Assert( 	self.jsonTable.shared_messages ~= nil
				or	#self.jsonTable.shared_messages, "shared messages are missing in " .. file )
end

function JsonSource:getSharedGameObjects()
	return self.jsonTable.shared_gameobjects
end

function JsonSource:getSharedComponents()
	return self.jsonTable.shared_components
end

function JsonSource:getSharedMessages()
	return self.jsonTable.shared_messages
end

function JsonSource:getMapGameObjects(map)
	for k,v in pairs(self.jsonTable.maps) do
		if v.name == map then
			return v.game_objects
		end
	end
	return nil
end

function JsonSource:getMapComponents(map)
	for k,v in pairs(self.jsonTable.maps) do
		if v.name == map then
			return v.components
		end
	end
	return nil
end

function JsonSource:getMapMessages(map)
	for k,v in pairs(self.jsonTable.maps) do
		if v.name == map then
			return v.messages
		end
	end
	return nil
end