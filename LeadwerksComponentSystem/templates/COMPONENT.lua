---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if NAME ~= nil then return end
NAME = {}

---
--- Public
---

function NAME:init()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	-- Init non-entity related things here
	self.name = "NAME"
	
	for k, v in pairs(NAME) do
		obj[k] = v
	end
	return obj
end

function NAME:attach(entity)
	-- Init entity related things here
	self.entity = entity
	System:Print( "@LCS: attaching " .. self.name .. " to " .. entity.script.gameobject.name )
	
	-- Subscribe for collisions
	-- self.entity.onCollision:subscribe( self, self.doCollision)
end

function NAME:update()
end

function NAME:updatePhysics()
end

function NAME:overlap(entity)
end

function NAME:draw()
end

function NAME:drawEach(camera)
end

function NAME:postRender(context)
end

function NAME:detach()
end

---
--- Actions
---


-- Handle subscribed collision 
-- arg = { Owner:entity, Entity:entity, Distance:number, Pos:Vec3, Normal:Vec3, Speed=number} 
--[[
function NAME:doCollision( arg )
end
]]

---
--- Private
---