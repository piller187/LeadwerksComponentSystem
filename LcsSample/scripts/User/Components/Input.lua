---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Input ~= nil then return end
Input = {}

---
--- Public
---
Input.name = "Input"
	
function Input:init()
	local obj = {}
	self.__index = self

	self.onReceiveMessage = EventManager:create()
	self.onClick = EventManager:create()
	self.onForward = EventManager:create()
	self.onBack = EventManager:create()
	self.onStop = EventManager:create()
	
	for k, v in pairs(Input) do
		obj[k] = v
	end
	return obj
end

function Input:attach(entity)
	self.entity = entity
	self.moving = false
end

function Input:update()
	if Window:GetCurrent():MouseHit(1) then
		self:doClick()
	end
	
	if Window:GetCurrent():KeyDown(Key.W) and not self.moving then
		self.moving = true
		self:doForward()
	
	elseif Window:GetCurrent():KeyDown(Key.S) and not self.moving  then
		self.moving = true
		self:doBack()
		
	elseif self.moving then
		self.moving = false
		self:doStop()
	end
end

---
--- Actions
---
function Input:doClick()
	self.onClick:raise()
end

function Input:doForward()
	self.onForward:raise()
end

function Input:doBack()
	self.onBack:raise()
end

function Input:doStop()
	self.onStop:raise()
end

---
--- Private
---