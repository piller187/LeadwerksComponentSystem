--
-- User MouseInput
--
-- Left mouse click 	-> Move
-- Leff double click 	-> Jump
--

import "Scripts/LCS/EventManager.lua"

if MouseInput ~= nil then return end
MouseInput = {}

--
-- Public
--
function MouseInput:init()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	
	self.doubleClickTime = 300
	self.clickTimeout = 0

	self.onMove=EventManager:create()
	self.onJump=EventManager:create()

	for k, v in pairs(MouseInput) do
		obj[k] = v
	end
	return obj
end

function MouseInput:attach(entity)
	self.entity = entity
end

function MouseInput:update()

	local now = Time:Millisecs()
	local hit = Window:GetCurrent():MouseHit(1)
	local wasDouble = false
	
	if hit then
		if self.pending then
			if now < self.clickTimeout  then
				wasDouble = true
				self.onJump:raise() 
			else
				self.onMove:raise() 
			end
			self.pending = false
		else
			self.pending = true
			self.clickTimeout = now + (self.doubleClickTime*Time:GetSpeed())
		end	
	end
	
	if 	self.pending
	and now > self.clickTimeout then
		self.pending = false
		self.onMove:raise() 
	end
	
	if 	not self.pending 
	and not wasDouble
	and hit then
		self.onMove:raise() 
	end
end

--
-- Actions
--

--
-- Private
--