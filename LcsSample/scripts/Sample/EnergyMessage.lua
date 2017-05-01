import "Scripts/LCS/EventManager.lua"
if EnergyMessage ~= nil then return end
EnergyMessage = {}

function EnergyMessage:init()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	self.onStartAddingEnergy=EventManager:create()
	self.onStartSubtractingEnergy=EventManager:create()
	self.onOutOfEnergy=EventManager:create()
	self.onEnergyRecovered=EventManager:create()

	for k, v in pairs(EnergyMessage) do
		obj[k] = v
	end
	return obj
end

function EnergyMessage:doStartAddingEnergy()
	self.onStartAddingEnergy:raise()
end

function EnergyMessage:doStartSubtractingEnergy()
	self.onStartSubtractingEnergy:raise()
end

function EnergyMessage:doOutOfEnergy()
	self.onOutOfEnergy:raise()
end

function EnergyMessage:doEnergyRecovered()
	self.onEnergyRecovered:raise()
end