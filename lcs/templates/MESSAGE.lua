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

import "lcs/scripts/EventManager.lua"

if NAME ~= nil then return end
NAME = {}

--
-- Events
--
NAME.onSave = nil
NAME.onLoad = nil

--
-- Create instance
--
function NAME:create(entity)
	local obj = {}
    setmetatable(obj, self)
    self.__index = self

	self.onSave = EventManager:create()
	self.onLoad  = EventManager:create()
	
	for k, v in pairs(NAME) do
		obj[k] = v
	end

    return obj
end

--
-- Actions
--
function NAME:doSave(t)
	self.onSave:raise(t)
end

function NAME:doLoad(t)
	self.onLoad:raise(t)
end
