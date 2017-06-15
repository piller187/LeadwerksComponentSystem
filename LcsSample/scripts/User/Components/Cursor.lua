---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Cursor ~= nil then return end
Cursor = {}

Cursor.name = "Cursor"

---
--- Public
---

function Cursor:init()
	local obj = {}
	self.__index = self

	for k, v in pairs(Cursor) do
		obj[k] = v
	end
	return obj
end

function Cursor:attach(entity)
	self.entity = entity
	self.cursorImage = "Materials/User/ring512.tex"
	self.moving = false
	self.size = 48
	self.cursor = Texture:Load(self.cursorImage)
	Debug:Assert(self.cursor ~= nil, "Failed to load cursor " .. self.cursorImage )
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

---
--- Actions
---

---
--- Private
---