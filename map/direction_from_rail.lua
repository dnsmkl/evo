
Dir = {}
function Dir.new( rail, dir_str )
	local d = {}

	d.parent_rail = rail
	d.str = dir_str
	d.next_rail = {}
	d.next_junction = {}
	d.dist_junction = nil

	Dir.calc_next_rail( d )

	return d
end


function Dir.str( dir )
	return "(" .. Point.strshort(dir.parent_rail.coordinates) .. ";" .. dir.str .. ")"
end


function Dir.valid( rail)
	return function( dir_str )
		local map_rails = rail.parent_map.rails
		local next_point =  Point.dir_fns[dir_str](rail.coordinates)
		local next_rail = map_rails[ next_point ]

		return next_rail ~= nil
	end
end



function Dir.calc_next_rail( dir )
	dir.next_rail = Dir._get_next_rail( dir.parent_rail )( dir.str )
end

function Dir._get_next_rail( rail )
	return function( dir_str )
		local map_rails = rail.parent_map.rails
		local next_point =  Point.dir_fns[dir_str](rail.coordinates)
		local next_rail = map_rails[ next_point ]

		return next_rail
	end
end


function Dir.calc_next_junction( dir )
	-- walk until we find the next junction

	local current_rail = dir.parent_rail
	local current_dir = dir.str
	local next_rail = dir.next_rail

	dir.dist_junction = 0

	while next_rail.direction_count == 2 do -- until junction or deadend

		current_rail, current_dir, next_rail = Dir._walk_to_next( current_rail, current_dir, next_rail )
		dir.dist_junction = dir.dist_junction  + 1
	end

	dir.dist_junction = dir.dist_junction  + 1
	-- set next_junction field
	if next_rail.direction_count > 2 then
		dir.next_junction = next_rail
	elseif next_rail.direction_count == 1 then
		dir.next_junction = dir.parent_rail
		dir.dist_junction = dir.dist_junction * 2 -- at the moment only half distance was walked
	else
		error("Dir.calc_next_junction:next_rail.direction_count == 2")
	end
end

function Dir.get_distance( dir, target_rail )
	assert( Dir.has_rail( dir, target_rail ) )

	local current_rail = dir.parent_rail
	local current_dir = dir.str
	local next_rail = dir.next_rail

	local result_distance = 0


	while next_rail.direction_count == 2 do -- until junction or deadend
		current_rail, current_dir, next_rail = Dir._walk_to_next( current_rail, current_dir, next_rail )
		result_distance = result_distance  + 1
		if current_rail == target_rail then
			return result_distance
		end
	end

	if next_rail == target_rail then
		return result_distance  + 1
	end

	return result_distance
end

function Dir.has_rail( dir, target_rail )
	local current_rail = dir.parent_rail
	local current_dir = dir.str
	local next_rail = dir.next_rail

	while 1==1 do
		if current_rail == target_rail then
			return true
		end

		if next_rail.direction_count == 1 then
			return next_rail == target_rail
		end

		current_rail, current_dir, next_rail = Dir._walk_to_next( current_rail, current_dir, next_rail )
		if current_rail.direction_count > 2 then
			return false
		end
	end

	return false
end

function Dir._walk_to_next( current_rail, current_dirstr, next_rail )


	local dir_back_to_current = Point.oposite( current_dirstr )

	local not_back = function( dir )
		return dir.str ~= Point.oposite( current_dirstr )
	end

	local tmp = Fn.filter( next_rail.directions, not_back )


	local _,new_current_dir = next( tmp )


	local new_current = next_rail
	local new_current_dir_str = new_current_dir.str
	local new_next_rail = new_current_dir.next_rail

	return new_current, new_current_dir_str, new_next_rail
end


function Dir.test()
	local f21t31 = Dir.get_distance( _GET_dir(2,1,"E"), _GET_rail(3,1) )
	assert( f21t31 == 1, "was:" .. f21t31 )

	local f21t11 = Dir.get_distance( _GET_dir(2,1,"W"), _GET_rail(1,1) )
	assert( f21t11 == 1, "was:" .. f21t11 )

	assert( _GET_dir(2,1,"W").dist_junction == 2 )

	assert( Dir.has_rail( _GET_dir(2,1,"E"), _GET_rail(5,1) ) )
	assert( Dir.has_rail( _GET_dir(2,1,"W"), _GET_rail(1,1) ) )
	assert( not Dir.has_rail( _GET_dir(2,1,"E"), _GET_rail(8,1) ) )
end



-- print( "Dir.valid"
-- 	, Point.str( rail.coordinates )
-- 	, dir_str
-- 	, Point.str( next_point )
-- 	, next_rail ~= nil
-- 	)
