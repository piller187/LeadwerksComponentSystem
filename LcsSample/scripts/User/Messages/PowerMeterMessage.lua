---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if PowerMeterMessage ~= nil then return end
PowerMeterMessage = {}

---
--- Public
---
function PowerMeterMessage:init()
	local obj = {}
	self.__index = self

	-- create events here 
	self.onGet = EventManager:create()
	self.onSet = EventManager:create()

	for k, v in pairs(PowerMeterMessage) do
		obj[k] = v
	end
	return obj
end

---
--- Actions
---

function PowerMeterMessage:doGet()
	return self.onGet:raise()
end

function PowerMeterMessage:doSet(arg)
	self.onSet:raise(arg)
end