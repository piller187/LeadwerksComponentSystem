---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Hammer~= nil then return end
Hammer = {}

Hammer.name = "Hammer"

---
--- Public
---
function Hammer:init()
	local obj = {}
	self.__index = self

	self.onPicked = EventManager:create()

	for k, v in pairs(Hammer) do
		obj[k] = v
	end
	return obj
end

function Hammer:attach(entity)
	self.entity = entity
end

---
--- Actions
---
function Hammer:doPicked(args)
	args.Source.script.gameobject.onReceiveMessage:raise( { Message="hammer.picked", Force = 10 } )
	self.entity:Hide()
end


---
--- Private
---