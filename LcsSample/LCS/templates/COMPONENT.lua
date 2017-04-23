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
-- Variables used
--

--
-- Events
--

--
-- Create instance
--
function NAME:create(entity)
	local obj = {}
    setmetatable(obj, self)
    self.__index = self
	
	for k, v in pairs(NAME) do
		obj[k] = v
	end

    return obj
end

function NAME:update()
end

function NAME:physUpdate()
end

function NAME:draw(context)
end

function NAME:destroy()
end

function NAME:onCollision(entity, position, normal, speed)
end

--
-- Actions
--
function NAME:doSave(t)
end

function NAME:doLoad(t)
end

