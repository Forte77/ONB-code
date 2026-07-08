--Alt L to run 
-- love2d.org/wiki
--cloned windfield to make working with physics easier
function love.load()
    wf =  require 'libraries/windfield/windfield'
    world = wf.newWorld(0,800, false) -- add the last bit to stop "object sleeping"
    -- how to make collision classes
    world:addCollisionClass('Player'--[[, {ignores = {'Platform'}}]])
    world:addCollisionClass('Platform')
    world:addCollisionClass('Danger')
    
    -- Collider (windfield) combines physics body fixture and shape to one object. Physics object = collider
    player = world:newRectangleCollider(360,100,80,80, {collision_class = 'Player'}) -- x y w h
    player:setFixedRotation(true)
    player.speed = 240 --Colliders are like tables so we can give them properties
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
        local px, py = player:getPosition()
        if love.keyboard.isDown('right') then --Move Right
            player:setX(px+player.speed*dt)
        end
        if love.keyboard.isDown('left') then --Move Left
            player:setX(px-player.speed*dt)
        end

        if player:enter('Danger') then 
            player:destroy()
        end
    end
end
function love.draw()
    world:draw()
end
--Jump
function love.keypressed(key)
    if key == 'up' then
        --Body:applyLinearImpulse
        player:applyLinearImpulse(0,-7000)
    end
end