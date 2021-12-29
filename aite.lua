require "hand"
aite={}
--each opponent has a preference for guu/paa/kii, but not for achimuite. 
--That will have tells for player advantage, and be random for disadvantage
--This gives the player only a 25% chance of losing in disadvantage unless they mess up
--since it is going to start moving very fast, the challenge will become not messing up rather than reading the tell
aitsura={
	{
		body=love.graphics.newImage("res/textures/bigbluebody.png"),
		faces=love.graphics.newImage("res/textures/faces.png"),
		stats={guu=70,kii=20,paa=10},
		firstto=3
	},
	{
		body=love.graphics.newImage("res/textures/bigredbody.png"),
		faces=love.graphics.newImage("res/textures/BlueFaces.png"),
		stats={guu=25,kii=50,paa=25},
		firstto=5
	},
	{
		body=love.graphics.newImage("res/textures/bigpurplebody.png"),
		faces=love.graphics.newImage("res/textures/YellowFaces.png"),
		stats={guu=30,kii=30,paa=40},
		firstto=7
	},
	{
		body=love.graphics.newImage("res/textures/bigblue2body.png"),
		faces=love.graphics.newImage("res/textures/faces2.png"),
		stats={guu=34,kii=33,paa=33},
		firstto=10
	}
}


function aite.load()
	aite.score=0

	aite.aitsucount=1
	aite.aitsu=aitsura[aite.aitsucount]

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


function aite.reset()
	aite.score=0

	aite.aitsucount=1
	aite.aitsu=aitsura[aite.aitsucount]

	aite.face=aite.faceDef
	aite.interval=0
	aite.curr=0
	aite.yb=0
	aite.picked=-1
end

function aite.next()
	aite.score=0
	aite.aitsucount=aite.aitsucount+1
	aite.aitsu=aitsura[aite.aitsucount]
	aite.face=aite.faceDef
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
			--this is the same for all ops
			hand.switch("guu","aite")
			aite.picked=-1
			aite.curr=0
		elseif beat == 1 then
			if (state == "janken" or state == 'aiko') and aite.picked < 0 then
				--aitsu will randomly pick a move based on their preference
				guuchance=aite.aitsu.stats.guu
				kiichance=aite.aitsu.stats.kii
				paachance=aite.aitsu.stats.paa
				r=math.random(100)

				if r<guuchance then
					aite.picked=0
				elseif r>guuchance and r<guuchance+kiichance then 
					aite.picked=1
				else
					--since the rest will fall in the last range we don't need to do the check
					aite.picked=2
				end
				-- aite.picked = math.random(2)
			end
			
			if state == "achimuite" and aite.picked < 0 then 
				aite.picked = math.random(3)+3
			end

		elseif beat == 2 then
			if player.move() >= 0 then
				if (state == "janken" or state == 'aiko') then
				elseif state == "achimuite" then
					if janken.adv then
						aite.dasu_a(aite.picked)
						--if they're losing they'll look 
						--the picked direction quickly before they dasu
						--this makes it easier to win, 1/4 to lose
					end
				end
			end
		elseif beat == 3 then
			if (state == "janken" or state == 'aiko') then 
				aite.dasu_j(aite.picked)
			elseif state == "achimuite" then 
				aite.dasu_a(aite.picked)
			else
--END DIFFERENT BEHAVIOR
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
	love.graphics.draw(aite.aitsu.body,102,32)
	love.graphics.draw(aite.aitsu.faces,aite.face,130,42+aite.yb,0,1,1,0,0)
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
