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
    require('player')
    platform = world:newRectangleCollider(250,400,300,100, {collision_class = 'Platform'}) --Colliders have body,fixture and shape
    -- 3 types of colliders. Dynamic(moves/falls), static(doens't move), Kinematic(can be moved can only collide with dynamic object)
    platform:setType('static')

    dangerZone = world:newRectangleCollider(0,550,800,50, {collision_class = 'Danger'})
    dangerZone:setType('static') --Remember to set static so that it doesn't fall off screen
end
function love.update(dt)
    world:update(dt)
    playerUpdate(dt)
end
function love.draw()
    world:draw()
    drawPlayer()
end
--Jump
function love.keypressed(key)
    if key == 'up' then -- half the player width, add half player height, player width
        if player.grounded then
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