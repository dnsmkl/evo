print "imported functional.lua"



function min( table, metric )
	-- metric must be function::  table[1] -> int
	local current_min_record, current_min_metric
	current_min_metric = 1000 -- large value

	local index, value
	for index, value in pairs(table) do
		current_metric = metric(value)

		if current_metric < current_min_metric then
			current_min_metric = current_metric
			current_min_record = value
		end
	end

	return current_min_record
end


function compose(fn1, fn2)
	return function(args)
		return(fn1(fn2(args)))
	end
end

function chain( fn2, fn1 )
	return function(args)
		return(fn1(fn2(args)))
	end
end





function map_fn( fn, tab )
	local res = {}
	for k,v in pairs( tab ) do
		table.insert( res, k, fn( v ) )
	end
	return res
end


function map_fn_v_as_k( fn, tab )
	local res = {}
	local tmp_fn_res
	for k,v in pairs( tab ) do
		res[v] = fn( v )
	end
	return res
end
------------------------




Fn = {}
function Fn.filter( tab, predicate )
	local new = {}
	local k,v
	for k,v in pairs(tab) do
		if predicate(v) then
			new[k] = v
		end
	end
	return new
end

function Fn.filtera( tab, predicate )
	local new = {}
	local k,v
	for k,v in pairs(tab) do
		if predicate(k,v) then
			new[k] = v
		end
	end
	return new
end

filter = Fn.filtera -- deprecated - use Fn.filtera


function Fn.foreach( tab, fn )
	for _,v in pairs( tab ) do
		fn( v )
	end
end

function Fn.map( fn, tab )
	local res = {}
	for k,v in pairs( tab ) do
		res[k] = fn( v )
	end
	return res
end


function Fn.join( table_of_tables )
	local res = {}
	for _,v1 in pairs( table_of_tables ) do
		for _,v2 in pairs( v1 ) do
			table.insert( res, v2 )
		end
	end
	return res
end


function Fn.map_attr( tab, attr_name )

	local getattr = function( el )
		return el[ attr_name ]
	end
	return Fn.map( getattr, tab )


end

function Fn.children_l2( tab, l1_name, l2_name )
	local res = Set.new()

	for _, dir in pairs(tab[l1_name][l2_name]) do
		Set.append( res, dir )
	end

	return Set.as_array( res )
end

function Fn.children_l3( tab, l1_name, l2_name, l3_name )
	local res = Set.new()

	for _,v in pairs( tab ) do
		for _, dir in pairs(v[l2_name][l3_name]) do
			Set.append( res, dir )
		end
	end

	return Set.as_array( res )
end


function Fn.choose( table, fn_score )
	-- metric must be function::  table[1] -> int
	local best_record, max_score

	for _, v in pairs(table) do
		local score = fn_score(v)

		if max_score == nil or score > max_score then
			max_score = score
			best_record = v
		end
	end

	return best_record
end


function test_functional()
	print "test_functional start"
	local add = function(x)
		return x+1
	end

	local multiply = function(x)
		return x*3
	end

	local c = compose(multiply,add)
	print(c(5) .. " expected result is c(5)=18")

	print "test_functional end"
end
