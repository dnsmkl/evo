dofile("../std.lua")
dofile("../point.lua")
dofile("../functional.lua")
dofile("../tp_map.lua")
print("\n\n\n\n")
dofile("../map/map.lua")
dofile("../map/rail.lua")
dofile("../map/direction_from_rail.lua")
print("\n\n\n\n")


trp_mock = {}


local transpose_map = function( original_map )
	result = {}
	for i = 1, original_map.width, 1 do
		result[i] = {}

		for j = 1, original_map.height, 1 do
			result[i][j] = original_map[j][i]
		end
	end

	result.width = original_map.width
	result.height = original_map.height

	return result
end








trp_mock.map =
	transpose_map({
		 {"C","C","C","C","C","C","C","C"}
		,{nil,"C",nil,nil,nil,"C",nil,"C"}
		,{nil,"C",nil,"C","C","C",nil,"C"}
		,{"C","C","C","C",nil,"C","C","C"}
		,height = 4
		,width = 8
	})


-- trp_mock.map =
-- 	transpose_map({
-- 		 {"C","C","C","C"}
-- 		,{nil,"C",nil,"C"}
-- 		,{nil,"C",nil,"C"}
-- 		,{"C","C","C","C"}
-- 		,height = 4
-- 		,width = 4
-- 	})

-- trp_mock.map =
-- 	transpose_map({
-- 		 {"C","C","C","C","C"}
-- 		,{nil,"C",nil,"C",nil}
-- 		,height = 2
-- 		,width = 5
-- 	})

-- trp_mock.map =
-- 	transpose_map({
-- 		 {"C","C"}
-- 		,{nil,"C"}
-- 		,height = 2
-- 		,width = 2
-- 	})


print "-- -- -- -- -- -- --\n Original map:"
print_originaly_structured_map( trp_mock.map )

-- print "-- -- -- -- -- -- --\n Rail points:"
-- a = Map.get_rail_points( trp_mock.map )
-- table.print( a )

print "-- -- -- -- -- -- --\n map/map map:"
a = Map.new( trp_mock.map )

-- accessors to the test map
function _GET_dir(x,y,d)
	return a.rails[ Point.new( x, y ) ].directions[ d ] -- "a" is map declared in test_map.lua (for testing purposes)
end

function _GET_rail(x,y)
	return a.rails[ Point.new( x, y ) ] -- "a" is map declared in test_map.lua (for testing purposes)
end

-- print( Map.str( a ) )

-- print( table.str( a ) )

dofile "screen.lua"


dofile "../pathfind/path.lua"
dofile "../pathfind/path_set.lua"
dofile "../pathfind/path_find.lua"


