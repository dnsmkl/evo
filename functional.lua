print "imported functional.lua"

function min(table, metric)
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

function chain(fn2,fn1)
	return function(args)
		return(fn1(fn2(args)))
	end
end



------------------------




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
