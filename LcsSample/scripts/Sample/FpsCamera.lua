--
-- A first person camera
--
import "Scripts/LCS/EventManager.lua"
if FpsCamera ~= nil then return end
FpsCamera = {}

--
-- Public
--
function FpsCamera:init()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	self.rotationSpeed = 2
	self.mouseDifference = Vec2(0,0)
	self.currentMousePos = Vec3(0,0)
	self.camRotation = Vec3(0,0)
	self.mouseSensitivity = 15
	self.limitUpDown = Vec2(-60,80)
	
	self.onTurn=EventManager:create()
	
	for k, v in pairs(FpsCamera) do
		obj[k] = v
	end
	return obj
end

function FpsCamera:attach(entity)
	self.entity = entity
	self.camera = Camera:Create()
	self.camera:SetFOV(60)
	self.camera:SetRange(0.1, 300)
	self.camera:SetZoom(1.0)
	self.camera:SetPosition(Vec3(0))
end

function FpsCamera:update()
	local window = Window:GetCurrent()
	local context=Context:GetCurrent()
	local cw = Math:Round(context:GetWidth()/2)
	local ch = Math:Round(context:GetHeight()/2)
	
	self.currentMousePos = window:GetMousePosition()
	window:SetMousePosition( cw, ch )
	
	self.currentMousePos.x = Math:Round(self.currentMousePos.x)
	self.currentMousePos.y = Math:Round(self.currentMousePos.y)
	
	self.mouseDifference.x = Math:Curve(self.currentMousePos.x-cw, self.mouseDifference.x, self.rotationSpeed/Time:GetSpeed())
	
	self.mouseDifference.y = Math:Curve(self.currentMousePos.y-ch, self.mouseDifference.y, self.rotationSpeed/Time:GetSpeed())
	
	self.camRotation.x = Math:Clamp(self.camRotation.x + self.mouseDifference.y / self.mouseSensitivity,
									self.limitUpDown.x, self.limitUpDown.y)
	
	self.camRotation.y = self.camRotation.y + (self.mouseDifference.x / self.mouseSensitivity)

	-- send only if rotation really changed
	if self.camera:GetRotation().y ~= self.camRotation.y then  
		self.camera:SetRotation(self.camRotation)
		self.onTurn:raise(self.camRotation.y) -- EVENT
	end
end

function FpsCamera:cleanup()
	self.camera:Release()
	self.camera = nil
end

--
-- Actions
--
function FpsCamera:doMove(newPosition)
	self.camera:SetPosition(newPosition,true)
end

--
-- Private
--