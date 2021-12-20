require "janken"
require "menu"
function love.load()
	wwidth,wheight=320,240
	canvas = love.graphics.newCanvas(wwidth,wheight)
	canvas:setFilter("nearest","nearest")
	bg=love.graphics.newImage("res/textures/janken_bg.png")
	menu.load()
	janken.load()
	state = menu.gs()
end

function love.update(dt)
	
	if state=="menu" then 
		menu.update(dt)
		state=menu.gs()
	elseif state=="play" then 
		janken.update(dt)
	elseif state=="quit" then 
		love.event.quit()
	else end
end

function love.draw()
	love.graphics.setCanvas(canvas)

	-- love.graphics.setColor(50/255,0,133/255)
	love.graphics.rectangle("fill",0,0,wwidth,wheight)
	-- love.graphics.setColorMode("replace")
	
	love.graphics.draw(bg)
	if state=="menu" then menu.draw()
	elseif state=="play" then janken.draw() end

	love.graphics.setCanvas()
	love.graphics.draw(canvas,0,0,0,SCALE,SCALE)
end