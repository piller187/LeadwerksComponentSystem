---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if BluePower ~= nil then return end
BluePower = {}

---
--- Public
---
BluePower.name = "BluePower"


function BluePower:init()
	local obj = {}
	self.__index = self

	self.onPicked = EventManager:create()
	
	for k, v in pairs(BluePower) do
		obj[k] = v
	end
	return obj
end

function BluePower:attach(entity)
	self.entity = entity
	self.power = 2
end

---
--- Actions
---
function BluePower:doPicked(msg)
	msg.Power = self.power
	msg.Source.script.gameobject:ReceiveMessage(msg)
	self.entity:Hide()
end

---
--- Private
---