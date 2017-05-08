---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if RedPower ~= nil then return end
RedPower = {}

---
--- Public
---


function RedPower:init()
	local obj = {}
	self.__index = self

	-- Init non-entity related things here
	self.name = "RedPower"

	self.entity = nil
	self.power = 0
	
	for k, v in pairs(RedPower) do
		obj[k] = v
	end
	return obj
end

function RedPower:attach(entity)
	-- Init entity related things here
	self.entity = entity
	self.power = entity.script.power

end

function RedPower:update()
end

function RedPower:updatePhysics()
end

function RedPower:overlap(entity)
end

function RedPower:draw()
end

function RedPower:drawEach(camera)
end

function RedPower:postRender(context)
end

function RedPower:detach()
end

---
--- Actions
---
function RedPower:doMessage(msg)
	System:Print("@LCS: RedPower sends 'add.red.power'")
	msg.Source.script.gameobject.onMessage:raise( {
		Source=self.entity,
		Message="add.red.power",
		Power=self.power } )
	self.entity:Hide()
end

---
--- Private
---