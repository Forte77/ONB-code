function love.load()
    sprites = {}
    sprites.background = love.graphics.newImage('sprites/SWSP.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    GX = love.graphics.getWidth()
    GY = love.graphics.getHeight()
    player = {}
    player.x = GX/2
    player.y = GY/2
    player.speed = 180
    zombies = {}
    bullets = {}
    gameState = 2
    maxTime = 2
    timer = maxTime
end
function love.update(dt)
    if love.keyboard.isDown("d") then 
        player.x = player.x + player.speed*dt
    end
    if love.keyboard.isDown("a") then 
        player.x = player.x - player.speed*dt
    end
    if love.keyboard.isDown("w") then 
        player.y = player.y - player.speed*dt
    end
    if love.keyboard.isDown("s") then 
        player.y = player.y + player.speed*dt
    end
    for i,z in ipairs(zombies) do
        z.x = z.x + (math.cos(zombiePlayerAngle(z)) * z.speed * dt)
        z.y = z.y + (math.sin(zombiePlayerAngle(z)) * z.speed * dt)
        if distanceBetween(z.x,z.y,player.x,player.y)<20 then
            for i,z in ipairs(zombies) do
                zombies[i] = nil
                gameState = 1
            end
        end
    end
    for i,b in ipairs(bullets) do
        b.x = b.x + (math.cos(b.direction) * b.speed * dt)
        b.y = b.y + (math.sin(b.direction) * b.speed * dt)
    end
    for i=#bullets,1,-1 do --#table gets the length of the table
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > GX or b.y > GY then
            table.remove(bullets,i)
        end
    end
    for i,z in ipairs(zombies) do
        for j,b in ipairs(bullets) do 
            if distanceBetween(z.x,z.y,b.x,b.y) < 20 then
                b.dead = true
                z.dead = true
            end
        end
    end
    for i=#zombies,1,-1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies,i)
        end
    end
    for i=#bullets,1,-1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets,i)
        end
    end
    if gameState == 2 then
        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            maxTime = 0.95 * maxTime
            timer = maxTime
        end
    end
end
function love.draw()
    love.graphics.draw(sprites.background,0,0)
    love.graphics.draw(sprites.player,player.x,player.y,playerMouseAngle(),nil,nil,sprites.player:getWidth()/2,sprites.player:getHeight()/2)
    for i,z in ipairs(zombies) do 
        love.graphics.draw(sprites.zombie,z.x,z.y,zombiePlayerAngle(z),nil,nil,sprites.zombie:getWidth()/2,sprites.player:getHeight()/2)
    end
    for i,b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet,b.x,b.y,nil,0.5,0.5,sprites.bullet:getWidth()/2,sprites.bullet:getHeight()/2)
    end
end
function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end
function love.mousepressed(x,y,button)
    if button == 1 then
        spawnBullet()
    end
end
function playerMouseAngle()
    return math.atan2(love.mouse.getY() - player.y,love.mouse.getX() - player.x)
end
function zombiePlayerAngle(enemy)
    return math.atan2(player.y - enemy.y,player.x - enemy.x)
end
function spawnZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 140
    zombie.dead = false
    local side = math.random(1,4)
    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0,GY)
    elseif side == 2 then
        zombie.x = GX+30
        zombie.y = math.random(0,GY)
    elseif side == 3 then
        zombie.x = math.random(0,GX)
        zombie.y = -30
    elseif side == 4 then
        zombie.x = math.random(0,GX)
        zombie.y = GY+30
    end
    
    table.insert(zombies,zombie)
end
function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.dead = false
    bullet.direction = playerMouseAngle()
    table.insert(bullets,bullet)
end
function distanceBetween(x1,y1,x2,y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end