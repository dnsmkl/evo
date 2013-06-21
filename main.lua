dofile("evo/std.lua")
dofile("evo/point.lua")
dofile("evo/functional.lua")
dofile("evo/tp_map.lua")
dofile("evo/tp_wrapper.lua")





function on_map_load(map, money)
	g_available_passengers = {}
	-- rememberMap = nil

	buyTrain(3,1)


	local pt_map = create_point_map(map)
	debug_print_loc("on_map_load")


	local tmap = create_typed_rails(pt_map)

	local is_junction = function(k,v)
		return v=="J"
	end

	local junctions = filter(tmap.points, is_junction)

	debug = 1
	if debug == 1 then
		print "DEBUG:Junctions"
		table.print(junctions)
		print "----"
	end
	debug_print_loc("on_map_load")

	for _,v in pairs( possible_moves(tmap.points, Point.new(4,1) ) ) do
		print( Point.dir_str( v ) )
	end

end

function debug_print_loc(function_name)
	print( function_name .. " - LOC used - " .. getNumberOfLines() )
end



function on_junction( train, possibleDirections )
	-- print("ai.chooseDirection: " .. train.x .. ";" .. train.y)
	if train.passenger == nil and train.x == 7 then
		-- print "ai.chooseDirection: train.passenger == nil and train.x == 7"
		return "W"
	elseif train.passenger == nil then
		-- print "ai.chooseDirection: train.passenger == nil"
		return directionToPassanger(train, possibleDirections)
		--return chooseRandom(possibleDirections)
	else
		local res = directionToDestination(train, possibleDirections)
		-- print("ai.chooseDirection: use directionToDestination :" .. res)
		return res
	end
end





-- FIXME: something not correct (watch last passangers)
function directionToPassanger(train, possibleDirections)

	local pass = find_closest_customer()
	if pass == nil then
		return "E"
	end
	local destination_dir = calc_direction(
			Point.new(train.x, train.y)
			,Point.new(pass.x, pass.y)
			)

	local dim, dir, res
	for dim,dir in pairs(destination_dir) do
		if possibleDirections[dir] then
			return dir
		end
	end

	return chooseRandom(possibleDirections)
end

function directionToDestination(train, possibleDirections)
	local destination_dir = calc_direction(
			Point.new(train.x, train.y)
			,Point.new(train.passenger.destX, train.passenger.destY)
			)

	local dim, dir, res
	for dim,dir in pairs(destination_dir) do
		if possibleDirections[dir] then
			return dir
		end
	end

	return chooseRandom(possibleDirections)
end



function on_passangers_found(train, passengers)
	local calc_distance = chain(
		get_dest_coords -- first extract cordinates
		,calc_distance_curry(get_coords(train)) -- then apply distance calcualtion
		)

	local pass = min(passengers, calc_distance)

	g_available_passengers[pass.name] = nil -- customer is not available for pick anymore

	return pass
end


function find_closest_customer()
	local calc_customers_travel_distance =
		function(some_passanger)
			return calc_distance(
				Point.new(some_passanger.x, some_passanger.y)
				,Point.new(some_passanger.destX, some_passanger.destY)
				)
		end

	return min(g_available_passengers, calc_customers_travel_distance)
end





function on_passanger_appeared(name, x, y, destX, destY)
	g_available_passengers[name] = { x=x, y=y, destX=destX, destY=destY }
end



function on_destination_found(train)
	dropPassenger(train)
end


function on_new_train_available()
	buyTrain(1,3)
end












function chooseRandom(possibleDirections)
	 local dirTable = {}
	 if possibleDirections["N"] then
		 table.insert(dirTable, "N")
	 end
	 if possibleDirections["S"] then
		 table.insert(dirTable, "S")
	 end
	 if possibleDirections["E"] then
		 table.insert(dirTable, "E")
	 end
	 if possibleDirections["W"] then
		 table.insert(dirTable, "W")
	 end

	 res = dirTable[random(#dirTable)]
	 --print("random chose " .. res)
	 return res
end







