
Map = {}
function Map.new( original_map )
	local m = {}

	m.height = original_map.height
	m.width = original_map.width
	m.rails = map_fn_v_as_k( Rail.new(m), Map._get_rail_points( original_map ) )

	Fn.foreach( m.rails, Rail.calc_directions )
	Fn.foreach( m.rails, Rail.try_set_junction )
	Fn.foreach( m.rails, Rail.calc_nearest_junctions )

	return m
end

function Map.str( m )
	res = "- " .. m.width .. "X" .. m.height .. " -\n"
	for _,rail in pairs( m.rails ) do
		res = res .. Rail.str( rail )
	end
	return res
end


-- conversion from original trainsported map structure
function Map._get_rail_points( original_map )
	local point_array = {}
	for y = 1, original_map.height do
		for x = 1, original_map.width do
			if original_map[x][y] == "C" then
				table.insert( point_array, Point.new( x, y ) )
			end
		end
	end

	return point_array
end
