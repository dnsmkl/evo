
dofile( "../point.lua" )

Rail = {}
function Rail.new( parent_map )
	return function( coordinate_point )
		local r = {}

		r.parent_map = parent_map
		r.coordinates = coordinate_point
		r.rail_type = "Rail" -- Rail, Junction, Deadend
		r.directions = {} -- { Dir.new() } -- list of directions
		r.direction_count = nil

		return r
	end
end


function Rail.str( r )
	return Point.str( r.coordinates )
end



function Rail.calc_directions( r )
	local valid_dirs = Fn.filter( Point.dir_strs,  Dir.valid( r ) )

	r.direction_count = 0
	for _,valid_dir in pairs( valid_dirs ) do
		r.directions[ valid_dir ] = Dir.new( r, valid_dir )
		r.direction_count = r.direction_count + 1
	end

end


function Rail.try_set_junction( r )
	if r.direction_count > 2 then
		r.rail_type = "Junction"
	end
end

function Rail.calc_nearest_junctions( r )
	Fn.foreach( r.directions, Dir.calc_next_junction )
end
