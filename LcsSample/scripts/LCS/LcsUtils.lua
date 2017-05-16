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

--[[
	Function: strToBool(s)
	
	Convert a string to a bool 
	
	"true" -> true
	"false" -> false
	"1" -> true
	"0" -> false
	
	Parameters:
	
	s - string to be converted
	
	Returns: 
	 
	Boolean true or false
]]
function strToBool(s)
	if s == "true" or s == "1" then return true 
	else return false end
end

--[[
	Function: strToNumber(s)
	
	Convert a string to a LUA number
	
	Parameters:
	
	s - string to be converted
	
	Returns: 
	 
	A LUA number
]]
function strToNumber(s)
	return tonumber(s)
end
		
--[[
	Function: strToVec2(s)
	
	Convert a string to a Leadwerks Vec2
	
	Parameters:
	
	s - string to be converted
	
	Returns: 
	 
	A Leadwerks Vec2
]]
function strToVec2(s)
	local x, y = string.match(s,"Vec2%((%d*.%d*),(%d*.%d*)%)")
	return Vec2(x,y)
end

--[[
	Function: strToVec3(s)
	
	Convert a string to a Leadwerks Vec3
	
	Parameters:
	
	s - string to be converted
	
	Returns: 
	 
	A Leadwerks Vec3
]]
function strToVec3(s)
	local x, y, z = string.match(s,"Vec3%((%d*.%d*),(%d*.%d*),(%d*.%d*)%)")
	return Vec3(x,y,z)
end

--[[
	Function: strToVec4(s)
	
	Convert a string to a Leadwerks Vec4
	
	Parameters:
	
	s - string to be converted
	
	Returns: 
	 
	A Leadwerks Vec4
]]
function strToVec4(s)
	local x, y, z, w = string.match(s,"Vec4%((%d*.%d*),(%d*.%d*),(%d*.%d*),(%d*.%d*)%)")
	return Vec4(x,y,z,w)
end

--[[
	Function: boolToStr(v)
	
	Convert a boolean to a string
	
	Parameters:
	
	v - boolean to be converted
	
	Returns: 
	 
	"true" or "false"
]]
function boolToStr(v)
	if v then return "true" 
	else return "false" end
end

--[[
	Function: numberToStr(v)
	
	Convert a LUA number to a string
	
	Parameters:
	
	v - number to be converted
	
	Returns: 
	 
	A number string
]]
function numberToStr(v)
	return tostring(v)
end
		
--[[
	Function: vec2ToStr(v)
	
	Convert a Leadwerks Vec2 to a string
	
	Parameters:
	
	v - Vec2 to be converted
	
	Returns: 
	 
	String in format "1.0,2.0"
]]
function vec2ToStr(v)
	return v.x..","..v.y
end

--[[
	Function: vec3ToStr(v)
	
	Convert a Leadwerks Vec3 to a string
	
	Parameters:
	
	v - Vec3 to be converted
	
	Returns: 
	 
	String in format "1.0,2.0,3.0"
]]
function vec3ToStr(v)
	return v.x..","..v.y..","..v.z
end

--[[
	Function: vec4ToStr(v)
	
	Convert a Leadwerks Vec4 to a string
	
	Parameters:
	
	v - Vec4 to be converted
	
	Returns: 
	 
	String in format "1.0,2.0,3.0,4.0"
]]
function vec4ToStr(v)
	return v.x..","..v.y..","..v.z..","..v.w
end

--[[
	Function: jboolToStr(j)
	
	Convert a JSON boolean to a string
	
	Parameters:
	
	j - JSON boolean
	
	Returns: 
	 
	String "true" or "false"
]]
function jboolToStr(j)
	if j == "true" or j ~= "0" then return "true" 
	else return "false" end
end

--[[
	Function: jnumberToStr(j)
	
	Convert a JSON number to a string
	
	Parameters:
	
	j - JSON number
	
	Returns: 
	 
	A number string
]]
function jnumberToStr(j)
	return tostring(j)
end
		
--[[
	Function: jvec2ToStr(j)
	
	Convert a JSON vec2 to a string
	
	Parameters:
	
	j - JSON vec2
	
	Returns: 
	 
	String in format "Vec2(1.0,2.0)"
]]
function jvec2ToStr(j)
	local x, y = string.match(j,"(.*),(.*)")
	return "Vec2("..x..","..y..")"
end

--[[
	Function: jvec3ToStr(j)
	
	Convert a JSON vec3 to a string
	
	Parameters:
	
	j - JSON vec3
	
	Returns: 
	 
	String in format "Vec3(1.0,2.0,3.0)"
]]
function jvec3ToStr(j)
	local x, y, z = string.match(j,"(.*),(.*),(.*)")
	return "Vec3("..x..","..y..","..z..")"
end

--[[
	Function: jvec4ToStr(j)
	
	Convert a JSON vec4 to a string
	
	Parameters:
	
	j - JSON vec4
	
	Returns: 
	 
	String in format "Vec4(1.0,2.0,3.0,4.0)"
]]
function jvec4ToStr(j)
	local x, y, z, w = string.match(j,"(.*),(.*),(.*),(.*)")
	return "Vec4("..x..","..y..","..z..","..w..")"
end

--[[
	Function: jvalueToStr(vtype,val)
	
	Convert a JSON value to a string
	
	Parameters:
	
	vtype - "bool","nil","int","float","vec2","vec3","vec4","string"
	val - JSON value
	
	Returns: 
	 
	Value string
]]
function jvalueToStr(vtype,val)
	if vtype == "bool" then return jboolToStr(val) 
	elseif vtype == "nil" then return "nil"
	elseif vtype == "int" then return jnumberToStr(val)
	elseif vtype == "float" then return jnumberToStr(val)
	elseif vtype == "vec2" then return jvec2ToStr(val)
	elseif vtype == "vec3" then return jvec3ToStr(val)
	elseif vtype == "vec4" then return jvec4ToStr(val)
	elseif vtype == "string" then return "\""..val.."\""
	else return "nil" end
end

--[[
	Function: jvalueToValue(vtype,val)
	
	Convert a JSON value to a Leadwerks value
	
	Parameters:
	
	vtype - "bool","nil","int","float","vec2","vec3","vec4","string"
	val - JSON value
	
	Returns: 
	 
	Value 
]]
function jvalueToValue(vtype,val)
	if vtype == "bool" then return strToBool(jvalueToStr(vtype,val)) 
	elseif vtype == "int" then return strToNumber(jvalueToStr(vtype,val))
	elseif vtype == "nil" then return nil
	elseif vtype == "float" then return strToNumber(jvalueToStr(vtype,val))
	elseif vtype == "vec2" then return strToVec2(jvalueToStr(vtype,val))
	elseif vtype == "vec3" then return strToVec3(jvalueToStr(vtype,val))
	elseif vtype == "vec4" then return strToVec4(jvalueToStr(vtype,val))
	elseif vtype == "string" then return val
	else return nil end
end

--[[
	Function: split(str,delim)
	
	Split a string using a delimiter
	
	Parameters:
	
	str - string to split
	delm - delimiter
	
	Returns: 
	 
	A table of strings
]]
function split(str, delim )
	local result, pat, lastPos = {},"(.-)" .. delim .. "()",1
    for part, pos in string.gfind(str, pat) do
        table.insert(result, part); lastPos = pos
    end
    table.insert(result, string.sub(str, lastPos))
    return result
end