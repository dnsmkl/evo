print "imported tp_wrapper.lua"



-- even - passanger was found
function ai.foundPassengers(train, passengers)
	return on_passangers_found(train, passengers)
end

-- event - junction
function ai.chooseDirection( train, possibleDirections )
	return on_junction( train, possibleDirections )
end

-- event - map loaded
function ai.init(map, money)
	return on_map_load(map, money)
end


-- event - new passenger appeared on the map
function ai.newPassenger(name, x, y, destX, destY)
	return on_passanger_appeared(name, x, y, destX, destY)
end


-- event - destination found
function ai.foundDestination(train)
	return on_destination_found(train)
end


-- event - more money is available to buy train
function ai.enoughMoney()
	return on_new_train_available()
end
