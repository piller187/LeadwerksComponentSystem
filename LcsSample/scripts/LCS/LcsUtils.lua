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

function strToBool(s)
	if s == "true" or s == "1" then return true 
	else return false end
end

function strToNumber(s)
	return tonumber(s)
end
		
function strToVec2(s)
	local x, y = string.match(s,"Vec2%((%d*.%d*),(%d*.%d*)%)")
	return Vec2(x,y)
end

function strToVec3(s)
	local x, y, z = string.match(s,"Vec3%((%d*.%d*),(%d*.%d*),(%d*.%d*)%)")
	return Vec3(x,y,z)
end

function strToVec4(s)
	local x, y, z, w = string.match(s,"Vec4%((%d*.%d*),(%d*.%d*),(%d*.%d*),(%d*.%d*)%)")
	return Vec4(x,y,z,w)
end

function boolToStr(v)
	if v then return "true" 
	else return "false" end
end

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

function jboolToStr(j)
	if j == "true" or j == "1" then return "true" 
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

function isValidJsonType(type)
	return 	type == "bool"
		or	type == "int"
		or	type == "nil"
		or	type == "float" 
		or	type == "vec2"
		or	type == "vec3"
		or	type == "vec4"
		or	type == "string"
end

function split(str, delim )
	local result, pat, lastPos = {},"(.-)" .. delim .. "()",1
    for part, pos in string.gfind(str, pat) do
        table.insert(result, part); lastPos = pos
    end
    table.insert(result, string.sub(str, lastPos))
    return result
end

function deepCopy( t )

	local result={}
	if type(t)=="table" then
		for k,v in pairs(t) do result[k] = deepCopy(v) end
	elseif t ~= nil then
		result=t
	end
	return result
end

function merge( t1, t2 )
	local result={}
	if t1 ~= nil then for k1,v1 in pairs(t1) do result[k1] = v1 end end
	if t2 ~= nil then for k2,v2 in pairs(t2) do result[k2] = v2 end end
	return result
end

function mergeTo( to, from)
	if to == nil or from == nil then 
		System:Print( debug.traceback() ) 
	end
	if 	to ~= nil 
	and type(to)=="table" then 
		for k,v in pairs(from) do to[k] = v end 
	end
end

function wait(ms)
	local time = Time:GetCurrent()
	while Time:GetCurrent() < time + ms do
		coroutine.yield()
	end
end

function isValidString(param)
	return param ~= nil and param ~= "" 
end