---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if RedMeter ~= nil then return end
RedMeter = {}

---
--- Public
---

function RedMeter:init()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	-- Init non-entity related things here
	self.name = "RedMeter"

	self.power = 0
	self.entity = nil
	self.max = 0
	self.xpos = 0
	self.color = Vec4(0)
	self.stepSize = 0
	self.width = 0
	
	for k, v in pairs(RedMeter) do
		obj[k] = v
	end
	return obj
end

function RedMeter:attach(entity)
	-- Init entity related things here
	self.entity = entity
	self.max = entity.script.max
	self.xpos = entity.script.xpos
	self.color = entity.script.color
	self.stepSize = entity.script.stepSize
	self.width = entity.script.width
end

function RedMeter:update()
end

function RedMeter:updatePhysics()
end

function RedMeter:overlap(entity)
end

function RedMeter:draw()
end

function RedMeter:drawEach(camera)
end

function RedMeter:postRender(context)

	-- size
	local hmax = self.max * self.stepSize
	local hval = self.power *  self.stepSize

	-- value
	local bottom_margin = 10
	local sh = context:GetHeight()
	local border = 2;

	local y = sh - bottom_margin - 2 * border - hval

	local v = self.power / self.max
	context:SetColor(1.0 - v, v, 0.0, 1.0)
	context:DrawRect(self.xpos, y, self.width, hval, 0)

	-- border
	y = sh - bottom_margin - 2 * border - hmax
	context:SetColor(Vec4(0,0,0,1))
	context:DrawRect(self.xpos+1, y+1, self.width, hmax, 1)
	context:SetColor(Vec4(1,1,1,1))
	context:DrawRect(self.xpos, y, self.width, hmax, 1)
end

function RedMeter:detach()
end

---
--- Actions
---

function RedMeter:doSet(arg)
	self.power = Math:Clamp(arg.Power, 0, self.max )
end

function RedMeter:doGet()
	return self.power
end

---
--- Private
---