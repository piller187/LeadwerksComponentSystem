--
-- A simple energy meter
--

import "Scripts/LCS/EventManager.lua"
if EnergyMeter ~= nil then return end
EnergyMeter = {}

--
-- Variables
--
EnergyMeter.addSpeed = 4
EnergyMeter.subtractSpeed = 6
EnergyMeter.entity = nil
EnergyMeter.energy = 50
EnergyMeter.maxEnergy = 100
EnergyMeter.width = 16
EnergyMeter.xpos = 4
EnergyMeter.valueSize = 5

EnergyMeter.autoTime = 3
EnergyMeter.autoTimeout = 0
EnergyMeter.autoval = 0
EnergyMeter.sec = 0
EnergyMeter.zeroSent = false
EnergyMeter.entity = nil

--
-- Events
--
EnergyMeter.onOutOfEnergy = nil
EnergyMeter.onEnergyRecovered = nil

--
-- Public
--
function EnergyMeter:create(entity)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	self.entity = entity
	
	self.onOutOfEnergy=EventManager:create()
	self.onEnergyRecovered=EventManager:create()

	self.autoTimeout = self.autoTime
	self.sec = Time:Millisecs() + 1000	
	
	self:doStartAddingEnergy()
	
	for k, v in pairs(EnergyMeter) do
		obj[k] = v
	end
	return obj
end

function EnergyMeter:update()
	local now = Time:Millisecs()
	if now > self.sec then 
		self.autoTimeout = self.autoTimeout - 1
		if self.autoTimeout <= 0 then
			self.energy = Math:Clamp(self.energy+self.autoval,0,self.maxEnergy)
			if self.energy == 0 and not self.zeroSent then
				self.onOutOfEnergy:raise()
				self.zeroSent = true
			elseif self.energy > 0 and self.zeroSent then
				self.onEnergyRecovered:raise()
				self.zeroSent = false
			end
			self.autoTimeout = self.autoTime
		end
		self.sec = now + 1000
	end
end

function EnergyMeter:physUpdate()
end

function EnergyMeter:draw(context)

	-- size
	local hmax = self.maxEnergy * self.valueSize
	local hval = self.energy *  self.valueSize

	-- value
	local bottom_margin = 10
	local sh = context:GetHeight()
	local border = 2;

	local y = sh - bottom_margin - 2 * border - hval

	local v = self.energy / self.maxEnergy
	context:SetColor(1.0 - v, v, 0.0, 1.0)
	context:DrawRect(self.xpos, y, self.width, hval, 0)

	-- border
	y = sh - bottom_margin - 2 * border - hmax
	context:SetColor(Vec4(0,0,0,1))
	context:DrawRect(self.xpos+1, y+1, self.width, hmax, 1)
	context:SetColor(Vec4(1,1,1,1))
	context:DrawRect(self.xpos, y, self.width, hmax, 1)
	
end


function EnergyMeter:destroy()
end

function EnergyMeter:onCollision(entity, position, normal, speed)
end

--
-- Actions
--
function EnergyMeter:doStartAddingEnergy()
	self.autoval = self.addSpeed 
end

function EnergyMeter:doStartSubtractingEnergy()
	self.autoval = -self.subtractSpeed
end

--
-- Private
--