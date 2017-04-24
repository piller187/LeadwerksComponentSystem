--
-- A first person camera
--
import "Scripts/LCS/EventManager.lua"
if FpsCamera ~= nil then return end
FpsCamera = {}

--
-- Variables
--
FpsCamera.rotationSpeed = 2
FpsCamera.mouseDifference = Vec2(0,0)
FpsCamera.currentMousePos = Vec3(0,0)
FpsCamera.camRotation = Vec3(0,0)
FpsCamera.mouseSensitivity = 15
FpsCamera.limitUpDown = Vec2(-60,80)
FpsCamera.camera = nil
FpsCamera.entity = nil

--
-- Events
--
FpsCamera.onTurn = nil

--
-- Public
--
function FpsCamera:create(entity)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	self.entity = entity
	
	self.onTurn=EventManager:create()
	
	self.camera = Camera:Create()
	self.camera:SetFOV(60)
	self.camera:SetRange(0.1, 300)
	self.camera:SetZoom(1.0)
	self.camera:SetPosition(Vec3(0))
	
	for k, v in pairs(FpsCamera) do
		obj[k] = v
	end
	return obj
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