---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Input ~= nil then return end
Input = {}

---
--- Public
---
	
function Input:init()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	self.name = "Input"

	-- Init non-entity related things here
	self.entity = nil
	self.moving = false
	self.onMessage = EventManager:create()
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
	-- Init entity related things here
	self.entity = entity
	System:Print( "@LCS: attaching " .. self.name .. " to " .. entity.script.gameobject.name )

end

function Input:update()
	if Window:GetCurrent():MouseHit(1) then
		self:doClick()
	end
	
	if Window:GetCurrent():KeyDown(Key.W) then
		self.moving = true
		self:doForward()
	
	elseif Window:GetCurrent():KeyDown(Key.S) then
		self.moving = true
		self:doBack()
	else
		self.moving = false
		self:doStop()
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