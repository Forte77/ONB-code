function love.load()
    math.randomseed(os.time()) -- Base random seed off of time so that the zombies don't come from the same place everytime.
    sprites = {}
    sprites.background = love.graphics.newImage('sprites/SWSP.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    GX = love.graphics.getWidth() -- Save the window X for further use
    GY = love.graphics.getHeight() -- Save the window Y for further use
    player = {}
    player.x = GX/2 -- Spawn player in center X
    player.y = GY/2 -- Spawn player in center Y
    player.speed = 180
    player.inj = false
    mFont = love.graphics.newFont(30)
    zombies = {}
    bullets = {}
    menu = true
    score = 0
    maxTime = 2
    timer = maxTime
end
function love.update(dt)
    if menu == false then -- Movement
        if player.inj == true then
            player.speed = 270
        else
            player.speed = 180
        end
        if love.keyboard.isDown("d") and player.x < GX-5 then
            player.x = player.x + player.speed*dt
        end
        if love.keyboard.isDown("a") and player.x > 5 then
            player.x = player.x - player.speed*dt
        end
        if love.keyboard.isDown("w") and player.y > 5 then
            player.y = player.y - player.speed*dt
        end
        if love.keyboard.isDown("s") and player.y < GY-5 then
            player.y = player.y + player.speed*dt
        end
    end
    for i,z in ipairs(zombies) do -- Spawn zombies coming in from random angles
        z.x = z.x + (math.cos(zombiePlayerAngle(z)) * z.speed * dt)
        z.y = z.y + (math.sin(zombiePlayerAngle(z)) * z.speed * dt)
        if distanceBetween(z.x,z.y,player.x,player.y)<20 then -- Collision checker
            if player.inj then
                for i,z in ipairs(zombies) do
                    zombies[i] = nil
                end
                menu = true -- Game over restart to menu
                player.x = GX/2 -- Reset player location
                player.y = GY/2
                player.inj = false
            else
                zombies[i].dead = true
                player.inj = true
            end
        end
    end
    for i,b in ipairs(bullets) do -- Shoot Bullet out
        b.x = b.x + (math.cos(b.direction) * b.speed * dt) 
        b.y = b.y + (math.sin(b.direction) * b.speed * dt)
    end
    for i=#bullets,1,-1 do --#table gets the length of the table
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > GX or b.y > GY then
            table.remove(bullets,i)
        end
    end
    for i,z in ipairs(zombies) do -- Bullet to Zombie Collision checker
        for j,b in ipairs(bullets) do 
            if distanceBetween(z.x,z.y,b.x,b.y) < 20 then
                b.dead = true
                z.dead = true
                score = score + 1
            end
        end
    end
    for i=#zombies,1,-1 do -- Remove Zombies that collide
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies,i)
        end
    end
    for i=#bullets,1,-1 do -- Remove Bullets 
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets,i)
        end
    end
    if menu == false then -- Start timer when game starts
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
    if menu == true then -- Click to start
        love.graphics.setFont(mFont)
        love.graphics.setColor(1,0,0)
        love.graphics.printf("Click anywhere to begin!",0,50,GX,"center")
        love.graphics.setColor(1,1,1)
    end
    love.graphics.printf("Score: "..score, 5, GY-100,GX,"center")
    if player.inj == true then
        love.graphics.setColor(0.7,0,0)
    elseif player.inj == false or menu == true then
        love.graphics.setColor(1,1,1)
    end
    love.graphics.draw(sprites.player,player.x,player.y,playerMouseAngle(),nil,nil,sprites.player:getWidth()/2,sprites.player:getHeight()/2) -- Offset Player spawn
    love.graphics.setColor(1,1,1)
    for i,z in ipairs(zombies) do -- Offset Zombie Spawn
        love.graphics.draw(sprites.zombie,z.x,z.y,zombiePlayerAngle(z),nil,nil,sprites.zombie:getWidth()/2,sprites.player:getHeight()/2)
    end
    for i,b in ipairs(bullets) do -- Fix bullet size and spawn point
        love.graphics.draw(sprites.bullet,b.x,b.y,nil,0.5,0.5,sprites.bullet:getWidth()/2,sprites.bullet:getHeight()/2)
    end
end
function love.keypressed(key) -- Manual Zombie Spawn
    if key == "space" then
        spawnZombie()
    end
end
function love.mousepressed(x,y,button) -- Left Click
    if button == 1 and menu == false then
        spawnBullet()
    elseif button == 1 and menu == true then
        menu = false
        maxTime = 2
        timer = maxTime
        score = 0
    end
end
function playerMouseAngle() -- Player faces Cursor
    return math.atan2(love.mouse.getY() - player.y,love.mouse.getX() - player.x)
end
function zombiePlayerAngle(enemy) -- Zombie faces Cursor
    return math.atan2(player.y - enemy.y,player.x - enemy.x)
end
function spawnZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 140
    zombie.dead = false
    local side = math.random(1,4) -- Randomize which side the Zombie comes from
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
function distanceBetween(x1,y1,x2,y2) -- Make a collision radius
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end