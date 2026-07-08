--Alt L to run 
-- love2d.org/wiki
function love.load()
    target = {}
    target.x = 100
    target.y = 100
    target.radius = 50
    score = 0
    timer = 0
    miss = 0
    menu = true
    A = false
    fSize = love.graphics.newFont(40)
    sprites = {}
    sprites.sky = love.graphics.newImage('Sprites/SWSP.png')
    sprites.target = love.graphics.newImage('Sprites/zenny.png')
    sprites.crosshair = love.graphics.newImage('Sprites/crosshairs.png')
    GX = love.graphics.getWidth()
    GY = love.graphics.getHeight()
    love.mouse.setVisible(false)
end
function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end
    if timer < 0 then
        timer = 0
        menu = true
    end
end
function love.draw()
    -- Drawing the background
    love.graphics.draw(sprites.sky,0,0)
    -- Drawing the target
    --love.graphics.setColor(1,0,1)
    --love.graphics.circle("fill",target.x,target.y,target.radius)
    if menu == false then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(sprites.target,target.x-target.radius,target.y-(target.radius-5))
    end
    -- Writing the score
    love.graphics.setColor(0,1,0)
    love.graphics.setFont(fSize)
    love.graphics.print("Score:"..score,5,5)
    -- Misses
    love.graphics.setColor(1,0.5,0)
    love.graphics.print("Misses:"..miss,200,5)
    -- Showing the timer
    if menu == false then -- Not at the menu
        love.graphics.setColor(1,0,0)
        love.graphics.print("Timer:"..math.ceil(timer),550,5)
    end
    if menu == true then -- Only at the menu
        love.graphics.setColor(1,0,0)
        love.graphics.printf("Left click to start",0,GY/2,GX,"center")
    end
    -- Drawing the cursor
    love.graphics.setColor(1,1,1)
    love.graphics.draw(sprites.crosshair,love.mouse.getX()-20,love.mouse.getY()-20)
    
end
function love.mousepressed(x,y,button,istouch,presses)
    local mouseToTarget = distance(x,y,target.x,target.y)
    if button == 1 and menu == false then -- Left click hit
        if mouseToTarget < target.radius then 
            score = score + 1
            move()
        else -- Left click miss
            miss = miss + 1
            score = score - 1
            move()            
        end
    elseif button == 1 and menu == true then -- game not started
        menu = false
        timer = 10
        score = 0
        miss = 0
    elseif button == 2 and menu == false then -- Right click(risky)
        if mouseToTarget < target.radius then
            score = score +2 
            move()
        else
            timer = timer - 1
            miss = miss + 2
            move()
        end
    elseif button == 3 then
        if A == false then
            if math.random(0,9)<9 then
                sprites.sky = love.graphics.newImage('Sprites/Andria.png')
            else
                sprites.sky = love.graphics.newImage('Sprites/FunAndria.png')
            end
            A = true
        else
            sprites.sky = love.graphics.newImage('Sprites/SWSP.png')
            A = false
        end
    end
end
function distance(x1,y1,x2,y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
function move()
    target.x = math.random(target.radius,GX-target.radius)
    target.y = math.random(target.radius,GY-target.radius)
end