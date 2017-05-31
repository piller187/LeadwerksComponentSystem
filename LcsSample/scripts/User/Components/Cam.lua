---
--- Created by Leadwerks Component System
---

import "Scripts/LCS/EventManager.lua"

if Cam ~= nil then return end
Cam = {}

---
--- Public
---
Cam.name = "Cam"

function Cam:init()
	local obj = {}
	self.__index = self

	
	self.onPick = EventManager:create()
	self.onTurn = EventManager:create()
	
	for k, v in pairs(Cam) do
		obj[k] = v
	end

	return obj
end

function Cam:attach(entity)
	self.entity = entity
	
	self.mouseSense = 15
	self.verticalCamLimit = Vec2(-60,80)
	self.mouseDifference = Vec2(0,0)
	self.currentMousePos = Vec3(0,0)
	self.camRotation = Vec3(0,0)
	self.pendingPick = nil
	
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
		self.onTurn:raise( {Angle=self.camRotation.y} )
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
		self.onPick:raise( 
		{ 	Dest=self.pendingPick, 
			Source=self.entity } )
	end
end

function Cam:doMove(args)
	self.camera:SetPosition(args.Pos,true)
end

function Cam:doTurn(args)
	local rot = self.camera:GetRotation(true)
	rot.y = args.Angle
	self.camera:SetRotation(rot,true)
end

---
--- Private
---