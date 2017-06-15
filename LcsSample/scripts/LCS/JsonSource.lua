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

JsonSource.jsonTable = {}
JSON = nil -- GLOBAL JSON


--
-- Public 
--
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

function JsonSource:getGameObjects()
	return self.jsonTable.gameobjects
end

function JsonSource:getGameObject(name)
	for k,v in ipairs(self.jsonTable.gameobjects) do
		if v.name == name then return v end
	end
	return nil
end

function JsonSource:getMessageGroups()
	return self.jsonTable.messagegroups
end

function JsonSource:getRoot()
	return self.jsonTable;
end

function JsonSource:getComponent(name)
	for k1,v1 in pairs(self.jsonTable.gameobjects) do
		for k2, v2 in pairs( v1.components ) do
			if v2.name == name then
				return v2
			end
		end
	end
end