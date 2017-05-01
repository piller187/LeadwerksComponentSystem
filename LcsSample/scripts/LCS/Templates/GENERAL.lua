---
--- Created by Leadwerks Component System
---

if NAME ~= nil then return end
NAME = {}

---
--- Values
---

NAME.value = 0

---
--- Public
---

function NAME:create()
	local obj = {}
	self.__index = self

	for k, v in pairs(NAME) do
		obj[k] = v
	end
	return obj
end

---
--- Private
---

