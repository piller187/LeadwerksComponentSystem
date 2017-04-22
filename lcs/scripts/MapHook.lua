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

import "lcs/scripts/EntityCreator.lua"
local entCreator = EntityCreator:create("lcs/source/test.xml")

--called when map is loaded
function MapHook(entity,obj)
	if 	entity.script ~= nil then
		entCreator:process(entity)
	end
end
