---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if RedMeter ~= nil then return end
RedMeter = {}

RedMeter.name = "RedMeter"

---
--- Public
---
function RedMeter:init()
	local obj = {}
	self.__index = self
	
	for k, v in pairs(RedMeter) do
		obj[k] = v
	end
	return obj
end

function RedMeter:attach(entity)
	self.entity = entity
	self.xpos = 4
	self.width = 3 -- %
	self.height = 90 -- %
	self.max = 10
	self.power = 0
	self.disabled = false
	
	local ct = Context:GetCurrent()
	local sh = ct:GetHeight()
	local sw = ct:GetWidth()
	self.width = (self.width/100)*sw
	self.height = (self.height/100)*sh
	self.valueSize = self.height/self.max
	self.pixelValue = Math:Round(self.power * self.valueSize)
	
end

function RedMeter:postRender(context)
	if not self.disabled then
	
		-- size
		local hmax = Math:Round(self.max * self.valueSize)
		local hval = self.pixelValue

		-- value
		local bottom_margin = 10
		local sh = context:GetHeight()
		local border = 2;

		local y = sh - bottom_margin - 2 * border - hval

		context:SetColor(1,0,0,1)
		context:DrawRect(self.xpos, y, self.width, hval, 0)

		-- border
		y = sh - bottom_margin - 2 * border - hmax
		context:SetColor(Vec4(0,0,0,1))
		context:DrawRect(self.xpos+1, y+1, self.width, hmax, 1)
		context:SetColor(Vec4(1,1,1,1))
		context:DrawRect(self.xpos, y, self.width, hmax, 1)
	
	end
end

---
--- Actions
---

function RedMeter:doSet(args)

	local value = 1
	if args.Power < self.power then value = -1 end
	
	local goal = Math:Round(Math:Clamp(args.Power, 0, self.max) * self.valueSize)
	while self.pixelValue ~= goal do
		self.pixelValue = self.pixelValue  + value
		if EventManager.useCoRoutines then coroutine.yield() end
	end
	self.power = args.Power
end