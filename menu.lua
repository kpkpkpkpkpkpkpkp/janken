menu={}
-- DEBUG = false
DEBU = true

function menu.load()
	menu.tic=love.audio.newSource("res/audio/sfx/menuclick.wav","static")
	menu.start=love.audio.newSource("res/audio/sfx/gong_01.ogg","static")
	menu.open=love.audio.newSource("res/audio/sound 21.ogg","static")
	menu.open:play()
	
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

function love.keypressed(key,scancode,isrepeat)
	player.keypressed(key,scancode,isrepeat)
	if key == 'up' then 
		menu.curr=menu.curr-1	
		menu.tic:play()
	elseif key == 'down' then
		menu.curr=menu.curr+1
		menu.tic:play()
	end

	if key =="return" then
		menu.gamestate=menu.listop[menu.curr]
		if menu.gamestate=='play' then 
			menu.start:play() 
		end
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

howtoplay = {
	"z: guu",
	"x: kii",
	"c: paa",

	"w: up",
	"a: left",
	"s: down",
	"d: right",

	"guu beats kii, kii beats paa, paa beats guu.",
	"if you win janken, match the opponent's direction to win the round. If they win, try not to look the same direction",
	"if you tie at janken, play again until someone wins.",

	"speed goes up every round. Try to get ten points!"
}
