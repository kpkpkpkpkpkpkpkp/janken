require "hand"
player={}
function player.load()
	player.score=0
	hand.load()
	player.curr=0
	player.picked=false
end

function player.reset()
	player.score=0
	player.curr=0
	player.picked=false
end

function player.keypressed(key, scancode, isrepeat)
	if key=='a' then 
		hand.switch("hidari")
		player.curr = 3
		if player.picked then player.curr = -1 else player.picked=true end
	elseif key=='s' then 
		hand.switch("shita")
		player.curr = 4
		if player.picked then player.curr = -1 else player.picked=true end
	elseif key=='d' then 
		hand.switch("migi")
		player.curr = 5
		if player.picked then player.curr = -1 else player.picked=true end
	elseif key=='w' then 
		hand.switch("ue")
		player.curr = 6
		if player.picked then player.curr = -1 else player.picked=true end
	elseif key=='z' then 
		hand.switch("guu")
		player.curr=0
		if player.picked then player.curr = -1 else player.picked=true end
	elseif key=='x' then 
		hand.switch("kii")
		player.curr=1
		if player.picked then player.curr = -1 else player.picked=true end
	elseif key=='c' then 
		hand.switch("paa")
		player.curr=2
		if player.picked then player.curr = -1 else player.picked=true end
	elseif key=='q' then hand.switch("kachi")
	elseif key=='e' then hand.switch("make")
	else 
	end
end

function player.update(dt,state)
end

function player.draw()
	hand.draw(172,158)
end

function player.move()
	return player.curr
end