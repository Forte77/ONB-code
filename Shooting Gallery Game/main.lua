function love.load()
    target = {}
    target.x = 100
    target.y = 100
    target.radius = 50
    score = 0
    timer = 0
    fSize = love.graphics.newFont(40)
end
function love.update(dt)
    
end
function love.draw()
    love.graphics.setColor(1,0,0)
    love.graphics.circle("fill",target.x,target.y,target.radius)
    love.graphics.setColor(1,215/255,0)
    love.graphics.setFont(fSize)
    love.graphics.print(score,0,0)
end
function love.mousepressed(x,y,button,istouch,presses)
    if button == 1 then
        score = score+1
end