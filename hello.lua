
local boringBool = true
if boringBool then
    GlobA=15.0  -- Notice that when we mouse over this, it is actually a global variable! Will be demonstrated below
    local locB = 66
    boringBool=false
    MyFun = function() print(GlobA + "5") end --also has global scope
end
print(boringBool) -- Declared locally outside the if/then, will retain the reassignment to false that happened inside if/then
print("Hello world" , GlobA)-- Since declared globally, is still available outside if/then's scope
print("Oops, this won't work!", locB) -- locB is nil because we specifically declared it local.
MyFun() -- prints "20.0" 

