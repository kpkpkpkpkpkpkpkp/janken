require "hand"
player={}
function player.load()
	player.score=0
	hand.load()
	player.curr=0
end
function player.update(dt,state)
	if love.keyboard.isDown('a') then 
		hand.switch("hidari")
		player.curr = 3
	elseif love.keyboard.isDown('s') then 
		hand.switch("shita")
		player.curr = 4
	elseif love.keyboard.isDown('d') then 
		hand.switch("migi")
		player.curr = 5
	elseif love.keyboard.isDown('w') then 
		hand.switch("ue")
		player.curr = 6

	elseif love.keyboard.isDown('z') then 
		hand.switch("guu")
		player.curr=0
	elseif love.keyboard.isDown('x') then 
		hand.switch("kii")
		player.curr=1
	elseif love.keyboard.isDown('c') then 
		hand.switch("paa")
		player.curr=2

	elseif love.keyboard.isDown('q') then hand.switch("kachi")
	elseif love.keyboard.isDown('e') then hand.switch("make")
	else 
		if state=="achimuite" then 
			hand.switch("shita")
			player.curr=4
		else
			hand.switch("guu")
			player.curr=0
		end
	end
end
function player.draw()
	hand.draw(172,158)
end

function player.move()
	return player.curr
end