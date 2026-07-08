--Alt+L to run with LOVE
-- love2d.org/wiki
message = 0
message = 5
chicken = 10
output = chicken * message
condition = -25
pickle = 0
if condition > 0 then
    message = 1
elseif condition < 0 then
    message = -1
else
    message = "no conditions met!"
end
while message < 10 do
    message = message + 1
    love.graphics.print(message)
end
for i=0,3,1 do
    pickle = pickle + i
end
function increaseMessage(i) --increase message variable
    message = message + i
    love.graphics.print(message)
end
function double(val) --doubles parameter value
    val = val *2
    return val
end
message = double(12)
chicken = double(message)
love.graphics.print(chicken)
function getHalf(i)
    local var = i
    var = var/2
    return var
end

--tables. variables but for multiple pieces of data. basically array
--testScores = {} -- empty table
--testScores[1] = 95 --index does NOT start at 0 in lua
--testScores[2] = 87
--testScores[3] = 98
testScores = {95,87,98} -- second way of adding values to a table
testScores.subject = "science" -- can add properties to tables.. CAN print. basically giving a table its' own variable
--table.insert(testScores,95) -- Lua function that you can use to insert values to a table. table.insert(tablename,value)
--message = testScores[2]
testScores["math"] = 91 -- can set index as a string rather than just numbers
--message = testScores[1] -- can use both numbers and strings as indexes at the same time
for i,s in ipairs(testScores)do
    message = message+s
end
function love.draw()
    love.graphics.setFont(love.graphics.setNewFont(50))
    --love.graphics.print(output)
    love.graphics.print(message)
end
-- Making a new file to work on the shooting gallery game