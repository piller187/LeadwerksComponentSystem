---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Cam ~= nil then return end
Cam = {}

---
--- Public
---
function Cam:init()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	self.name = "Cam"
	
	self.mouseDifference = Vec2(0,0)
	self.currentMousePos = Vec3(0,0)
	self.camRotation = Vec3(0,0)
	self.pendingPick = nil
	self.mouseSense = 0
	self.verticalCamLimit = Vec2(0)
	self.camera = nil
	self.entity = nil
	
	self.onPick = EventManager:create()
	self.onTurn = EventManager:create()
	
	for k, v in pairs(Cam) do
		obj[k] = v
	end
	return obj
end

function Cam:attach(entity)
	-- Init entity related things here
	self.entity = entity
	System:Print( "@LCS: attaching " .. self.name .. " to " .. entity.script.gameobject.name )

	self.mouseSense = entity.script.mouseSense
	self.verticalCamLimit = entity.script.verticalCamLimit
	
	-- camera
	self.camera = Camera:Create()
	self.camera:SetFOV(60)
	self.camera:SetRange(0.1, 300)
	self.camera:SetZoom(1.0)

end

function Cam:update()
	-- Rotate 
	local window = Window:GetCurrent()
	local context=Context:GetCurrent()
	
	self.currentMousePos = window:GetMousePosition()
	window:SetMousePosition(Math:Round(context:GetWidth()/2), Math:Round(context:GetHeight()/2))
	self.currentMousePos.x = Math:Round(self.currentMousePos.x)
	self.currentMousePos.y = Math:Round(self.currentMousePos.y)
	
	self.mouseDifference.x = Math:Curve(self.currentMousePos.x - Math:Round(context:GetWidth()/2),
										self.mouseDifference.x,
										2/Time:GetSpeed())
	
	self.mouseDifference.y = Math:Curve(self.currentMousePos.y - Math:Round(context:GetHeight()/2),
										self.mouseDifference.y,
										2/Time:GetSpeed())
	
	self.camRotation.x = Math:Clamp(self.camRotation.x + self.mouseDifference.y / self.mouseSense,
									self.verticalCamLimit.x,
									self.verticalCamLimit.y)
	
	self.camRotation.y = self.camRotation.y + (self.mouseDifference.x / self.mouseSense)
	
	if self.camera:GetRotation().y ~= self.camRotation.y then  
		self.camera:SetRotation(self.camRotation)
		self:doTurn(self.camRotation.y)
	end

	-- entity detected?
	self.pendingPick = nil
	local pick = PickInfo()
	if self.camera:Pick(self.currentMousePos.x ,self.currentMousePos.y,pick, 0.3 , true ) then
		-- skip nameless and non scripted 
		if	pick.entity:GetKeyValue("name") ~= "" 
		or  pick.entity.script ~= nil then
			self.pendingPick = pick.entity
		end
	end
end

function Cam:updatePhysics()
end

function Cam:overlap(entity)
end

function Cam:draw()
end

function Cam:drawEach(camera)
end

function Cam:postRender(context)
end

function Cam:detach()
end

---
--- Actions
---
function Cam:doPick()
	if self.pendingPick ~= nil then
		self.pendingPick.script:doMessage( {Source=self.entity, Message="pick"})
	end
end

function Cam:doTurn(angle)
	self.onTurn:raise(angle)
end

function Cam:doMove(pos)
	self.camera:SetPosition(pos,true)
end


---
--- Private
---