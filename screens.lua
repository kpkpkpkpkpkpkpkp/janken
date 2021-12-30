screens={}

function screens.load()
    
	screens.menu=love.graphics.newImage("/res/textures/title.png")
	screens.lose=love.graphics.newImage("/res/textures/lose.png")
	screens.win=love.graphics.newImage("/res/textures/win.png")
	screens.controlls=love.graphics.newImage("/res/textures/controlls.png")
    screens.janken=love.graphics.newImage("/res/textures/janken_bg.png")
    screens.current=screens.menu
end

function screens.draw()
	love.graphics.draw(screens.current)
end

function screens.changescreen(key)
    screens.current=screens[key]
end
