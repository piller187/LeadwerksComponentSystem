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

local Messages = {}

if GameObject ~= nil then return end
GameObject = {}

GameObject.onMessage = nil

function GameObject:doMessage(arg)
	System:Print( "@LCS: GameObject " .. self.name .. ".onMessage:raise(...)" )
	arg.Source.script.onMessage:raise(arg)
	--self.onMessage:raise(arg)
end

--
-- Public methods
--
function GameObject:init()
	local obj = {}
    self.__index = self
	self.name = ""
	self.components = {}
	self.onMessage = EventManager:create()
	
	for k, v in pairs(GameObject) do
		obj[k] = v
	end

    return obj
end


function GameObject:attach(entity)
		
	self.entity = entity
	self.name = entity:GetKeyValue("name")
	self.entity.script.gameobject = self

	-- re-attach entity to components
	for k,v in pairs(self.components) do
		if v.attach ~= nil then v:attach(entity) end
	end
end
	
function GameObject:build(entity,gameobject)

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
				
				-- always create !
				import(comp.path)
				local instance =  _G[comp.name]
				Debug:Assert(instance~=nil, "Failed to import " .. comp.name )
				self.components[comp.name] = _G[comp.name]:init()
				script[comp.name] = self.components[comp.name]
				if script[comp.name].doMessage ~= nil then
					self.onMessage:subscribe(script[comp.name],script[comp.name].doMessage)
				end
			end
		end
	end
	
	-- hookups
	if 	gameobject.hookups ~= nil 
	and #gameobject.hookups > 0 then 
	
		for k,hooks in pairs(gameobject.hookups) do
			
			-- validate
			Debug:Assert( hooks.source ~= nil and hooks.source ~= "", "'source' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.destination ~= nil and hooks.destination ~= "", "'destination' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.source_event ~= nil and hooks.source_event ~= "", "'source_event' not defined in JSON hookups for " .. entname )
			Debug:Assert( hooks.destination_action ~= nil and hooks.destination_action ~= "", "'destination_action' not defined in JSON hookups for " .. entname )
			
			-- get and verify source
			local src = ""
			if hooks.source == "self" then src = self.entity.script.gameobject
			else src = self.components[hooks.source] end
			
			Debug:Assert( src ~= nil, hooks.source .. " is missing as source hookup for " .. entname )
			
			-- get and verify destiation
			local dst = ""
			if hooks.destination == "self" then dst = self.entity.script.gameobject
			else dst = self.components[hooks.destination] end
			
			Debug:Assert( dst ~= nil, hooks.destination .. " is missing as destination hookup for " .. entname )

			-- get and verify events and actions
			local ev = "on"..hooks.source_event
			local ac = "do"..hooks.destination_action
			Debug:Assert( src[ev] ~= nil,  ev .. " event not found in " .. hooks.source .. " when processing hookups in " .. entname )
			Debug:Assert( dst[ac] ~= nil,  ac .. " action not found in " .. hooks.destination .. " when processing hookups in " .. entname  )
			
			-- create hook
			if 	hooks.func == nil 
			or  hooks.func == "" then
				src[ev]:subscribe( dst, dst[ac])
			else
				src[ev]:subscribe( dst, dst[ac], hooks.func )
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
		script.PostStart = loadstring("return function(self) " .. gameobject.poststart .. " end")(script)
		script.PostStart(script)
	end
end