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
	aite.yb=0
	aite.picked=-1
end

function aite.update(dt,state,beat)
	aite.interval = aite.interval + dt
	
	if aite.interval > 0.5 then 
		aite.interval=0
	end
	if state ~= "make" and state ~= "kachi" then 
		hand.update(dt,state,beat)

		--at some point, make an aite that will try to check your hand early and beat you if you throw first
		
		if beat == 0 then 
			hand.switch("guu","aite")
			aite.picked=-1
		elseif beat == 1 then
			if state == "janken" and aite.picked < 0 then
				aite.picked = math.random(3)-1
			end
			
			if state == "achimuite" and aite.picked < 0 then 
				aite.picked = math.random(4)+2
			end
			if state ~= "achimuite" then
				-- aite.mood('def')
			end

		elseif beat == 2 then
			if player.move() >= 0 then
				if state == "janken" then
					-- aite.picked=hand.winningpair(player.move())
				elseif state == "achimuite" then
					if not janken.adv then
						--if aite has the advantage, then they'll pick the right direction
						--else, leave it random
						-- aite.picked=hand.winningpair(player.move())
					end
				end
			end
		elseif beat == 3 then
			if (state == "janken" or state == 'aiko') then 
				aite.dasu_j(aite.picked)
			elseif state == "achimuite" then 
				aite.dasu_a(aite.picked)
			else
		end

	else
		--kachimake
		if state == "kachi" then 
			-- hand.switch("make","aite")
			-- aite.mood("cry")
		elseif state == "make" then 
			-- hand.switch("kachi","aite")
			-- aite.mood("happy") 
			if aite.interval > 0.3 then
				aite.bump(4)
			else
				aite.bump(0)
			end 
		end
	end
end
end

function aite.draw()
	love.graphics.draw(aite.body,102,32)
	love.graphics.draw(aite.faces,aite.face,130,42+aite.yb,0,1,1,0,0)
	hand.draw(164,138,"aite")
end

function aite.dasu_j(ran)
	aite.curr = ran
	if ran==0 then 
		hand.switch("guu","aite")
	elseif ran==1 then 
		hand.switch("kii","aite")
	elseif ran==2 then 
		hand.switch("paa","aite")
	else
		hand.switch("guu","aite")
	end
end

function aite.dasu_a(ran)
	aite.curr = ran
	if ran==3 then 
		hand.switch("migi","aite")
	elseif ran==4 then 
		hand.switch("shita","aite")
	elseif ran==5 then 
		hand.switch("hidari","aite")
	elseif ran==6 then 
		hand.switch("ue","aite")
	else 
		hand.switch("ue","aite")
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

function aite.picked()
	return aite.picked
end

function aite.bump(y)
	--y here is y offset to face bump to
	aite.yb=y
end
