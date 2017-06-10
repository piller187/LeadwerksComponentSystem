---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if BlueMeter ~= nil then return end
BlueMeter = {}


---
--- Public
---
BlueMeter.name = "BlueMeter"
function BlueMeter:init()
	local obj = {}
	self.__index = self

	for k, v in pairs(BlueMeter) do
		obj[k] = v
	end
	return obj
end

function BlueMeter:attach(entity)
	self.entity = entity
	self.xpos = 40
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

function BlueMeter:update()
end

function BlueMeter:updatePhysics()
end

function BlueMeter:overlap(entity)
end

function BlueMeter:collision(entity, position, normal, speed)
end

function BlueMeter:draw()
end

function BlueMeter:drawEach(camera)
end

function BlueMeter:postRender(context)
	if not self.disabled then
	
		-- size
		local hmax = Math:Round(self.max * self.valueSize)
		local hval = self.pixelValue

		-- value
		local bottom_margin = 10
		local sh = context:GetHeight()
		local border = 2;

		local y = sh - bottom_margin - 2 * border - hval

		context:SetColor(0,0,1,1)
		context:DrawRect(self.xpos, y, self.width, hval, 0)

		-- border
		y = sh - bottom_margin - 2 * border - hmax
		context:SetColor(Vec4(0,0,0,1))
		context:DrawRect(self.xpos+1, y+1, self.width, hmax, 1)
		context:SetColor(Vec4(1,1,1,1))
		context:DrawRect(self.xpos, y, self.width, hmax, 1)
	
	end
end

function BlueMeter:detach()
end

function BlueMeter:cleanup(context)
end

---
--- Actions
---

function BlueMeter:doSet(args)

	System:Print( "BlueMeter " .. args.Power )
	local value = 1
	if args.Power < self.power then value = -1 end
	
	local goal = Math:Round(Math:Clamp(args.Power, 0, self.max) * self.valueSize)
	while self.pixelValue ~= goal do
		self.pixelValue = self.pixelValue  + value
		coroutine.yield()
	end
	self.power = args.Power
end