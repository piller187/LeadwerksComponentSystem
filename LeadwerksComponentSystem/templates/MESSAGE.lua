---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if NAME ~= nil then return end
NAME = {}

---
--- Events
---

NAME.onEvent = nil

---
--- Public
---

function NAME:create()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	self.onEvent=EventManager:create()

	for k, v in pairs(NAME) do
		obj[k] = v
	end
	return obj
end

---
--- Actions
---

function NAME:doEvent()
	self.onEvent:raise()
end
