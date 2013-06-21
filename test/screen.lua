-- Screen - functionality for printing grid
-- Screen will not be supported in TrAInsported, because of library function usage
Screen = {}



function Screen.new( width, height, region_width, region_height, region_strings )
	local s = {}
	s.height = height
	s.width = width
	s.region_width = region_width
	s.region_height = region_height


	local filler_factory = Screen._filler_factory_factory( region_width )
	s.region_fillers = Fn.map( filler_factory, region_strings )

	return s
end



function Screen.print( screen )
	local res = ""
	local rx
	local ry
	for y = 1, screen.height * screen.region_height  do
		for x = 1, screen.width * screen.region_width  do
			rx = Screen._region_nr( x , screen.region_width )
			ry = Screen._region_nr( y , screen.region_height )
			dx = Screen._pixel_inside_region( x , screen.region_width )
			dy = Screen._pixel_inside_region( y , screen.region_height )
			local filler_index = Screen._coord_to_index(rx,ry,screen.width)
			local filler = screen.region_fillers[filler_index]
			res = res .. filler( Point.new( dx,dy ) )
			if Screen._is_palce_for_spacing( x , screen.region_width, screen.width ) then
				res = res .. " "
			end
		end
		res = res .. "\n"

		if Screen._is_palce_for_spacing( y , screen.region_height, screen.height ) then
			res = res .. "\n"
		end
	end

	print( res )
end



function Screen._coord_to_index( x, y, row_width )
	return x + (y-1) * row_width
end



function Screen._pixel_inside_region( global_pixel, region_dim_size )
	local tmp = global_pixel % region_dim_size
	if tmp == 0 then
		return region_dim_size
	else
		return tmp
	end
end



function Screen._region_nr( global_pixel, region_dim_size )
	return math.ceil( global_pixel / region_dim_size )
end



function Screen._is_palce_for_spacing( global_pixel, region_dim_size, dim_size )
	local is_last_in_screen = global_pixel == dim_size * region_dim_size
	local is_last_in_region = math.ceil( global_pixel / region_dim_size ) == global_pixel / region_dim_size
	return is_last_in_region and not( is_last_in_screen )
end



function Screen._filler_factory_factory( region_width )
	return function( txt )
		return function( point )
			local character_nr = Screen._coord_to_index( point.x, point.y , region_width )
			if character_nr <= string.len(txt) then
				return string.sub( txt, character_nr, character_nr )
			else
				return "/"
			end
		end
	end
end



Screen._no_dir = "..."



function Screen._railstr( rail )
	local empty_fill = "    "

	if rail == nil then
		return empty_fill .. Screen._no_dir .. empty_fill
			.. Screen._no_dir .. string.enclose( "_ _" ," "," ") .. Screen._no_dir
			.. empty_fill .. Screen._no_dir .. empty_fill
	end

	local fn_dir_screen_str = Screen._raildirs_screen_str( rail.directions )
	local current_point_screen_str = string.enclose(Point.strshort(rail.coordinates) ,"(",")")

	local line1 = empty_fill .. fn_dir_screen_str("N") .. empty_fill
	local line2 = fn_dir_screen_str("W") .. current_point_screen_str .. fn_dir_screen_str("E")
	local line3 = empty_fill .. fn_dir_screen_str("S") .. empty_fill

	return line1 .. line2 .. line3
end



function Screen._raildirs_screen_str( rail_dirs )
	return function( dirstr )
		if( rail_dirs[ dirstr ] ) then
			return Point.strshort( rail_dirs[ dirstr ].next_junction.coordinates )
		else
			return Screen._no_dir
		end
	end
end



function Screen._from_map( map )
	local rail_strings = {}
	for y=1, map.height do
		for x=1, map.width do
			local region_id = Screen._coord_to_index( x, y, map.width )
			rail_strings[ region_id ] = Screen._railstr( map.rails[ Point.new( x, y ) ] )
		end
	end

	return Screen.new( map.width,map.height, 11,3 , rail_strings )
end



function Screen.print_map( map )
	local map_onscreen_representation = Screen._from_map( map )
	Screen.print( map_onscreen_representation )
end



print ".::SCREEN::."
Screen.print_map( a )
