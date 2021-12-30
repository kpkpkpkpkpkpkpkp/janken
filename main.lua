require "janken"
require "menu"
require "screens"
DEBUG=true
-- DEBUG=false

function love.load()
	wwidth,wheight=320,240
	canvas = love.graphics.newCanvas(wwidth,wheight)
	canvas:setFilter("nearest","nearest")
	screens.load()
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

function mainmenu()
	menu.open:play()
	screens.changescreen('menu')
	menu.gamestate = 'menu'
	state = 'menu'
end

function love.keypressed(key,scancode,isrepeat)
	if state == 'menu' or state == 'controlls' then 
		menu.keypressed(key,scancode,isrepeat)
	elseif state == 'play' or state == 'end' then 
		janken.keypressed(key,scancode,isrepeat) 
	end
end

function love.draw()
	love.graphics.clear()
	love.graphics.setCanvas(canvas)

	love.graphics.rectangle("fill",0,0,wwidth,wheight)
	
	screens.draw()
	if state=="menu" then 
		menu.draw()
	elseif state=="play" then 
		janken.draw() 
	end

	love.graphics.setCanvas()
	love.graphics.draw(canvas,0,0,0,SCALE,SCALE)
	if DEBUG then 
		love.graphics.setColor(0,1,0)
		janken.db() 
		love.graphics.setColor(1,1,1)
	end
end