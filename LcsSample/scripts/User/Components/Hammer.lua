---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Hammer ~= nil then return end
Hammer = {}

---
--- Public
---


function Hammer:init()
	local obj = {}
	self.__index = self

	-- Init non-entity related things here
	self.name = "Hammer"

	self.entity = nil
	
	for k, v in pairs(Hammer) do
		obj[k] = v
	end
	return obj
end

function Hammer:attach(entity)
	-- Init entity related things here
	self.entity = entity

end

function Hammer:update()
end

function Hammer:updatePhysics()
end

function Hammer:overlap(entity)
end

function Hammer:draw()
end

function Hammer:drawEach(camera)
end

function Hammer:postRender(context)
end

function Hammer:detach()
end

---
--- Actions
---
function Hammer:Use()
end

function Hammer:StopUsing()
end

---
--- Private
---