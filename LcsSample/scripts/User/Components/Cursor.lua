---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Cursor ~= nil then return end
Cursor = {}

---
--- Public
---

function Cursor:init()
	local obj = {}
	self.__index = self

	self.name = "Cursor"

	self.size = 48
	self.disabled = true
	self.entity = nil
	self.cursor = nil


	for k, v in pairs(Cursor) do
		obj[k] = v
	end
	return obj
end

function Cursor:attach(entity)
	self.entity = entity
	self.cursor = Texture:Load(entity.script.cursor)
	Debug:Assert(self.cursor ~= nil, "Failed to load cursor " .. entity.script.cursor )
end

function Cursor:update()
end

function Cursor:updatePhysics()
end

function Cursor:overlap(entity)
end

function Cursor:collision(entity, position, normal, speed)
end

function Cursor:draw()
end

function Cursor:drawEach(camera)
end

function Cursor:postRender(context)
	local color = context:GetColor()
	context:SetColor(Vec4(1,1,1,1))
	context:DrawImage(self.cursor, 
				context:GetWidth()/2-self.size/2, 
				context:GetHeight()/2-self.size/2, 
				self.size, self.size)
	context:SetColor(color)
end

function Cursor:detach()
	if self.cursor ~= nil then
		self.cursor:Release()
		self.cursor = nil
	end
end

function Cursor:cleanup(context)
end

---
--- Actions
---

---
--- Private
---