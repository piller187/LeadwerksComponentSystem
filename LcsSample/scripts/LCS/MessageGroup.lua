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
import "Scripts/LCS/JsonSource.lua"
import "Scripts/LCS/GameObject.lua"

if MessageGroup ~= nil then return end
MessageGroup = {}
MessageGroup.messagegroup = true

function MessageGroup:create(name)
	local obj = {}
	self.__index = self
	
	self.name = name
	self.gameobjects = {}
	self.onReceiveMessage = EventManager:create()
	
	for k, v in pairs(MessageGroup) do
		obj[k] = v
	end
	return obj
end

function MessageGroup:addGameObject(gameobject)
	table.insert(self.gameobjects,gameobject)
	gameobject[self.name] = self
	gameobject.components[self.name] = self
end

function MessageGroup:SendMessage(args)
	System:Print( self.name ..":SendMessage(args)" )
	for k,v in pairs(self.gameobjects) do
		if v.ReceiveMessage then 
			v:ReceiveMessage(args) 
		end
	end
end

function createMessageGroups( jSource, gameobjects ) 
	local jgroups = jSource:getMessageGroups()
	if jgroups == nil then return end
	
	for k1,group in pairs(jgroups) do 
		local  messagegroup = MessageGroup:create( group.name )
		for k2,object in pairs(group.gameobjects) do
			for k3,gameobject in pairs(gameobjects) do
				if gameobject.name == object.name then 
					messagegroup:addGameObject(gameobject)
					break
				end
			end
		end
	end
end