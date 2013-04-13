print "imported point.lua"


function point(x,y)
	return {x=x,y=y}
end


function up(p)
	return point(p.x,p.y-1)
end
function down(p)
	return point(p.x,p.y+1)
end

function left(p)
	return point(p.x-1,p.y)
end
function right(p)
	return point(p.x+1,p.y)
end



function calc_distance(src, dst)
	res = sqrt( (src.x - dst.x)^2 + (src.y - dst.y)^2 )
	return res
end

function calc_distance_curry(src)
	return function(dst)
		return calc_distance(src,dst)
	end
end


function get_coords(train_or_passenger)
	return point(train_or_passenger.x,train_or_passenger.y)
end

function get_dest_coords(passenger)
	return point(passenger.destX, passenger.destY)
end






function calc_direction(src, dst)

	if dst.x < src.x then
		h = "W"
	elseif dst.x > src.x then
		h = "E"
	else
		h = "SAME"
	end


	if src.y > dst.y then
		v = "N"
	elseif src.y < dst.y then
		v = "S"
	else
		v = "SAME"
	end

	-- print "calc_direction"
	-- print (h)
	-- print (v)
	return {h=h,v=v}
end






function test_point()
	print "test_std start"
	local pointA = point(1,1)
	local pointB = point(5,6)

	print(calc_distance(pointA, pointB))
	local x = calc_distance_curry(pointA)
	print(x(pointB))
	print "test_std end"
end
