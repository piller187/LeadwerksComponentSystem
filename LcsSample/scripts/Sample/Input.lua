--
-- User Input
--
-- Left mouse click 	-> Move
-- Leff double click 	-> Jump
--

import "Scripts/LCS/EventManager.lua"

if Input ~= nil then return end
Input = {}

--
-- Variables
--
Input.doubleClickTime = 300
Input.clickTimeout = 0
Input.entity = nil
--
-- Events
--
Input.onMove = nil
Input.onJump = nil

--
-- Public
--
function Input:create(entity)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	self.entity = entity
	
	self.onMove=EventManager:create()
	self.onJump=EventManager:create()

	for k, v in pairs(Input) do
		obj[k] = v
	end
	return obj
end

function Input:update()

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