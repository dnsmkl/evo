

PathFind = {}


function PathFind.find( rail_start, rail_finish )
	if rail_finish.direction_count > 2 then
		return PathFind.junction_find( rail_start, rail_finish )
	else
		local mini_open_set = Set.new()
		for _,dir in pairs(rail_finish.directions) do

			local junction = dir.next_junction
			local till_junction = PathFind.junction_find( rail_start, junction )

			local corresponds_to_final_rail = function(dir)
				for _,d in pairs(rail_finish.directions) do
					if d.next_junction == dir.next_junction
						and Dir.has_rail( dir, rail_finish ) then
						return true
					end
				end
				return false
			end
			local good_dir = Fn.filter(junction.directions, corresponds_to_final_rail)
			assert( #good_dir == 0 )
			_,good_dir = next(good_dir)

			Path.append( till_junction, good_dir )

			Path.set_early_finish( till_junction, rail_finish )
			Set.append( mini_open_set, till_junction )
		end

		local fn_shortest_distance = function( path ) return ( -path.distance ) end -- smaller distance results in higher score
		return Fn.choose( Set.as_array( mini_open_set ), fn_shortest_distance )
	end
end

function PathFind.junction_find( rail_start, rail_finish )
	-- Find junction path from any rail to some junction
	-- print( "PathFind.junction_find" ) print( "From", Rail.str(rail_start), "to", Rail.str(rail_finish), "\n\n" )
	assert( rail_finish.direction_count > 2, "ERROR: PathFind.junction_find - 2nd argument expected to be junction" )
	local open_set = Set.new() -- 1 element per path (can be many per destination)
	local closed_set = PathSet.new() -- 1 element per destination


	newest_addition = Path.new( rail_start )

	PathSet.append( closed_set, newest_addition )

	-- while rail_finish ~= newest_addition.destination		and newest_addition ~= nil do
	while newest_addition ~= nil do
		if rail_finish == newest_addition.destination then
			return newest_addition
		end
		PathFind._append_open_set( open_set, closed_set, newest_addition )
		-- print( "open_set1:" ) 		for k,_ in pairs(open_set) do 				print( Path.str( k ) )			end

		newest_addition = PathFind._select_shortest_path( open_set )
		-- print( "newest_addition:" )		print( Path.str( newest_addition ) )

		PathFind._move_from_open_to_closed( open_set, closed_set, newest_addition )
		-- print( "closed_set:" ) 			print( PathSet.str( closed_set ) )
		-- print ""
	end
end


function PathFind._append_open_set( open_set, closed_set, newest_path_in_closed_set )
	-- From all possible new directions take only "new" (destination not covered by closed_set )
	-- path -> destination -> directions
	local dir_junction_not_in_path_set = function( dir )
		return not PathSet.has_rail( closed_set, dir.next_junction )
	end
	local new_dirs = Fn.filter(
			newest_path_in_closed_set.destination.directions
			, dir_junction_not_in_path_set
		)

	-- Add new path to open set
	for _,dir in pairs( new_dirs ) do
		local new_path = Path.dup( closed_set[ dir.parent_rail ] )
		Path.append( new_path, dir )
		Set.append( open_set, new_path )
	end
end

function PathFind._select_shortest_path( open_set )
	-- From open_set choose shortest path
	local fn_shortest_distance = function( path ) return ( -path.distance ) end -- smaller distance results in higher score
	return Fn.choose( Set.as_array( open_set ), fn_shortest_distance )
end

function PathFind._move_from_open_to_closed( open_set, closed_set, iteration_winner_path )
	PathSet.append( closed_set, iteration_winner_path )

	local match_newest_destination = function( path )
		return path.destination == iteration_winner_path.destination
	end
	Set.remove_if( open_set, match_newest_destination )
end



function PathFind.test()
	local rail_21 = _GET_rail(2,1)

	-- test junction_find
	local pfj_same = PathFind.junction_find( rail_21, rail_21 )
	assert( Path.str( pfj_same ) == "|2;1|  : 0" )

	local pfj_next_junction = PathFind.junction_find( rail_21, _GET_rail(6,1) )
	assert( Path.str( pfj_next_junction ) == "|2;1;E|  ->  |6;1|  : 4","shortest path to next junction is incorrect" )

	local pfj_further_junction = PathFind.junction_find( _GET_rail(2,1), _GET_rail(6,3) )
	assert( Path.str( pfj_further_junction ) == "|2;1;E|  ->  |6;1;S|  ->  |6;3|  : 6", "was calculated:" .. Path.str( pfj_further_junction ) )

	-- test find
	local pf_same = PathFind.find( rail_21, rail_21 )
	assert( Path.str( pf_same ) == "|2;1|  : 0" )

	local pf_further_junction = PathFind.find( _GET_rail(2,1), _GET_rail(6,3) )
	assert( Path.str( pf_further_junction ) == "|2;1;E|  ->  |6;1;S|  ->  |6;3|  : 6", "was calculated:" .. Path.str( pf_further_junction ) )


	local pf_not_junction = PathFind.find( _GET_rail(2,1), _GET_rail(7,1) )
	assert( Path.str( pf_not_junction ) == "|2;1;E|  ->  |6;1;E|  ->  |7;1|  : 5", "was calculated:" .. Path.str( pf_not_junction ) )

	local pf_deadend = PathFind.find( _GET_rail(7,1), _GET_rail(1,1) )
	assert( Path.str( pf_deadend ) == "|7;1;W|  ->  |6;1;W|  ->  |2;1;W|  ->  |1;1|  : 6", "was calculated:" .. Path.str( pf_deadend ) )
end

PathFind.test()

