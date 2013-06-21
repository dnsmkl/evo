print "imported std.lua"



function table.str(some_table, lvl)
	lvl = lvl or 0 -- default value
	local res = ""

	assert( type(some_table) == "table" , "not a table!")


	local prefix = function( lvl )
		if lvl == 0 then
			return "\n"
		elseif lvl == 1 then
			return "\n\t"
		elseif lvl == 2 then
			return "\n\t\t"
		elseif lvl == 3 then
			return "\n\t\t\t"
		elseif lvl >= 4 then
			return "\n\t\t\t\t"
		end
	end
	local infix = function( lvl , type_name )
		if type_name ~= "table" then
			return "\t"
		else
			return "\t"
		end
	end

	for k, v in pairs(some_table) do
		if type(v) == "table" then
			res = res .. prefix( lvl ) .. table._keystr( k )
			if Point.valid(v) then -- value is point
				res = res .. infix( lvl,"point" ) .. Point.str( v )
			elseif k ~= "parent_map"
				and k ~= "parent_rail"
				and k ~= "next_rail"
				and k ~= "next_junction" then

				res = res .. infix(lvl,"table") .. tostring( v ) ..  table.str(v, lvl + 1)
				if v.coordinates ~= nil then
					res = res .. "\t" .. Point.str( v.coordinates )
				end
			else
				res = res .. infix(lvl,"table") .. tostring( v )
			end
		else
			res = res .. prefix( lvl ) .. table._keystr( k ) .. infix(lvl,"value") .. v
		end
	end

	return res
end

function table._keystr( key )
	if Point.valid( key ) then
		return Point.str( key )
	else
		return key
	end
end

function table.strtest()
	local a = {}
	a.a = {1,2,3}
	print( table.str( a ) )
end







function table.dup( t )
	local new_table = {}
	for k, v in pairs( t ) do
		new_table[ k ] = v
	end
	-- return setmetatable(u, getmetatable(t))
	return new_table
end





if string == nil then string = {} end

function string.enclose(txt, l, r)
	return l..txt..r
end













Set = {}
function Set.new()
	local set = {}
	return set
end

function Set.append( set, new_el )
	set[ new_el ] = true
end

function Set.has_element( set, el )
	return set[ el ] ~= nil
end

function Set.remove( set, el )
	set[ el ] = nil
end

function Set.remove_if( set, fn_predicate )
	for el,_ in pairs( set ) do
		if fn_predicate( el ) then
			set[el] = nil
		end
	end
end

function Set.is_empty( set )
	return next( set ) == nil
end

function Set.as_array( set )
	local new_array = {}
	for k,_ in pairs( set ) do
		table.insert( new_array, k )
	end
	return new_array
end


function Set.test()
	s = Set.new()

	assert( Set.is_empty( s ) )

	Set.append( s, 1 )

	assert( not Set.is_empty( s ) )

	Set.append( s, 2 )
	Set.append( s, 2 )
	Set.append( s, 2 )

	assert( not Set.is_empty( s ) )
	assert( Set.has_element( s, 1 ) )
	assert( Set.has_element( s, 2 ) )
	assert( not Set.has_element( s, -1 ) )
	assert( not Set.has_element( s, true ) )


	Set.remove( s, 1 )
	assert( not Set.has_element( s, 1 ) )
	assert( Set.has_element( s, 2 ) )
	assert( not Set.is_empty( s ) )

	Set.remove( s, 2 )
	assert( not Set.has_element( s, 2 ) )
	assert( Set.is_empty( s ) )


	if G_TEST_CONFIRMATION_MESSAGES then print "Set.test() -- passed" end
end

Set.test()
