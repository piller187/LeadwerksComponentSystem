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

function BluePower:update()
end

function BluePower:updatePhysics()
end

function BluePower:overlap(entity)
end

function BluePower:draw()
end

function BluePower:drawEach(camera)
end

function BluePower:postRender(context)
end

function BluePower:detach()
end

---
--- Actions
---
function BluePower:doPicked(msg)
	msg.Source.script.gameobject.onReceiveMessage:raise( {Message="add.blue.power", Power=self.power} )
	self.entity:Hide()
end

---
--- Private
---