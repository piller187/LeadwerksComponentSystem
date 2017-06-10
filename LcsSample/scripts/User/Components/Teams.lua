---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Teams ~= nil then return end
Teams = {}

---
--- Public
---
Teams.name = "Teams"

function Teams:init()
	local obj = {}
	self.__index = self

	self.onPowerChange = EventManager:create()
	self.onAddRedPower = EventManager:create()
	self.onAddBluePower = EventManager:create()
	self.onMaxReached = EventManager:create()
	
	for k, v in pairs(Teams) do
		obj[k] = v
	end
	return obj
end

function Teams:attach(entity)
	self.entity = entity
	
	self.redPower = 0
	self.bluePower = 0
	self.max = 10
	self.first = true
	
end

function Teams:update()
	if self.first then
		self:addPower(0,"blue")
		self:addPower(0,"red" )
		self.first = false
	end
end

function Teams:updatePhysics()
end

function Teams:overlap(entity)
end

function Teams:draw()
end

function Teams:drawEach(camera)
end

function Teams:postRender(context)
end

function Teams:detach()
end

---
--- Actions
---
function Teams:doAddRedPower(args)
	self:addPower(args.Power, "red" )
end

function Teams:doAddBluePower(args)
	self:addPower(args.Power, "blue")
end

---
--- Private
---
function Teams:addPower(power,team)
	System:Print("Teams:addPower(power,team) " .. power .. " " .. self.max)

	local old = 0
	local new = 0
	if team == "blue" then 
		old = self.bluePower
		self.bluePower = Math:Clamp(old+power, 0, self.max)
		new = self.bluePower
		if new == self.max then self.onMaxReached:raise({Message="max.blue.power"})  end
		self.onPowerChange:raise( { Message="set.blue.power", Power=new } ) 
	elseif team == "red" then
		old = self.redPower 
		self.redPower = Math:Clamp(old+power, 0, self.max)
		new = self.redPower 
		if new == self.max then self.onMaxReached:raise({Message="max.red.power"})  end
		self.onPowerChange:raise( { Message="set.red.power", Power=new } ) 
	end
end