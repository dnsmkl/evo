print "imported point.lua"
-- this file defines generic point with two cordinates x and y







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
	return Point.new(train_or_passenger.x,train_or_passenger.y)
end

function get_dest_coords(passenger)
	return Point.new(passenger.destX, passenger.destY)
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










Point = {}
Point.print = function(pt)
	if pt == nil then return nil end
	print( "( x=" .. pt.x .. "; y=" .. pt.y .." )")
end


Point.str = function(pt)
	if pt == nil then return nil end
	return "Point( x=" .. pt.x .. "; y=" .. pt.y .." )"
end

Point.strshort = function(pt)
	if pt == nil then return nil end
	return "" .. pt.x .. ";" .. pt.y
end





function Point.dir_str(dir)
	if dir == up then
		return "up"
	elseif dir == down then
		return "down"
	elseif dir == left then
		return "left"
	elseif dir == right then
		return "right"
	else
		return "NOT_A_DIRECTION"
	end
end



-- Keep cache of all created points
-- To keep referential transparancy of 'Point.new'
Point._cache = {}

Point.new = function(x,y)
	local h = Point._hash(x,y)
	if not(Point._cache[h]) then
		if x == 20 then print "_" end
		Point._cache[h] = {x=x,y=y}
	end
	return Point._cache[h]
end


Point.valid = function(point)
	if type(point) == "table" then
		if point.x and point.y then
			return true
		end
	end

	return false
end

-- It is needed to get unique result for each cordinate pair
-- following implementation is "ok"  ..until cordinates can exceed 100
function Point._hash(x,y)
	return x+y*100
end



function Point.up(p)
	return Point.new(p.x,p.y-1)
end
function Point.down(p)
	return Point.new(p.x,p.y+1)
end
function Point.left(p)
	return Point.new(p.x-1,p.y)
end
function Point.right(p)
	return Point.new(p.x+1,p.y)
end

Point.dir_fns = {}
Point.dir_fns.N = Point.up
Point.dir_fns.S = Point.down
Point.dir_fns.W = Point.left
Point.dir_fns.E = Point.right

Point.dir_strs = {"N","S","W","E"}

function Point.oposite( dirstr )
	if dirstr == "N" then
		return "S"
	elseif dirstr == "S" then
		return "N"
	elseif dirstr == "W" then
		return "E"
	elseif dirstr == "E" then
		return "W"
	else
		error("Point.oposite - invalid argument")
	end
end



-- DEPRECATED FUNCTIONS --
Point.move_directions = {up, down, left, right} -- deprecated - use Point.dir_fn
function up(p)
	return Point.new(p.x,p.y-1)
end
function down(p)
	return Point.new(p.x,p.y+1)
end
function left(p)
	return Point.new(p.x-1,p.y)
end
function right(p)
	return Point.new(p.x+1,p.y)
end





-- TESTS --
function Point.test_point()
	print "test_std start"
	local pointA = Point.new(1,1)
	local pointB = Point.new(5,6)

	print(calc_distance(pointA, pointB))
	local x = calc_distance_curry(pointA)
	print(x(pointB))
	print "test_std end"
end
