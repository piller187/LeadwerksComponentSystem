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
GameObject.onReceiveMessage = nil

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
	
	self.persistent = false
	self.saverot = false
	self.savepos = false
	self.savescale = false
	self.savehidden = false
	
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
		if v.attach ~= nil then 
			v:attach(entity) 
		end
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
	
	local name = self.entity:GetKeyValue("name")
	local script = self.entity.script
	self.name = name
	self.saverot = jvalueToValue("bool", gameobject.saverot)
	self.savepos = jvalueToValue("bool", gameobject.savepos)
	self.savescale = jvalueToValue("bool", gameobject.savescale)
	self.savehidden = jvalueToValue("bool", gameobject.savehidden)
		
	-- write values to entity keyvalues
	if gameobject.values ~= nil and #gameobject.values > 0 then
		for k,v in pairs(gameobject.values) do
			if 	v.name ~= nil and v.name ~= "" 
			and v.value ~= nil and v.value ~= "" 
			and v.type ~= nil and v.type ~= "" then
				self.entity:SetKeyValue( v.name, jvalueToStr(v.type,v.value) )
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
				
				-- create the component file if it doesn't exist
				if FileSystem:GetFileType(comp.path) ~= FileSystem.File then
					compcreator:createComponent( comp.name, gameobject.hookups, comp.values, comp.path )
				end
				
				-- always create !
				import(comp.path)
				local instance =  _G[comp.name]
				Debug:Assert(instance~=nil, "Failed to import " .. comp.name )
				self.components[comp.name] = _G[comp.name]:init()
				if self.components[comp.name].ReceiveMessage ~= nil then
					self.onReceiveMessage:subscribe(self.components[comp.name],self.components[comp.name].ReceiveMessage)
				end
			end
		end
	end
	
	-- hookups
	if 	gameobject.hookups ~= nil 
	and #gameobject.hookups > 0 then 
	
		for k,hooks in pairs(gameobject.hookups) do
			
			if hooks.source == "Controller" then
				local x = 1
			end
			-- get and verify source
			local src = ""
			if 	hooks.source == "self" or 
				hooks.source == "" or 
				hooks.source == nil  then
				src = self
			else
				src = self.components[hooks.source]
			end
			
			-- get and verify destiation
			local dst = ""
			if 	hooks.destination == "self" or
				hooks.destination == "" or 
				hooks.destination == nil then 
				dst = self
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
			
			--System:Print( "@LCS: " ..
			--	src.name .. ".".. ev .. ":subscribe(" .. dst.name ..", " .. dst.name.. "." .. ac ..")")
			
			-- create hooks
			if 	hooks.filter == nil 
			or  hooks.filter == "" then
				if 	hooks.arguments == nil
				or	hooks.arguments == "" then
					src[ev]:subscribe( dst, dst[ac])
				elseif 	hooks.post ~= nil
				and		hooks.post ~= "" then
					src[ev]:subscribe( dst, dst[ac], hooks.arguments, nil, hooks.post )
				else
					src[ev]:subscribe( dst, dst[ac], hooks.arguments, nil, nil )
				end
			else
				if 	hooks.arguments == nil
				or	hooks.arguments == "" then
					src[ev]:subscribe( dst, dst[ac], nil, hooks.filter, nil )
				elseif 	hooks.post ~= nil
				or		hooks.post ~= "" then
					src[ev]:subscribe( dst, dst[ac], hooks.arguments, hooks.filter, nil )
				else
					src[ev]:subscribe( dst, dst[ac], hooks.arguments, hooks.filter, hooks.post )
				end
			end
			
		end
	end

	
	-- persistent flag
	self.persistent = strToBool(gameobject.persistent)
	
	-- PostStart code
	if	gameobject.poststart ~= nil 
	and gameobject.poststart ~= "" then
		-- add PostStart code
		self.postStart = assert(loadstring("return " .. gameobject.poststart ))()
		self:postStart(self)
	end
	
end

--[[
	Function: ReceiveMessage(arg)
	
	Called to raise the onReceiveMessage event

	Parameters:
	
	arg - event arguments
]]
function GameObject:ReceiveMessage(arg)
	if self.onReceiveMessage ~= nil then
		self.onReceiveMessage:raise(arg)
	end
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

function GameObject:doSaveDone()
	for k,v in pairs(self.components) do
		if v.doSaveDone then v:doSaveDone() end
	end
end

function GameObject:doLoadDone()
	for k,v in pairs(self.components) do
		if v.doLoadDone then v:doLoadDone(args) end
	end
end

function GameObject:save(tab,jsonSource)
	tab[self.name] = {}
	local t = tab[self.name]
	
	-- save basic entity stuff
	if self.savepos then 
		local pos = self.entity:GetPosition(true)
		t.pos = { x=pos.x, y=pos.y, z=pos.z }
	end
	
	if self.saverot then 
		local rot = self.entity:GetRotation(true)
		t.rot = { x=rot.x, y=rot.y, z=rot.z}
	end
		
	if self.savescale then 
		local scale = self.entity:GetScale()
		t.scale = {x=scale.x, y=scale.y, z=scale.z}
	end
		
	if self.savehidden then 
		t.hidden = self.entity:Hidden()
	end

	-- save each component values that are marked 'store:true'
	t.components = {}
	local comps = t.components
	for k1,v1 in pairs(self.components) do
		comps[v1.name] = {}
		local comp = comps[v1.name]  
		local jcomp = jsonSource:getComponent(v1.name)
		if jcomp ~= nil and jcomp.values ~= nil then
			for k2,v2 in pairs(jcomp.values) do
				if v2.store ~= nil and v2.store == "true" then
					comp[v2.name] = v1[v2.name]
				end
			end
		end
	end
	
	-- save any optinal component data set by user
	for k,v in pairs(self.components) do
		if v.doSave then v:doSave({Table=t.components[v.name]}) end
	end
end

function GameObject:load(tab,jsonSource)
	local t = tab[self.name]

	-- load basic entity stuff
	if self.savepos and t.pos ~= nil then
		self.entity:SetPosition( t.pos.x, t.pos.y, t.pos.z, true )
	end
	
	if self.saverot and t.rot ~= nil then
		self.entity:SetRotation( t.rot.x, t.rot.y, t.rot.z, true )
	end
	
	if self.savescale and t.scale ~= nil then
		self.entity:SetScale( t.scale.x, t.scale.y, t.scale.z )
	end
	
	if self.savehidden then 
		if t.hidden then self.entity:Hide() 
		else self.entity:Show() end
	end
	
	-- load each component values that are marked 'store:true'
	local comps = t.components
	for k1,v1 in pairs(self.components) do
		if comps[v1.name] ~= nil then 
			if v1.name == "Teams" then
				local x = 1
			end
			local comp = comps[v1.name]  
			local jcomp = jsonSource:getComponent(v1.name)
			if jcomp ~= nil and jcomp.values ~= nil then
				for k2,v2 in pairs(jcomp.values) do
					if v2.store ~= nil and v2.store == "true" then
						v1[v2.name] = comp[v2.name] 
					end
				end
			end
		end
	end
	
	-- load any optinal component data set by user
	for k,v in pairs(self.components) do
		if v.doLoad then v:doLoad({Table=t.components[v.name]}) end
	end
end