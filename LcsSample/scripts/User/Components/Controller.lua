---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Controller ~= nil then return end
Controller = {}

---
--- Public
---
Controller.name = "Controller"

function Controller:init()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	
	self.onMove = EventManager:create()
	
	for k, v in pairs(Controller) do
		obj[k] = v
	end
	return obj
end

function Controller:attach(entity)
	self.entity = entity
	self.move = 0
	self.angle = 0
	self.oldPos = Vec3(0)
	self.moveSpeed = 2
	self.eyePos = 1.6

end

function Controller:update()
	local newpos = self.entity:GetPosition(true)
	if self.oldpos ~= newpos then
		newpos.y = newpos.y + self.eyePos
		self.onMove:raise({Pos=newpos})
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

function Controller:doTurn(args)
	self.angle = args.Angle
end

function Controller:doStop()
	self.move = 0
end


---
--- Private
---