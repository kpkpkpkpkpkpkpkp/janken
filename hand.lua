hand={}
function hand.load()
	hand.a_sheet=love.graphics.newImage("res/textures/janken_aite.png")
	hand.p_sheet=love.graphics.newImage("res/textures/janken_jibun.png")
	hand.yb=0

	hand.guu=love.graphics.newQuad(0,0,63,47,208,176)
	hand.kii=love.graphics.newQuad(64,0,63,47,208,176)
	hand.paa=love.graphics.newQuad(128,0,63,47,208,176)

	hand.kachi=love.graphics.newQuad(96,48,47,79,208,176)
	hand.make=love.graphics.newQuad(144,48,47,79,208,176)

	hand.shita=love.graphics.newQuad(0,48,47,79,208,176)
	hand.ue=love.graphics.newQuad(48,48,47,79,208,176)
	hand.migi=love.graphics.newQuad(0,128,79,47,208,176)
	hand.hidari=love.graphics.newQuad(80,128,79,47,208,176)

	hand.curr=hand.guu
	hand.a_curr=hand.guu
end
function hand.update(dt)
end
function hand.draw(x,y,d)
	osx=0
	osy=0
	if d == "aite" then love.graphics.drawq(hand.a_sheet,hand.a_curr,x,y-hand.yb,0,-1,1,osx,osy)
	else love.graphics.drawq(hand.p_sheet,hand.curr,x,y-hand.yb,0,1,1,osx,osy)
	end
end

function hand.switch(sign,ap)
	local current = hand.guu
	if sign == "guu" then current = hand.guu
	elseif sign == "kii" then current = hand.kii
	elseif sign == "paa" then current = hand.paa

	elseif sign == "kachi" then current = hand.kachi
	elseif sign == "make" then current = hand.make

	elseif sign == "shita" then current = hand.shita
	elseif sign == "ue" then current = hand.ue
	elseif sign == "migi" then current = hand.migi
	elseif sign == "hidari" then current = hand.hidari
	else current=current
	end

	if ap == "aite" then 
		hand.a_curr=current
	else hand.curr=current
	end
end

function hand.bump(y)
	hand.yb=y
end
