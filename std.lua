print "imported std.lua"







function table.print(table, lvl)
     if not type(table) == "table" then
         print("not a table!")
         return
     end
     lvl = lvl or 0
     for k, v in pairs(table) do
         if type(v) == "table" then
             table.print(table, lvl + 1)
         else
             str = ""
             for i = 1,lvl do
                 str = str .. "\t"
             end
             print(str, k, v)
         end
     end
end




function table.copy(t)
  local u = { }
  for k, v in pairs(t) do u[k] = v end
  return setmetatable(u, getmetatable(t))
end
