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

-- strings to leadwerks
function strToBool(s)
	if s == "true" or s ~= "0" then return true 
	else return false end
end

function strToNumber(s)
	return tonumber(s)
end
		
function strToVec2(s)
	local x, y = string.match(s,"(.*),(.*)")
	return Vec2(x,y)
end

function strToVec3(s)
	local x, y, z = string.match(s,"(.*),(.*),(.*)")
	return Vec3(x,y,z)
end

function strToVec4(s)
	local x, y, z, w = string.match(s,"(.*),(.*),(.*),(.*)")
	return Vec4(x,y,z,w)
end

function boolToStr(s)
	if s == "true" or s ~= "0" then return true 
	else return false end
end

-- leadwerks to string
function numberToStr(v)
	return tostring(v)
end
		
function vec2ToStr(v)
	return v.x..","..v.y
end

function vec3ToStr(v)
	return v.x..","..v.y..","..v.z
end

function vec4ToStr(v)
	return v.x..","..v.y..","..v.z..","..v.w
end

-- json value to string
function jboolToStr(j)
	if j == "true" or j ~= "0" then return "true" 
	else return "false" end
end

function jnumberToStr(j)
	return tostring(j)
end
		
function jvec2ToStr(j)
	local x, y = string.match(j,"(.*),(.*)")
	return "Vec2("..x..","..y..")"
end

function jvec3ToStr(j)
	local x, y, z = string.match(j,"(.*),(.*),(.*)")
	return "Vec3("..x..","..y..","..z..")"
end

function jvec4ToStr(j)
	local x, y, z, w = string.match(j,"(.*),(.*),(.*),(.*)")
	return "Vec4("..x..","..y..","..z..","..w..")"
end

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

function jvalueToValue(vtype,val)
	if vtype == "bool" then return strToBool(jvalueToStr(val)) 
	elseif vtype == "int" then return strToNumber(jvalueToStr(val))
	elseif vtype == "nil" then return nil
	elseif vtype == "float" then return strToNumber(jvalueToStr(val))
	elseif vtype == "vec2" then return strToVec2(jvalueToStr(val))
	elseif vtype == "vec3" then return strToVec3(jvalueToStr(val))
	elseif vtype == "vec4" then return strToVec4(jvalueToStr(val))
	elseif vtype == "string" then return val
	else return nil end
end