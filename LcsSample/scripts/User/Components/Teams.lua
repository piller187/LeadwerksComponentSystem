---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Teams ~= nil then return end
Teams = {}

---
--- Public
---

function Teams:init()
	local obj = {}
	self.__index = self

	-- Init non-entity related things here
	self.Team = { red = 1, blue = 2 }
	
	self.name = "Teams"
	self.entity = nil
	self.max = 0
	self.power = {}

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
	-- Init entity related things here
	self.entity = entity
	self.max = entity.script.maxPower
	self.power[self.Team.red] = 0
	self.power[self.Team.blue] = 0
end

function Teams:update()
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
function Teams:doAddRedPower(arg)
	self:addPower(arg.Power,self.Team.red)
end

function Teams:doAddBluePower(arg)
	self:addPower(arg.Power,self.Team.blue)
end

---
--- Private
---

function Teams:addPower(power,team)
	local old = self.power[team] 
	self.power[team] = Math:Clamp(old+power,0,self.max)
	local new = self.power[team]
	
	if new == self.max then
		if team == self.Team.red then self.onMaxReached:raise("red") 
		else self.onMaxReached:raise("blue") end 
	end
	
	if new ~= old then 
		if team == self.Team.red then
			self.onPowerChange:raise( { Message="set.red.power", Power=new } )
		else
			self.onPowerChange:raise( { Message="set.blue.power", Power=new } )
		end
	end
end