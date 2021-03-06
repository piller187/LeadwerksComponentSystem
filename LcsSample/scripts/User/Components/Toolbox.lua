---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Toolbox ~= nil then return end
Toolbox = {}

---
--- Public
---

Toolbox.name = "Toolbox"

function Toolbox:init()
	local obj = {}
	self.__index = self

	self.entity = nil
	
	for k, v in pairs(Toolbox) do
		obj[k] = v
	end
	return obj
end

function Toolbox:attach(entity)
	self.entity = entity
	self.tools = {}
	self.current = nil
end

function Toolbox:update()
end

function Toolbox:postRender(context)
end

function Toolbox:detach()
end

---
--- Actions
---
function Toolbox:addTool(arg)
end

function Toolbox:getCurrent()
end

function Toolbox:use(toolname)
end


---
--- Private
---