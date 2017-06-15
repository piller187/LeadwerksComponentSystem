---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if RedPower ~= nil then return end
RedPower = {}

---
--- Public
---
RedPower.name = "RedPower"

function RedPower:init()
	local obj = {}
	self.__index = self

	self.onPicked = EventManager:create()
	
	for k, v in pairs(RedPower) do
		obj[k] = v
	end
	return obj
end

function RedPower:attach(entity)
	self.entity = entity
	self.power = 2
end

---
--- Actions
---
function RedPower:doPicked(msg)
	msg.Power = self.power
	msg.Source.script.gameobject:ReceiveMessage(msg)
	self.entity:Hide()
end

---
--- Private
---