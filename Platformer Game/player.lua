-- Collider (windfield) combines physics body fixture and shape to one object. Physics object = collider
player = world:newRectangleCollider(360,100,40,100, {collision_class = 'Player'}) -- x y w h
player:setFixedRotation(true)
player.speed = 240 --Colliders are like tables so we can give them properties
player.animation = animations.idle
player.isMoving = false
player.direction = 1 --1 to the right -1 to the left
player.grounded = true
function playerUpdate(dt)
    --Grab player position for movement
    if player.body then
        local colliders = world:queryRectangleArea(player:getX()-20,player:getY()+50,40,2,{'Platform'}) --using querying for colliders. Making a thin rectangle right below player.
        if #colliders>0 then 
            player.grounded =true
        else
            player.grounded = false
        end 
        player.isMoving = false
        local px, py = player:getPosition()
        if love.keyboard.isDown('right') then --Move Right
            player:setX(px+player.speed*dt)
            player.isMoving = true
            player.direction = 1
        end
        if love.keyboard.isDown('left') then --Move Left
            player:setX(px-player.speed*dt)
            player.isMoving = true
            player.direction = -1
        end

        if player:enter('Danger') then 
            player:destroy()
        end
    end
    if player.grounded then
        if player.isMoving then
            player.animation = animations.run
        else
            player.animation = animations.idle
        end
    else
        player.animation = animations.jump
    end
    player.animation:update(dt)
end
function drawPlayer()
    local px,py = player:getPosition() -- get position of player to draw the animation in the right spot.
    player.animation:draw(sprites.playerSheet, px,py,nil,0.25*player.direction,0.25,130,300)
end