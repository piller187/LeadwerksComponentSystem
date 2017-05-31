---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Hammer~= nil then return end
Hammer = {}

Hammer.name = "Hammer"

---
--- Public
---
function Hammer:init()
	local obj = {}
	self.__index = self

	self.onPicked = EventManager:create()


	for k, v in pairs(Hammer) do
		obj[k] = v
	end
	return obj
end

function Hammer:attach(entity)
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
function Hammer:doPicked(args)
	args.Source.script.gameobject.onReceiveMessage:raise( { Message="hammer.picked", Force = 10 } )
	self.entity:Hide()
end



-- Handle subscribed collision 
-- arg = { Owner:entity, Entity:entity, Distance:number, Pos:Vec3, Normal:Vec3, Speed=number}
--[[
function Hammer:doCollision( arg )
end
]]

---
--- Private
---


--- EOF ---