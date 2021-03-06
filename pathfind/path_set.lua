PathSet = {}
function PathSet.new()
	return {}
end

function PathSet.append( pathSet, path )
	pathSet[ path.destination ] = path
end

function PathSet.str( pathSet )
	local res = ""
	local sep = ""
	for _,path in pairs(pathSet) do
		res = res .. sep .. Path.str( path )
		sep = "\n"
	end
	return res
end


function PathSet.has_junction( path_set, rail )
	for _,path in pairs(path_set) do
		if Path.has_junction( path, rail ) then
			return true
		end
	end
	return false
end


function PathSet.test()
	-- print "Path Set test:"
	local p1 = Path.new( _GET_rail( 1,1 ) )
	Path.append( p1 , _GET_dir(1,1,"E") )
	Path.append( p1 , _GET_dir(2,1,"E") )
	Path.append( p1 , _GET_dir(6,1,"S") )

	local p2 = Path.new( _GET_rail( 2,1 ) )
	Path.append( p2 , _GET_dir(2,1,"E") )

	local p3 = Path.new( _GET_rail( 2,1 ) )


	local ps = PathSet.new()
	PathSet.append( ps, p1 )
	PathSet.append( ps, p2 )
	PathSet.append( ps, p3 )
	-- print( PathSet.str( ps ) )
	assert( not PathSet.has_junction( ps, _GET_rail(2,4) )  )
	assert( PathSet.has_junction( ps, _GET_rail(6,3) )  )
end
PathSet.test()
