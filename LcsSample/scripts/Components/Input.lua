---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Input~= nil then return end
Input = {}


---
--- Public
---
function Input:init()
	local obj = {}
	self.__index = self

	self.entity = nil
	--- Events
	self.onMove = EventManager:create()
	self.onJump = EventManager:create()
	
	-- Init non-entity related things here
	self.name = "Input"
	self.moving = false
	
	for k, v in pairs(Input) do
		obj[k] = v
	end
	return obj
end

function Input:attach(entity)
	-- Init entity related things here
	self.entity = entity

	-- Subscribe for collisions
	-- self.entity.onCollision:subscribe( self, self.doCollision)
end

function Input:update()
	if Window:GetCurrent():KeyDown(Key.W) and not self.moving then
		self:doMove()
	end
	
	if Window:GetCurrent():KeyHit(Key.Space) then
		self:doJump()
	end
end

function Input:updatePhysics()
end

function Input:overlap(entity)
end

function Input:draw()
end

function Input:drawEach(camera)
end

function Input:postRender(context)
end

function Input:detach()
end

---
--- Actions
---
function Input:doMove(args)
	self.onMove:raise()
end


function Input:doJump(args)
	self.onMove:raise()
end



-- Handle subscribed collision 
-- arg = { Owner:entity, Entity:entity, Distance:number, Pos:Vec3, Normal:Vec3, Speed=number}
--[[
function Input:doCollision( arg )
end
]]

---
--- Private
---


--- EOF ---