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

import "Scripts/LCS/LcsUtils.lua"
import "Scripts/LCS/ComponentCreator.lua"
import "Scripts/LCS/MessageCreator.lua"

--[[
	Class: GameObject
	
	The GameObject which attached to the entity script Script.gameobject
]]
local Messages = {}

if GameObject ~= nil then return end
GameObject = {}

--
-- Public methods
--
--[[
	Function: init()
	
	Create and instance of the GameObject. 
]]
function GameObject:init()
	local obj = {}
    self.__index = self
	self.name = ""
	self.components = {}
	self.onReceiveMessage = EventManager:create()
	
	for k, v in pairs(GameObject) do
		obj[k] = v
	end

    return obj
end


--[[
	Function: attach(entity)
	
	Attach the GameObject to an entity as 
	Script.gameobject.
	
	Parameters:
	
	entity - the entity where the gameobject will be attached
]]
function GameObject:attach(entity)
		
	self.entity = entity
	self.name = entity:GetKeyValue("name")
	self.entity.script.gameobject = self

	-- re-attach entity to components
	for k,v in pairs(self.components) do
		if v.attach ~= nil then v:attach(entity) end
	end
end
	
--[[
	Function: build(entity,gameobject)
	
	Builds the GameObject
	
	Parameters:
	
	entity - the entity where the gameobject will be attached
	
	gameobject - A JsonSource table with the gameobject 
	
	See Also:
	
	<JsonSource>
]]
function GameObject:build(entity,gameobject)

	local compcreator = ComponentCreator:create()
	local msgcreator = MessageCreator:create()
	
	self.entity = entity
	self.entity.script.gameobject = self
	
	local entname = self.entity:GetKeyValue("name")
	local script = self.entity.script
	
		
	-- add values
	if gameobject.values ~= nil and #gameobject.values > 0 then

		for k,v in pairs(gameobject.values) do

			if 	v.name ~= nil and v.name ~= "" 
			and v.value ~= nil and v.value ~= "" 
			and v.type ~= nil and v.type ~= "" then

				script[v.name]=jvalueToValue(v.type,v.value)
			end
		end
	end
	
	-- add messages
	if 	gameobject.messages ~= nil 
	and #gameobject.messages >  0 then
		
		for k,v in pairs(gameobject.messages) do

			if 	v.name ~= nil 
			and v.name ~= "" then

				-- create the message file if it doesn't exist
				if FileSystem:GetFileType(v.path) ~= FileSystem.File then
					msgcreator:createComponent( v.name, gameobject.hookups, v.path )
				end
				
				-- needs creation?
				if Messages[v.name] == nil then
					import(v.path)
					Messages[v.name] = _G[v.name]:init()
				end
				-- add to components
				self.components[v.name] = Messages[v.name]
				-- add as member
				script[v.name] = self.components[v.name] 
			end
		end
	end
	
	-- add components
	if gameobject.components ~= nil and #gameobject.components >  0 then
		for k,comp in pairs(gameobject.components) do
			if 	comp.name ~= nil 
			and comp.name ~= "" then
				
				-- create the message file if it doesn't exist
				if FileSystem:GetFileType(comp.path) ~= FileSystem.File then
					compcreator:createComponent( comp.name, gameobject.hookups, comp.path )
				end
				
				-- always create !
				import(comp.path)
				local instance =  _G[comp.name]
				Debug:Assert(instance~=nil, "Failed to import " .. comp.name )
				self.components[comp.name] = _G[comp.name]:init()
				script[comp.name] = self.components[comp.name]
				if script[comp.name].ReceiveMessage ~= nil then
					self.onReceiveMessage:subscribe(script[comp.name],script[comp.name].ReceiveMessage)
				end
			end
		end
	end
	
	-- hookups
	if 	gameobject.hookups ~= nil 
	and #gameobject.hookups > 0 then 
	
		for k,hooks in pairs(gameobject.hookups) do
			
			-- get and verify source
			local src = ""
			if 	hooks.source == "self" or 
				hooks.source == "" or 
				hooks.source == nil  then
				src = self.entity.script.gameobject
			else
				src = self.components[hooks.source]
			end
			
			-- get and verify destiation
			local dst = ""
			if 	hooks.destination == "self" or
				hooks.destination == "" or 
				hooks.destination == nil then 
				dst = self.entity.script.gameobject
			else 
				dst = self.components[hooks.destination] 
			end
			
			-- get and verify events and actions
			local ev = "on"..hooks.source_event
			local ac = ""
			if 	hooks.destination_action ~= "SendMessage"
			and hooks.destination_action ~= "ReceiveMessage" then
				ac = ac .. "do"
			end
			ac = ac..hooks.destination_action
			
			-- create hook
			if 	hooks.func == nil 
			or  hooks.func == "" then
				if 	hooks.arguments == nil
				or	hooks.arguments == "" then
					src[ev]:subscribe( dst, dst[ac])
				else
					src[ev]:subscribe( dst, dst[ac], hooks.arguments )
				end
			else
				if 	hooks.arguments == nil
				or	hooks.arguments == "" then
					src[ev]:subscribe( dst, dst[ac], nil, hooks.func)
				else
					src[ev]:subscribe( dst, dst[ac], hooks.arguments, hooks.func )
				end
			end
			
			local hookstring = 
				"@LCS: [Hook " .. entname .. "] " ..
				hooks.source .. "." .. ev .. ":subscribe(" .. 
				hooks.destination .. "," .. hooks.destination .. "." .. ac 
			if hooks.func ~= nil and hooks.func ~= "" then
				hookstring = hookstring .. "," .. hooks.func 
			end
			hookstring = hookstring .. ")"
			
			System:Print( hookstring )
		end

	end
	
	-- persistent flag
	self.entity.script.gameobject.persistent = strToBool(gameobject.persistent)
	
	-- PostStart code
	if	gameobject.poststart ~= nil 
	and gameobject.poststart ~= "" then
		-- add PostStart code
		script.PostStart = loadstring("return function(self) " .. gameobject.poststart .. " end")()
		script.PostStart(script)
	end
end

GameObject.onReceiveMessage = nil

--[[
	Function: ReceiveMessage(arg)
	
	Called to raise the onReceiveMessage event

	Parameters:
	
	arg - event arguments
]]
function GameObject:ReceiveMessage(arg)
	self.onReceiveMessage:raise(arg)
end


--[[
	Function: SendMessage(arg)
	
	Send a message to an entity

	Parameters:
	
	arg - message argument
	
	Argument:
	
	The argument must be table like this
	{
		Dest
		Source
		Message
	}
	where
	
	Dest - entity that will receive the message
	Source - entity that sent the message
	Message - a text describing the message
	
	Example:
	
	>self:SendMessage( {Dest=pickedEntity, Source=self.entity, Message="pick" })
	
]]
function GameObject:SendMessage(arg) -- arg = {Dest, Source, Message} }
	
	if type(arg.Dest) ~= "table" then
		arg.Dest.script:ReceiveMessage( arg )
	else
		for k,v in pairs(arg.Dest) do 
			v.script:ReceiveMessage( arg )
		end
	end
end