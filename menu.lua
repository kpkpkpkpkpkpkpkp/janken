menu={}
function menu.load()
	menu.bg=love.graphics.newImage("res/textures/title.png")
	menu.select=love.graphics.newImage("res/textures/tilde.png")
	menu.ys=22
	menu.listop={"play","option","quit"}
	menu.curr=1
	menu.gamestate="menu"
end

function menu.update(dt)
	if menu.curr<1 then menu.curr=1 end
	if menu.curr>3 then menu.curr=3 end
	menu.choice(menu.listop[menu.curr])
end

function menu.draw()
	love.graphics.draw(menu.bg)
	love.graphics.draw(menu.select,204,menu.ys)
end

function love.keypressed(key)
	if key == 'up' then 
		menu.curr=menu.curr-1	
	elseif key == 'down' then
		menu.curr=menu.curr+1
	end

	if key =="return" then
		menu.gamestate=menu.listop[menu.curr]
	end
end

function menu.choice(ch)
	if ch=="play" then
		menu.ys=22
	elseif ch=="option" then
		menu.ys=56
	elseif ch=="quit" then
		menu.ys=84
	end
end

function menu.gs()
	return menu.gamestate
end