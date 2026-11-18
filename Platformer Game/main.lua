--Alt L to run 
-- love2d.org/wiki
--cloned windfield to make working with physics easier
function love.load()
    -- change window size to match tileset dimensions (same height)
    love.window.setMode(1000,768)
    anim8 = require 'libraries/anim8/anim8'  -- setting up for animations and grabbing the anim8.lua file
    sti = require 'libraries/Simple-Tiled-Implementation/sti' --tiled
    cameraFile = require 'libraries/hump/camera' -- camera

    cam = cameraFile()
    -- Animations need 3 things to work:
    sprites = {} --spritesheet
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')
    sprites.enemySheet = love.graphics.newImage('sprites/enemySheet.png')
    local grid = anim8.newGrid(614,564,sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight()) -- grid to go with sheet. Width and height for the cell then width and height for the whole sheet.
    local enemyGrid = anim8.newGrid(100,79,sprites.enemySheet:getWidth(),sprites.enemySheet:getHeight())
    animations = {}-- the animation itself.
    animations.idle = anim8.newAnimation(grid('1-15',1),0.05)--15 frames of the idle animation
    animations.jump = anim8.newAnimation(grid('1-7',2),0.05) -- jump animation
    animations.run = anim8.newAnimation(grid('1-15',3),0.05) -- run animation
    animations.enemy = anim8.newAnimation(enemyGrid('1-2',1),0.03)
    wf =  require 'libraries/windfield/windfield'
    world = wf.newWorld(0,800, false) -- add the last bit to stop "object sleeping"
    world:setQueryDebugDrawing(true)
    -- how to make collision classes
    world:addCollisionClass('Player'--[[, {ignores = {'Platform'}}]])
    world:addCollisionClass('Platform')
    world:addCollisionClass('Danger')
    require('player')
    require('enemy')
--    dangerZone = world:newRectangleCollider(0,550,800,50, {collision_class = 'Danger'})
--    dangerZone:setType('static') --Remember to set static so that it doesn't fall off screen
    
    platforms = {}

    loadMap()
end
function love.update(dt)
    world:update(dt)
    gameMap:update(dt)
    playerUpdate(dt)
    updateEnemies(dt)

    local px,py = player:getPosition()
    cam:lookAt(px, love.graphics.getHeight()/2)
end
function love.draw()
    cam:attach() --everything after this gets grouped in until detach
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        world:draw() --comment out to make object layer invisible
        drawPlayer()
        drawEnemies()
    cam:detach() -- things not tied to moving with the camera go after detach

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
-- spawning platforms
function spawnPlatform(x,y,w,h)
    -- cut from up top
        local platform = world:newRectangleCollider(x,y,w,h, {collision_class = 'Platform'}) --Colliders have body,fixture and shape
        -- 3 types of colliders. Dynamic(moves/falls), static(doens't move), Kinematic(can be moved can only collide with dynamic object)
        platform:setType('static')
        table.insert(platforms,platform)
end

-- loading map
function loadMap()
    gameMap = sti('maps/level1.lua')
    for i, obj in pairs(gameMap.layers["Platforms"].objects) do
        spawnPlatform(obj.x,obj.y,obj.width,obj.height)
    end
    for i, obj in pairs(gameMap.layers["Enemies"].objects) do
        spawnEnemy(obj.x,obj.y)
    end
end

-- Gotta fix tiles on first platform