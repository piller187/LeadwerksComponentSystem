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

--[[ 
	Class: ENTITY
	
	Template for Script supporting the GameObject
]]

Script.onCollision = nil
Script.onMessage = nil
Script.gameobject = nil

--[[ 
Function: ReceiveMessage(msg)

Called by the LCS eventsystem to raise
an onReceieve event in the attached GameObject

Parameters: 

msg - a table contining the message

Events:

onCollision - when entity collides with somethingh

]]

function Script:ReceiveMessage(msg)
	--self.onReceiveMessage:raise( msg )
	self.gameobject:ReceiveMessage(msg)
end 

--[[ 
Function: doCollision(msg)

Action called by the LCS eventsystem to raise
an onCollison event in the attached GameObject
when the entity collides with something

Parameters: 

msg - a table contining collision information

MessageFormat:

{

	Owner:entity - self entity
	
	Entity:entity - the colliding entity
	
	Distance:number - distance to the collding entity
	
	Pos:Vec3 - position of the collding entity
	
	Normal:Vec3 - normal of the collding entity
	
	Speed:nunber - speed of the collding entity

}
	
]]

function Script:doCollision(msg) -- {Owner:entity, Entity:entity, Distance:number, Pos=Vec3, Normal=Vec3, Speed=number} )
	self.onCollision:raise(msg)
end

--[[ 
Function: Start()

Initializes the onCollison event

]]

function Script:Start()
	self.pickDistance = Vec3(0)
	self.onCollision = EventManager:create()
end

--[[ 
Function: UpdateWorld()

Calls all attached components function 'update()' if 
they have one defined

]]

function Script:UpdateWorld()
	for k,v in pairs(self.gameobject.components) do
		if v.update ~= nil then v:update() end
	end
end

--[[ 
Function: UpdatePhysics()

Calls all attached components function 'updatePhysic()' if 
they have one defined

]]
function Script:UpdatePhysics()
	for k,v in pairs(self.gameobject.components) do
		if v.updatePhysics ~= nil then v:updatePhysics() end
	end
end

--[[ 
Function: Overlap(entity)

Calls all attached components function 'overlap(entity)' if 
they have one defined

]]
function Script:Overlap(entity)
	for k,v in pairs(self.gameobject.components) do
		if v.overlap ~= nil then v:overlap(entity) end
	end
	return Collision.Collide
end

--[[ 
Function: Collision(entity, position, normal, speed)

Calls the 'doCollison' action

]]
function Script:Collision(entity, position, normal, speed)
	self.pickDistance = self.entity:GetPosition(true):DistanceToPoint(entity:GetPosition(true))
	self:doCollision( {Owner=self.entity, Entity=entity, Distance=self.pickDistance, Pos=position, Normal=normal, Speed=speed} )
end

--[[ 
Function: Draw(entity)

Calls all attached components function 'draw()' if 
they have one defined

]]
function Script:Draw()
	for k,v in pairs(self.gameobject.components) do
		if v.draw ~= nil then v:draw() end
	end
end

--[[ 
Function: DrawEach(camera)

Calls all attached components function 'drawEach(camera)' if 
they have one defined

]]
function Script:DrawEach(camera)
	for k,v in pairs(self.gameobject.components) do
		if v.drawEach ~= nil then v:drawEach(camera) end
	end
end

--[[ 
Function: PostRender(context)

Calls all attached components function 'postRender(context)' if 
they have one defined

]]
function Script:PostRender(context)
	local bm = context:GetBlendMode()
	context:SetBlendMode(Blend.Alpha)
	
	for k,v in pairs(self.gameobject.components) do
		if v.postRender ~= nil then v:postRender(context) end
	end
	
	context:SetBlendMode(bm)
end

--[[ 
Function: Detach()

Calls all attached components function 'detach()' if 
they have one defined

]]
function Script:Detach()
	for k,v in pairs(self.gameobject.components) do
		if v.detach ~= nil then v:detach() end
	end
	if self.gameobject.persistent then
		self.gameobject = nil
	end
end