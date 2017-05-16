---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Controller~= nil then return end
Controller = {}


---
--- Public
---
function Controller:init()
	local obj = {}
	self.__index = self

	self.entity = nil
	--- Events
	self.onMove = EventManager:create()
	self.onJump = EventManager:create()

	-- Init non-entity related things here
	self.name = "Controller"
	self.jump = 0
	self.move = 0
	
	for k, v in pairs(Controller) do
		obj[k] = v
	end
	return obj
end

function Controller:attach(entity)
	-- Init entity related things here
	self.entity = entity
	self.moveSpeed = entity.script.moveSpeed
	self.jumpForece = entity.script.jumpForce 
	
	-- Subscribe for collisions
	-- self.entity.onCollision:subscribe( self, self.doCollision)
end

function Controller:update()
end

function Controller:updatePhysics()
	self.entity:SetInput( 0, self.move, self.jump , 0)
	self.jump = 0
end

function Controller:overlap(entity)
end

function Controller:draw()
end

function Controller:drawEach(camera)
end

function Controller:postRender(context)
end

function Controller:detach()
end

---
--- Actions
---
function Controller:doMove(args)
	self.move = self.moveSpeed
end


function Controller:doJump(args)
	self.jump = self.jumpForce
end



-- Handle subscribed collision 
-- arg = { Owner:entity, Entity:entity, Distance:number, Pos:Vec3, Normal:Vec3, Speed=number}
--[[
function Controller:doCollision( arg )
end
]]

---
--- Private
---


--- EOF ---
