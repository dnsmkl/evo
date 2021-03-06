Path = {}

function Path.new( rail )
	-- Path is a list of directions and the final destination --
	--   example: (A,'N') -> (B,'E') -> C ;
	--   which translates to english: From A go North, when you reach B go east till you arive at C
	local p = {}
	p.dirs = {} -- direction list
	p.destination = rail -- juntion to which last_dir points to
	p.distance = 0 -- total distance

	return p
end

function Path.dup( path )
	new_path = {}
	new_path.dirs = table.dup( path.dirs )
	new_path.destination = path.destination
	new_path.distance = path.distance
	return new_path
end

function Path.append( path, dir )
-- print (dir)
	table.insert( path.dirs, dir )
	path.destination = dir.next_junction
	path.distance = path.distance + dir.dist_junction
end

function Path.set_early_finish( path, dest_rail )
	local final_dir = path.dirs[#path.dirs]

	path.distance = path.distance - final_dir.dist_junction -- remove final road till junction
	path.distance = path.distance + Dir.get_distance( final_dir, dest_rail ) -- append only part till dest_rail

	path.destination = dest_rail
end



function Path.str( path )
	local res = ""
	for _,raildir in pairs( path.dirs ) do
		local single_str = "|" .. Point.strshort(raildir.parent_rail.coordinates) .. ";" .. raildir.str .. "|"
		res = res .. single_str .. "  ->  "
	end

	res = res .. "|" .. Point.strshort( path.destination.coordinates ) .. "|  : "  .. path.distance

	return res
end


-- check if path is made of continuous list of junctions (except for the first element of the path)
function Path.is_valid( path )
	local cached_next_junction = nil

	for _,raildir in pairs( path.dirs ) do
		if cached_next_junction ~= nil -- first iteration - don't check anything
			and cached_next_junction ~= raildir.parent_rail then
			return false
		end

		assert( raildir.next_junction, "Path.is_continuous_junction_list: raildir.next_junction==nil" )
		cached_next_junction = raildir.next_junction
	end
	return true
end

function Path.eq( patha, pathb )

	ka,va = next( patha.dirs )
	kb,vb = next( pathb.dirs )

	if patha.destination ~= pathb.destination then return false end

	while not(va == nil and vb == nil) do
		if va ~= vb then
			return false
		end

		ka,va = next( patha.dirs, ka )
		kb,vb = next( pathb.dirs, kb )
	end

	return true
end


function Path.has_junction( path, rail )
	for _,dir in pairs( path.dirs ) do
		if rail == dir.parent_rail then
			return true
		end
	end
	if path.destination == rail then
		return true
	end

	return false
end

function Path.test()
	-- print "Path test:"



	local p1 = Path.new( _GET_rail( 1,1 ) )
	Path.append( p1 , _GET_dir(1,1,"E") )
	Path.append( p1 , _GET_dir(2,1,"E") )
	Path.append( p1 , _GET_dir(6,1,"S") )
	Path.append( p1 , _GET_dir(6,3,"W") )
	-- print (Path.str( p1 ))
	assert( Path.str( p1 ) == "|1;1;E|  ->  |2;1;E|  ->  |6;1;S|  ->  |6;3;W|  ->  |2;4|  : 12" )
	assert( Path.is_valid( p1 ) )

	local p2 = Path.new( _GET_rail( 1,1 ) )
	Path.append( p2 , _GET_dir(1,1,"E") )
	Path.append( p2 , _GET_dir(2,1,"E") )
	Path.append( p2 , _GET_dir(6,1,"S") )
	Path.append( p2 , _GET_dir(6,3,"W") )
	assert( Path.eq( p1, p2 ) )

	local p3 = Path.new( _GET_rail( 2,1 ) )
	Path.append( p3 , _GET_dir(2,1,"E") )
	assert( not Path.eq( p1, p3 ) )


	-- TEST Path.DUP
	local p4 = Path.new( _GET_rail( 2,1 ) )
	Path.append( p4 , _GET_dir(2,1,"E") )
	assert( Path.str( p4 ) == "|2;1;E|  ->  |6;1|  : 4" )


	local p5 = Path.dup( p4 )
	Path.append( p5 , _GET_dir(6,1,"E") )
	assert( Path.str( p4 ) == "|2;1;E|  ->  |6;1|  : 4" )
	assert( Path.str( p5 ) == "|2;1;E|  ->  |6;1;E|  ->  |6;3|  : 12", "result was:" .. Path.str( p5 ) )
	-- TEST Path.has_rail
	assert( Path.has_junction( p5, _GET_rail( 2,1 ) ) )
	assert( Path.has_junction( p5, _GET_rail( 6,1 ) ) )
	assert( not Path.has_junction( p5, _GET_rail( 6,4 ) ) )

	Path.set_early_finish( p5, _GET_rail(8,4) )
	assert( Path.str( p5 ) == "|2;1;E|  ->  |6;1;E|  ->  |8;4|  : 9", "result was:" .. Path.str( p5 ) )

	local p6 = Path.new( _GET_rail(7,1) )
	Path.append( p6, _GET_dir(7,1,"W") )
	Path.append( p6, _GET_dir(6,1,"W") )
	Path.append( p6, _GET_dir(2,1,"W") )
	assert( Path.str(p6) == "|7;1;W|  ->  |6;1;W|  ->  |2;1;W|  ->  |2;1|  : 7", Path.str(p6) )
	Path.set_early_finish( p6, _GET_rail(1,1) )
	-- assert( Path.str(p6) == "|7;1;W|  ->  |6;1;W|  ->  |2;1;W|  ->  |1;1|  : 6", Path.str(p6) )
end
Path.test()
