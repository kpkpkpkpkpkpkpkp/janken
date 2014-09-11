require "hand"
aite={}
function aite.load()
	aite.score=0
	aite.guy=love.graphics.newImage("res/textures/bigblue.png")
	aite.body=love.graphics.newImage("res/textures/bigbluebody.png")
	aite.faces=love.graphics.newImage("res/textures/faces.png")

	aite.dasu=love.audio.newSource("res/audio/sfx/dasu.wav","static")

	aite.faceDef=love.graphics.newQuad(0,0,64,64,128,128)
	aite.faceHappy=love.graphics.newQuad(64,0,64,64,128,128)
	aite.faceCry=love.graphics.newQuad(0,64,64,64,128,128)
	aite.face=aite.faceDef
	hand.load()
	aite.interval=0
	aite.curr=0
end
function aite.update(dt,state,beats)
	local ran = 0
	aite.interval = aite.interval + dt
	if state ~= "make" and state ~= "kachi" then 
		if aite.interval > 0.9 then 
			hand.bump(4)
		end

		if aite.interval > 1 then 
			hand.switch("guu","aite")
			hand.bump(0)
			if state == "janken" and beats == 1 then 
				aite.dasu_j()
			elseif state == "achimuite" and beats == 1 then 
				aite.dasu_a()
			elseif state == "kachi" then 
				hand.switch("make","aite")
				aite.mood("cry")
			elseif state == "make" then 
				hand.switch("kachi","aite")
				aite.mood("happy") end

			aite.interval=0
		end
	end
end
function aite.draw()
	love.graphics.draw(aite.body,102,32)
	love.graphics.drawq(aite.faces,aite.face,130,42,0,1,1,0,0)
	hand.draw(164,138,"aite")
end

function aite.dasu_j()
	--love.audio.play(aite.dasu)
	local ran = math.random(3)
	if ran==1 then 
		hand.switch("guu","aite")
		aite.curr = 0
	elseif ran==2 then 
		hand.switch("kii","aite")
		aite.curr = 1
	elseif ran==3 then 
		hand.switch("paa","aite")
		aite.curr = 2
	else
		hand.switch("guu","aite")
		aite.curr = 0
	end
end
function aite.dasu_a()
	--love.audio.play(aite.dasu)
	local ran = math.random(4)
	if ran==1 then 
		hand.switch("hidari","aite")
		aite.curr = 3
	elseif ran==2 then 
		hand.switch("shita","aite")
		aite.curr = 4
	elseif ran==3 then 
		hand.switch("migi","aite")
		aite.curr = 5
	elseif ran==4 then 
		hand.switch("ue","aite")
		aite.curr = 6
	else 
		hand.switch("ue","aite")
		aite.curr = 6
	end
end

function aite.mood(sign)
	
	local current = aite.faceDef
	if sign == "def" then current = aite.faceDef
	elseif sign == "happy" then current = aite.faceHappy
	elseif sign == "cry" then current = aite.faceCry
	else current=current
	end
	aite.face=current
end

function aite.move()
	return aite.curr
end