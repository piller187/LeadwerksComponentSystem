---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Controller ~= nil then return end
Controller = {}

---
--- Public
---

function Controller:init()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	self.name = "Controller"

	self.move = 0
	self.angle = 0
	self.eyePos = 0
	self.oldPos = Vec3(0)
	self.entity = nil
	self.moveSpeed = 0
	
	self.onMove = EventManager:create()
	
	for k, v in pairs(Controller) do
		obj[k] = v
	end
	return obj
end

function Controller:attach(entity)
	-- Init entity related things here
	self.entity = entity
	self.moveSpeed = entity.script.moveSpeed
	self.eyePos = entity.script.eyePos

end

function Controller:update()
	if self.oldpos ~= self.entity:GetPosition(true) then
		self.onMove:raise(self.entity:GetPosition(true)+Vec3(0,self.eyePos,0),true)
	end
end

function Controller:updatePhysics()
	self.entity:SetInput( self.angle, self.move, 0, 0)
	self.oldpos = self.entity:GetPosition(true)
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
function Controller:doMoveForward()
	self.move = self.moveSpeed 
end

function Controller:doMoveBackwards()
	self.move = -self.moveSpeed 
end

function Controller:doJump(entity)
	self.jump = self.jumpForce 
end

function Controller:doTurn(angle)
	self.angle = angle
end

function Controller:doStop()
	self.move = 0
end


---
--- Private
---