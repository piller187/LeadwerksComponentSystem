---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Teams ~= nil then return end
Teams = {}

Teams.name = "Teams"

function Teams:init()
	local obj = {}
	self.__index = self

	self.onRedPowerChange = EventManager:create()
	self.onBluePowerChange = EventManager:create()
	
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
	self.init = true
	
end

function Teams:update()
	if self.init then
		self:addPower(0,"blue")
		self:addPower(0,"red" )
		self.init = false
	end
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
	if team == "blue" then 
		self.bluePower = Math:Clamp(self.bluePower+power, 0, self.max)
		self.onBluePowerChange:raise( { Power=self.bluePower } ) 
	elseif team == "red" then
		self.redPower = Math:Clamp(self.redPower+power, 0, self.max)
		self.onRedPowerChange:raise( { Power=self.redPower } ) 
	end
end