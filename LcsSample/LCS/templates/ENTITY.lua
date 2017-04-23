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

function Script:UpdateWorld()
	for k,v in pairs(self.components) do
		if v.update ~= nil then v:update() end
	end
end

function Script:UpdatePhysics()
	for k,v in pairs(self.components) do
		if v.physUpdate ~= nil then v:physUpdate() end
	end
end

function Script:PostRender(context)
	local bm = context:GetBlendMode()
	context:SetBlendMode(Blend.Alpha)
	
	for k,v in pairs(self.components) do
		if v.draw ~= nil then v:draw(context) end
	end
	
	context:SetBlendMode(bm)
end

function Script:Cleanup()
	for k,v in pairs(self.components) do
		if v.destroy ~= nil then v:destroy() end
	end
end

function Script:Collision(entity, position, normal, speed)
	for k,v in pairs(self.components) do
		if v.onCollision ~= nil then v:onCollision(entity, position, normal, speed) end
	end
end