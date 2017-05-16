----------------------------------------------
-- Leadwerks Component System
-- http://leadwerks.com      	
-- - - - - - - - - - - - - - - - - - - - - - -
-- Free to use for all Leadwerks owners
-- and as always we take no responsibility
-- for anything that the usage of this can 
-- cause directly or indirectly. 
-- - - - - - - - - - - - - - - - - - - - - - -
-- Rick & Roland                       	
-----------------------------------------------
import "Scripts/LCS/EventManager.lua"

Script.onCollision = nil
Script.onMessage = nil
Script.gameobject = nil

function Script:ReceiveMessage(msg)
	--self.onReceiveMessage:raise( msg )
	self.gameobject:ReceiveMessage(msg)
end 

function Script:doCollision(msg) -- {Owner:entity, Entity:entity, Distance:number, Pos=Vec3, Normal=Vec3, Speed=number} )
	self.onCollision:raise(msg)
end

function Script:Start()
	self.pickDistance = Vec3(0)
	self.onCollision = EventManager:create()
end

function Script:UpdateWorld()
	for k,v in pairs(self.gameobject.components) do
		if v.update ~= nil then v:update() end
	end
end

function Script:UpdatePhysics()
	for k,v in pairs(self.gameobject.components) do
		if v.updatePhysics ~= nil then v:updatePhysics() end
	end
end

function Script:Overlap(entity)
	for k,v in pairs(self.gameobject.components) do
		if v.updatePhysics ~= nil then v:updatePhysics() end
	end
	return Collision.Collide
end

function Script:Collision(entity, position, normal, speed)
	self.pickDistance = self.entity:GetPosition(true):DistanceToPoint(entity:GetPosition(true))
	self:doCollision( {Owner=self.entity, Entity=entity, Distance=self.pickDistance, Pos=position, Normal=normal, Speed=speed} )
end

function Script:Draw()
	for k,v in pairs(self.gameobject.components) do
		if v.draw ~= nil then v:draw() end
	end
end

function Script:DrawEach(camera)
	for k,v in pairs(self.gameobject.components) do
		if v.drawEach ~= nil then v:drawEach(camera) end
	end
end

function Script:PostRender(context)
	local bm = context:GetBlendMode()
	context:SetBlendMode(Blend.Alpha)
	
	for k,v in pairs(self.gameobject.components) do
		if v.postRender ~= nil then v:postRender(context) end
	end
	
	context:SetBlendMode(bm)
end

function Script:Detach()
	for k,v in pairs(self.gameobject.components) do
		if v.detach ~= nil then v:detach() end
	end
	if self.gameobject.persistent then
		self.gameobject = nil
	end
end