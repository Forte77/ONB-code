--Alt L to run 
-- love2d.org/wiki
--cloned windfield to make working with physics easier
function love.load()
    anim8 = require 'libraries/anim8/anim8'  -- setting up for animations and grabbing the anim8.lua file
    -- Animations need 3 things to work:
    sprites = {} --spritesheet
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')
    local grid = anim8.newGrid(614,564,sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight()) -- grid to go with sheet. Width and height for the cell then width and height for the whole sheet.
    animations = {}-- the animation itself.
    animations.idle = anim8.newAnimation(grid('1-15',1),0.05)--15 frames of the idle animation
    animations.jump = anim8.newAnimation(grid('1-7',2),0.05) -- jump animation
    animations.run = anim8.newAnimation(grid('1-15',3),0.05) -- run animation
    wf =  require 'libraries/windfield/windfield'
    world = wf.newWorld(0,800, false) -- add the last bit to stop "object sleeping"
    world:setQueryDebugDrawing(true)
    -- how to make collision classes
    world:addCollisionClass('Player'--[[, {ignores = {'Platform'}}]])
    world:addCollisionClass('Platform')
    world:addCollisionClass('Danger')
    
    -- Collider (windfield) combines physics body fixture and shape to one object. Physics object = collider
    player = world:newRectangleCollider(360,100,40,100, {collision_class = 'Player'}) -- x y w h
    player:setFixedRotation(true)

    player.speed = 240 --Colliders are like tables so we can give them properties
    player.animation = animations.idle
    player.isMoving = false

    platform = world:newRectangleCollider(250,400,300,100, {collision_class = 'Platform'}) --Colliders have body,fixture and shape
    -- 3 types of colliders. Dynamic(moves/falls), static(doens't move), Kinematic(can be moved can only collide with dynamic object)
    platform:setType('static')

    dangerZone = world:newRectangleCollider(0,550,800,50, {collision_class = 'Danger'})
    dangerZone:setType('static') --Remember to set static so that it doesn't fall off screen
end
function love.update(dt)
    world:update(dt)
    --Grab player position for movement
    if player.body then
        player.isMoving = false
        local px, py = player:getPosition()
        if love.keyboard.isDown('right') then --Move Right
            player:setX(px+player.speed*dt)
            player.isMoving = true
        end
        if love.keyboard.isDown('left') then --Move Left
            player:setX(px-player.speed*dt)
            player.isMoving = true
        end

        if player:enter('Danger') then 
            player:destroy()
        end
    end
    if player.isMoving then
        player.animation = animations.run
    else
        player.animation = animations.idle
    end
    player.animation:update(dt)
end
function love.draw()
    world:draw()
    local px,py = player:getPosition() -- get position of player to draw the animation in the right spot.
    player.animation:draw(sprites.playerSheet, px,py,nil,0.25,nil,130,300)
end
--Jump
function love.keypressed(key)
    if key == 'up' then -- half the player width, add half player height, player width
        local colliders = world:queryRectangleArea(player:getX()-20,player:getY()+50,40,2,{'Platform'}) --using querying for colliders. Making a thin rectangle right below player.
        if #colliders > 0 then
            --Body:applyLinearImpulse
            player:applyLinearImpulse(0,-4000)
        end
    end
end
-- open source library for animations. anim8

function love.mousepressed(x,y,button)
    if  button == 1 then 
        local colliders = world:queryCircleArea(x,y,200,{'Platform','Danger'}) -- container that has a list of all colliders in the radius {optional parameters to look for}
        for i,c in ipairs(colliders) do
            c:destroy() --Destroys anything in radius
        end
    end
end