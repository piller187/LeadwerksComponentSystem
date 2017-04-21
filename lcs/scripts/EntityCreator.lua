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

--[[ JSON FORMAT

{
	"game_objects": 
	[
		{
			"name": "<entity name>",
			"key_values": 
			[
				{
					"key": "<key name>",
					"value": "key value"
				}
			],
			"messages": 
			[
				{
					"name": "<message>",
					"path": "<path to message lua file>"
				}
			],
			"components": 
			[
				{
					"name": "<component>",
					"path": "<path to component lua file>"
				}
			],
			"hookups": 
			[
				{
					"source": "<source message or component>",
					"source_event": "<event>",
					"destination": "<destination message or component>",
					"destination_action": "<action function"
				}
			]
		}
	}
]]  

if EntityCreator ~= nil then return end
EntityCreator = {}

--
-- Variables used
--
EntityCreator.jsonTable = {}
EntityCreator.shared = {}

JSON = nil -- GLOBAL JSON

--
-- Public methods
--
-- source:string: path to JSON source file
function EntityCreator:create(source)
	local obj = {}
    setmetatable(obj, self)
    self.__index = self
	
	-- one-time load of the routines
	if JSON == nil then 
		JSON = assert(loadfile "lcs/scripts/JSON.lua")()
	end
	
	self:loadSource(source)
	
	for k, v in pairs(EntityCreator) do
		obj[k] = v
	end

    return obj
end

-- add JSON declarated thing to this entity
function EntityCreator:process(entity)
	local jtab = self:findJsonItem(entity)
	if jtab ~= nil then
		self:processItem(entity,jtab)
	end
end

--
-- Internals
--
function EntityCreator:loadSource(file)
	local stream = FileSystem:ReadFile(file)
	if stream ~= nil then 
		local jstring = stream:ReadString()
		self.jsonTable = JSON:decode(jstring)
	end
end

function EntityCreator:findJsonItem(entity)
	local name = entity:GetKeyValue("name")
	for k,v in pairs(self.jsonTable.game_objects) do
		if v.name == name then
			return v
		end
	end
	return nil
end

function EntityCreator:processItem(entity, jtab)

	-- add template script
	Debug:Assert(jtab.type ~= nil, "'type' is missing in JSON '" .. jtab.name .. "'" )
	if jtab.type == "Component" then
		entity:SetScript( "lcs/templates/ENTITY.lua" )
	elseif jtab.type == "Message" then 
		entity:SetScript( "lcs/templates/MESSAGE.lua" )
	else 
		Debug:Assert( true, "Unknown JSON type '" .. jtab.type .. "'" ) 
	end

	-- key values
	Debug:Assert(jtab.key_values ~= nil, "'key_values' are missing in JSON '" .. jtab.name .. "'" )
	for k,key in pairs(jtab.key_values) do
		entity:SetKeyValue( key.name, key.value )
	end

	local script = entity.script
	Debug:Assert( script ~= nil, "Failed to add script to " .. entity:GetKeyValue("name") )
	
	if script.components == nil then
		script.components = {}
	end
	Debug:Assert( script.components ~= nil, "Failed to add components to script " .. entity:GetKeyValue("name") )
	
	-- messages
	Debug:Assert(jtab.messages ~= nil, "'messages' are missing in JSON '" .. jtab.name .. "' for " .. entity:GetKeyValue("name" ) )
	for k,msg in pairs(jtab.messages) do
		Debug:Assert( msg.name ~= nil and msg.name ~= "", "'name' not defined in JSON messages for " .. entity:GetKeyValue("name" ) )
		Debug:Assert( msg.path ~= nil and msg.path ~= "", "'path' not defined in JSON messages for " .. entity:GetKeyValue("name" ) )
		local name = msg.name
		import(msg.path)
		if self.shared[name] == nil then
			self.shared[name] = _G[name]:create()
		end
		Debug:Assert( self.shared[name] ~= nil , "Failed to create message '" .. name .. "' for " .. entity:GetKeyValue("name" ) )		
		script.components[name] = self.shared[name]
	end
	
	-- components
	Debug:Assert(jtab.components ~= nil, "'components' are missing in JSON '" .. jtab.name .. "' for " .. entity:GetKeyValue("name" ) )
	for k,comp in pairs(jtab.components) do
		Debug:Assert( comp.name ~= nil and comp.name ~= "", "'name' not defined in JSON components for " .. entity:GetKeyValue("name" ) )
		Debug:Assert( comp.path ~= nil and comp.path ~= "", "'path' not defined in JSON components for " .. entity:GetKeyValue("name" ) )
		import(comp.path)
		script.components[comp.name] = _G[comp.name]:create(entity)
		Debug:Assert(script.components[comp.name] ~= nil , "Failed to create component '" .. comp.name .. "'" )		
	end
	
	-- debug 
	for k,v in pairs(entity.script.components) do
		if v == nil then 
			System:Print( k )
		end
	end
	
	-- hookups
	Debug:Assert(jtab.hookups ~= nil, "'hookups' are missing in JSON '" .. jtab.name .. "' for " .. entity:GetKeyValue("name" ) ) 
	for k,hooks in pairs(jtab.hookups) do
			Debug:Assert( hooks.source ~= nil and hooks.source ~= "", "'source' not defined in JSON hookups for " .. entity:GetKeyValue("name" ) )
			Debug:Assert( hooks.destination ~= nil and hooks.destination ~= "", "'destination' not defined in JSON hookups for " .. entity:GetKeyValue("name" ) )
			Debug:Assert( hooks.source_event ~= nil and hooks.source_event ~= "", "'source_event' not defined in JSON hookups for " .. entity:GetKeyValue("name" ) )
			Debug:Assert( hooks.destination_action ~= nil and hooks.destination_action ~= "", "'destination_action' not defined in JSON hookups for " .. entity:GetKeyValue("name" ) )
			
			local src = nil
			if hooks.source == "self" then
				src = entity.script
			else
				src = script.components[hooks.source]
			end
			Debug:Assert( src ~= nil, hooks.source .. " is missing as source hookup for " .. entity:GetKeyValue("name" ) )
			
			local dst = nil
			if hooks.destination == "self" then
				dst = entity.script
			else 
				dst = script.components[hooks.destination]
			end
			Debug:Assert( dst ~= nil, hooks.destination .. " is missing as destination hookup for " .. entity:GetKeyValue("name" ) )

			src[hooks.source_event]:subscribe( dst, dst[hooks.destination_action])
	end
end