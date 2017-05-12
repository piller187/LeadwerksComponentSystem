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

if JsonValidator ~= nil then return end
JsonValidator = {}

--
-- Public methods
--
function JsonValidator:create()
	local obj = {}
    self.__index = self
	for k, v in pairs(JsonValidator) do
		obj[k] = v
	end
    return obj
end


function JsonValidator:validate( json )
	
	Debug:Assert( json.gameobjects ~= nil,	"'gameojects' are missing" )
	Debug:Assert( #json.gameobjects > 0 ,	"'gameojects' is empty" )
	
	local gameobjects = json.gameobjects 
	for k,v in pairs(gameobjects) do
		self:validate_gameobject(v)
	end
end

function JsonValidator:validate_gameobject( go )

	Debug:Assert( 	go.name ~= nil and
					go.name ~= "",  
					"'name' in a gameobject not defined" )
	
	local name = go.name
	Debug:Assert(	go.persistent ~= nil, "'persistent' is missing in '" .. name .. "'" )
	Debug:Assert( 	go.persistent == "true" or 
					go.persistent == "false" ,
					"'persistent' must be 'true' or 'false' in '" .. name .. "'" )
	
	if go.values ~= nil and #go.values > 0 then
		for k,v in pairs( go.values ) do
			self:validate_value( name, v )
		end
	end

	if go.messages ~= nil and #go.messages > 0 then
		for k,v in pairs( go.messages) do
			self:validate_message( name, v )
		end
	end

	if go.components ~= nil and #go.components > 0 then
		for k,v in pairs( go.components ) do
			self:validate_component( name, v )
		end
	end

	Debug:Assert( 	go.hookups ~= nil and 
					#go.hookups > 0 , 
					"'hookups' must have at least one hookup defined in '" .. name .. "'" )
	
	if go.hookups ~= nil and #go.hookups > 0 then
		for k,v in pairs( go.hookups ) do
			self:validate_hookup( name, v )
		end
	end
end

function JsonValidator:validate_value( name, value )
	Debug:Assert( 	value.name ~= nil and
					value.name ~= "",
					"'name' not defined in '" .. name .. ".values'" )

	Debug:Assert( 	value.value  ~= nil and
					value.value ~= "",
					"'value' not defined in '" .. name .. "." .. value.name .. "'" )
					
	Debug:Assert( 	value.type ~= nil and
					value.type ~= "",
					"'type' not defined in '" .. name .. "." .. value.name .. "'" )
	
	Debug:Assert( 	value.type == "bool" or
					value.type == "int" or 
					value.type == "float" or 
					value.type == "vec2" or 
					value.type == "vec3" or 
					value.type == "vec4" or
					value.type == "string" or
					value.type == "entity",
					"illegal 'type=" .. value.type .. "' in '" .. name .. "." .. value.name .. "'" ..
					"Valid types are 'bool, int, float, vec2, vec3, vec4, string, entity'" )
end
	
function JsonValidator:validate_message( name, message )
	Debug:Assert( 	message.name ~= nil and
					message.name ~= "",
					"'name' not defined in '" .. name .. ".messages'" )

	Debug:Assert( 	message.path ~= nil and
					message.path ~= "",
					"'path' not defined in '" .. name .. "." .. message.name .. "'" )
	
	Debug:Assert(	FileSystem:GetFileSize(message.path) > 0, 
					"'"..message.path.."' not found in " .. name .. "." .. message.name .. "'" )

end

function JsonValidator:validate_component( name, component )
	Debug:Assert( 	component.name ~= nil and
					component.name ~= "",
					"'name' not defined in '" .. name .. ".components'" )

	Debug:Assert( 	component.path ~= nil and
					component.path ~= "",
					"'path' not defined in '" .. name .. "." .. component.name .. "'" )
	
	Debug:Assert(	FileSystem:GetFileSize(component.path) > 0, 
					"'"..component.path.."' not found in " .. name .. "." .. component.name .. "'" )

end

function JsonValidator:validate_hookup( name, hookup )

	Debug:Assert( 	hookup.source_event ~= nil and
					hookup.source_event ~= "",
					"'name' not defined in '" .. name .. ".components'" )

	Debug:Assert( 	hookup.destination_action ~= nil and
					hookup.destination_action ~= "",
					"'name' not defined in '" .. name .. ".components'" )
	
end