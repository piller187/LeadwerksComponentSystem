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
	
	-- Create events
	--self.onEvent=EventManager:create()

	for k, v in pairs(NAME) do
		obj[k] = v
	end
	return obj
end

function NAME:attach(entity)
	-- Init entity related things here
	self.entity = entity
end

function NAME:update()
end

function NAME:updatePhysics()
end

function NAME:overlap(entity)
end

function NAME:collision(entity, position, normal, speed)
end

function NAME:draw()
end

function NAME:drawEach(camera)
end

function NAME:postRender(context)
end

function NAME:detach()
end

function NAME:cleanup(context)
end

---
--- Actions
---

function NAME:doAction()
end

---
--- Private
---

