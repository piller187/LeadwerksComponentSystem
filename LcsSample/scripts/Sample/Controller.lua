--
-- Controls movment of an entity
--

import "Scripts/LCS/EventManager.lua"

if Controller ~= nil then return end
Controller = {}

--
-- Public
--
function Controller:init()
	local obj = {}
	self.__index = self
	
	self.move = 0
	self.jump = 0
	self.angle = 0
	self.lastPos = Vec3(0)
	self.eyePos = 0.8
	self.moveTime = 4000
	self.moveTimeout  = 0
	
	self.moveSpeed = 4
	self.jumpForce = 8

	self.eyepos = tonumber(val)
	
	self.onMoving=EventManager:create()
	self.onStoppedMoving=EventManager:create()
	self.onStartedMoving=EventManager:create()

	for k, v in pairs(Controller) do
		obj[k] = v
	end
	return obj
end

function Controller:attach(entity)
	self.entity = entity

	local mat = Material:Load("Materials/Effects/Invisible.mat")
	self.entity:SetMaterial(mat)
	mat:Release()
	
	self:doStop()
end


function Controller:update()
	if 	self.moveTimeout > 0 
	and Time:Millisecs() > self.moveTimeout 
	and self.move > 0 then
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

function Controller:updatePhysics()
	self.entity:SetInput( self.angle, self.move, 0, self.jump )
	self.jump = 0 --or else we will jump forever
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