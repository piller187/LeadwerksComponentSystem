---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if NAME ~= nil then return end
NAME = {}

---
--- Public
---
function NAME:init()
	local obj = {}
	self.__index = self

	-- create events here 
	-- self.onEvent=EventManager:create()

	for k, v in pairs(NAME) do
		obj[k] = v
	end
	return obj
end

---
--- Actions
---

--[[
function NAME:doEvent()
	self.onEvent:raise()
end
]]