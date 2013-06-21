print "imported tp_map.lua"

-- require("point.lua")


function print_originaly_structured_map(map)
	str = {}
	for j = 1, map.height do
	str[j] = ""
		for i = 1, map.width do
			if map[i][j] then
				str[j] = str[j] .. map[i][j] .. " "
			else
				str[j] = str[j] .. "_ "
			end
		end
	end
	for i = 1, #str do
		print(str[i])
	end
end



-- map with Point used as key.
function create_point_map(original_map)
	local pt_map = {}
	for y = 1, original_map.height do
		for x = 1, original_map.width do
			if original_map[x][y] then
				pt_map[Point.new(x,y)] = original_map[x][y]
			end
		end
	end
	pt_map.height = original_map.height
	pt_map.width = original_map.width
	return pt_map
end



function print_point_map(map)
	-- build formated result
	str = {}
	for j = 1, map.height do
	str[j] = ""
		for i = 1, map.width do
			local pt = Point.new(i,j)
			str[j] = str[j] .. point_type(map,pt) .. " "
		end
	end

	-- actualy print
	for i = 1, #str do
		print(str[i])
	end
end

function print_typed_map(map)
	-- build formated result
	str = {}
	for j = 1, map.height do
	str[j] = ""
		for i = 1, map.width do
			local pt = map.points[Point.new(i,j)]
			if pt then
				str[j] = str[j] .. pt .. " "
			else
				str[j] = str[j] .. "_ "
			end
		end
	end

	-- actualy print
	for i = 1, #str do
		print(str[i])
	end
end



function point_type(m,p)
	if not m[p] then
		return "_ "
	end

	local neibhour_rail_count = 0
	for _,dir in pairs(Point.move_directions) do
		if m[dir(p)] == "C" then
			neibhour_rail_count = neibhour_rail_count + 1
		end
	end

	-- not rail
	if m[p] and m[p] ~= "C" then
		return m[p]
	end

	-- rail
	if neibhour_rail_count > 2 then
		return "J" -- junction
	elseif neibhour_rail_count == 2 then
		return "C" -- normal rail
	elseif neibhour_rail_count == 1 then
		return "D" -- dead end
	else
		return m[p]
	end

	return "PLACEHOLDER" -- this would mean an error
end

function possible_moves(m,p)
	if not m[p] then
		return "_ "
	end

	local neibhour_rail_count = 0
	local possible_directions = {}
	for _,dir in pairs(Point.move_directions) do
		if m[dir(p)] == "C" then
			neibhour_rail_count = neibhour_rail_count + 1
			table.insert( possible_directions, dir )
		end
	end
	return possible_directions
end


function create_typed_rails(point_map)
	local better_map = {}
	better_map.points = {}
	local point
	for point,_ in pairs(point_map) do
		if Point.valid(point) then
			better_map.points[point] = point_type(point_map,point)
		end
	end
	better_map.width = point_map.width
	better_map.height = point_map.height

	return better_map
end
