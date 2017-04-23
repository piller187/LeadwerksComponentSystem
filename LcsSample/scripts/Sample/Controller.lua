--
-- Controls movment of an entity
--

import "Scripts/LCS/EventManager.lua"

if Controller ~= nil then return end
Controller = {}

--
-- Variables
--
Controller.move = 0
Controller.jump = 0
Controller.angle = 0
Controller.entity = nil
Controller.lastPos = Vec3(0)
Controller.eyePos = 0.8
Controller.moveTime = 4000
Controller.moveTimeout  = 0
Controller.entity = nil

Controller.moveSpeed = 4
Controller.jumpForce = 8

--
-- Events
-- 
Controller.onMoving = nil
Controller.onStartedMoving = nil
Controller.onStoppedMoving = nil

--
-- Public
--
function Controller:create(entity)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	self.entity = entity

	local mat = Material:Load("Materials/Effects/Invisible.mat")
	self.entity:SetMaterial(mat)
	mat:Release()

	local name = entity:GetKeyValue("name")
	local val = entity:GetKeyValue("eyePos")
	self.eyepos = tonumber(val)
	
	self.onMoving=EventManager:create()
	self.onStoppedMoving=EventManager:create()
	self.onStartedMoving=EventManager:create()

	self:doStop()

	for k, v in pairs(Controller) do
		obj[k] = v
	end
	return obj
end

function Controller:update()
	if 	self.moveTimeout > 0 
	and self.move <= 0 then
		self:doStop()
		return
	end

	local pos = self.entity:GetPosition(true)
	if pos ~= self.lastPos then
		self.onMoving:raise(pos+Vec3(0,self.eyePos,0))
		self.lastPos = pos
		self.idleSent = false
	end
end

function Controller:physUpdate()
	self.entity:SetInput( self.angle, self.move, 0, self.jump )
	self.jump = 0 --or else we will jump forever
end

function Controller:draw(context)
end

function Controller:destroy()
end

function Controller:onCollision(entity, position, normal, speed)
end

--
-- Actions
--
function Controller:doMove()
	if self.move > 0 then 
		self:doStop()
	else 
		self.move = self.moveSpeed 
		self.moveTimeout = Time:Millisecs() + self.moveTime 
		self.onStartedMoving:raise()
	end
end

function Controller:doJump()
	self.jump = self.jumpForce 
end

function Controller:doTurn(angle)
	self.angle = angle
end

function Controller:doStop()
	self.move = 0
	self.moveTimeout = 0
	self.onStoppedMoving:raise()
end

--
-- Private
--