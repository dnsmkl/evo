print "imported tp_map.lua"

-- require("point.lua")

function printMap(map)
	str = {}
	for j = 1, map.height do
	str[j] = ""
		for i = 1, map.width do
			if map[i][j] then
				str[j] = str[j] .. map[i][j] .. " "
			else
				str[j] = str[j] .. "_  "
			end
		end
	end
	for i = 1, #str do
		print(str[i])
	end
end


function access(m,p)
	return m[p.x][p.y]
end

function is_rail(m,p)
	return access(m,p) == "C"
end

function is_junction(m,p)
	local directions = {up,down,left,right}

	local neibhour_rail_count = 0
	for _,dir in pairs(directions) do
		if access(m,dir(p)) == "C" then
			neibhour_rail_count = neibhour_rail_count + 1
		end
	end

	return neibhour_rail_count > 2
end


function mark_junktions(map)

end




-- function create_point_map(map)
-- 	converted_map = {}
-- 	for y = 1, map.height do
-- 		for x = 1, map.width do
-- 			if map[x][y] then
-- 				table.insert(converted_map, point(x,y), map[x][y])
-- 				if converted_map[point(x,y)] == nil and not(map[x][y] == nil) then
-- 					print "BADD"
-- 				end
-- 			end
-- 		end
-- 	end

-- 	converted_map.height = map.height
-- 	converted_map.width = map.width
-- 	return converted_map
-- end

-- function printMap2(map)
-- 	str = {}
-- 	for j = 1, map.height do
-- 	str[j] = ""
-- 		for i = 1, map.width do
-- 			if map[point(i,j)] then
-- 				str[j] = str[j] .. map[point(i,j)] .. " "
-- 			else
-- 				str[j] = str[j] .. "_  "
-- 			end
-- 		end
-- 	end
-- 	for i = 1, #str do
-- 		print(str[i])
-- 	end
-- end
