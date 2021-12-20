require "aite"
require "player"

janken={}
function janken.load()
	aite.load()
	player.load()
	love.graphics.newFont()

	janken.text={}
	janken.speed=0.5
	janken.interval=janken.speed
	janken.roundinterval=janken.speed*4
	janken.beat=0
	janken.round=0

	janken.sheet=love.graphics.newImage("/res/textures/text.png")
	janken.bakudan=love.graphics.newImage("/res/textures/textbg.png")

	janken.dasu=love.audio.newSource("res/audio/sfx/dasu.wav","static")
	janken.count=love.audio.newSource("res/audio/sfx/count.wav","static")
	
	janken.sai=love.graphics.newQuad(0,0,32,32,96,192)
	janken.shyo=love.graphics.newQuad(32,0,32,32 ,96,192)
	janken.guu=love.graphics.newQuad(64,0,32,32,96,192)
	
	janken.jan=love.graphics.newQuad(0,32,32,32,96,192)
	janken.ken=love.graphics.newQuad(32,32,32,32,96,192)
	janken.pon=love.graphics.newQuad(64,32,32,32,96,192)
	
	janken.ai=love.graphics.newQuad(0,64,32,32,96,192)
	janken.ko=love.graphics.newQuad(32,64,32,32,96,192)
	janken.deshyo=love.graphics.newQuad(64,64,32,32,96,192)

	janken.achi=love.graphics.newQuad(0,96,32,32,96,192)
	janken.muite=love.graphics.newQuad(32,96,32,32,96,192)
	janken.hoi=love.graphics.newQuad(64,96,32,32,96,192)

	janken.ka=love.graphics.newQuad(0,128,32,32,96,192)
	janken.chi=love.graphics.newQuad(32,128,32,32,96,192)

	janken.ma=love.graphics.newQuad(0,160,32,32,96,192)
	janken.ke=love.graphics.newQuad(32,160,32,32,96,192)

	janken.state="saishyo"
	janken.continue=true

	janken.saishyoguu(dt)
	janken.adv=true
	janken.laststate=janken.state
end

function love.keyreleased(key)
	if key == 'space' then 
		if janken.state ~= 'pause' then
			janken.laststate = janken.state
			janken.state = "pause"
		else		
			janken.state = janken.laststate
		end
	end
end

function janken.update(dt)
	
	

	if janken.state ~= 'pause' then
		aite.update(dt,janken.state,janken.beat)
		player.update(dt,janken.state)
		janken.interval = janken.interval - dt
		janken.roundinterval=janken.roundinterval - dt
		
		if janken.state ~= "make" and janken.state ~= "kachi" then 
			if janken.interval < 0 then
				--After sai-shyou-guu, 
				--Every four beats is a state check. 
				--We can do 'beats' and 'rounds', a round being four beats.
				--decisions for the aite move are made at the beginning of the round, 
				--and they'll have tells based on their next move
				--they might throw a tiny bit early, and might change their play.

				--the following are the events that will happen at each beat, in order.

				-- sai - FX - bump
				-- shyou
				-- guu - FX - bump
				--

				-- jan - FX - bump
				-- ken
				-- pon - FX - bump
				--

				-- achi - FX - bump
				-- muite
				-- hoi - FX - bump
				--

				--OR

				-- ai - FX - bump
				-- ko - FX - bump
				-- deshyou - FX - bump
				--

				-- after aiko, do more 'jankenpon' checks, except further aikos repeat until one player wins.

				-- If there is a win, stop here and click before continue?

				janken.beat=janken.beat+1 
				if janken.beat < 4 then
					--anything that happens during progress
					if janken.beat == 0 then
						if janken.adv and janken.continue then
							aite.mood("cry")
						elseif not janken.adv and janken.continue then
							aite.mood("happy")
						end

					end
					if janken.beat == 1 or (janken.state == 'saishyo' and janken.beat == 3) then
						janken.count:play()
						--bump and play sound
					elseif janken.beat == 3 then 
						janken.dasu:play()
					end

				else --janken.beat == 4
					janken.round = janken.round + 1
					janken.beat = 0

					if janken.state=="janken" or janken.state == 'aiko' then
						--first check
						if aite.move() ~= player.move() then
							janken.continue=true 
							if player.move() > 2 or player.move() < 0 then 
								--auto lose if you throw a direction
								aite.score=aite.score+1 
								janken.continue=true
								janken.adv=false
								janken.state = 'batsu'
								aite.mood("happy") 

							elseif ((aite.move() + player.move())%2)==0 then
								if player.move()>aite.move() then
									janken.adv=true
									aite.mood("cry")
								elseif player.move()<aite.move() then
									janken.adv=false
									aite.mood("happy") end
							elseif ((aite.move() + player.move())%2)==1 then
								if player.move()<aite.move() then
									janken.adv=true
									aite.mood("cry")
								elseif player.move()>aite.move() then
									janken.adv=false
									aite.mood("happy") end 
							end
						else 
							janken.continue=false 
							janken.state = 'aiko' 
						end
					elseif janken.state=="achimuite" then
						--second check
						if player.move() > 6 or player.move() < 3 then
							--auto lose if you don't throw a direction
							aite.score=aite.score+1 
							janken.continue=true
							janken.adv=false
							janken.state = 'batsu'
							aite.mood("happy") 
						elseif aite.move() == player.move() then
							if janken.adv then 
								--player advantage, win
								player.score=player.score+1
							else 
								--aite advantage, lose
								aite.score=aite.score+1 
							end
							--round end
							janken.continue=true
						else 
							--no winner, start over
							janken.continue=false 
						end
					end
					janken.gamestate(dt) 
					janken.roundinterval=janken.speed*4
				end

				janken.interval=janken.speed
			end
		else 
			--in kachimake
			janken.interval=janken.speed
			janken.roundinterval=janken.speed*4
			if janken.state == 'kachi' then
				aite.mood("cry")
			elseif janken.state == 'make' then
				aite.mood("happy")
				--make him giggle too, bump his face
			end
			if love.keyboard.isDown('return') then 
				janken.gamestate(dt) 
				janken.state="saishyo"
				janken.speed = janken.speed-0.03
			end
		end
	end
end

function janken.draw()
	local xoff=114
	aite.draw()
	if (janken.state == 'janken' 
	or janken.state == 'aiko' 
	or janken.state == 'achimuite') 
	and janken.beat == 3 then
		
		love.graphics.draw(janken.bakudan,172,158)
	end
	player.draw()
	for i=1,4 do
		if i <= janken.beat then
			love.graphics.draw(janken.sheet,janken.text[i],xoff+((i-1)*32),10) 
		end
	end
	local x,y=160,120

	if janken.state=="kachi" then
		love.graphics.draw(janken.sheet,janken.ka,x,y)
		love.graphics.draw(janken.sheet,janken.chi,x+32,y)
	elseif janken.state=="make" then
		love.graphics.draw(janken.sheet,janken.ma,x,y)
		love.graphics.draw(janken.sheet,janken.ke,x+32,y)
	end

	love.graphics.print(aite.score,32,12)
	love.graphics.print(player.score,264,12)
	janken.db()
end

function janken.db()
	local yoff=30
	love.graphics.print("state " .. janken.state,0,yoff)
	love.graphics.print("beat " .. janken.beat .. ' round ' .. janken.round,0,yoff+10)
	if janken.adv then love.graphics.print("advantage true",0,yoff+20)
	else love.graphics.print("advantage false",0,yoff+20) end
	love.graphics.print("interval " .. janken.interval,0,yoff+30)
	love.graphics.print("rnd intr " .. janken.roundinterval,0,yoff+40)
	if janken.continue then love.graphics.print("continue true",0,yoff+50)
	else love.graphics.print("continue false",0,yoff+50) end
	love.graphics.print("pmove "..player.move(),0,yoff+60)
	love.graphics.print("amove "..aite.move().."pick "..aite.picked,0,yoff+70)
end

--runs at the end of a round
function janken.gamestate(dt)
	if janken.state=="saishyo" then 
		janken.jankenpon(dt) 
	elseif janken.state =="janken" or janken.state == 'aiko' then
		if janken.continue then
			janken.achimuitehoi(dt)
		else
			janken.aikodeshyo(dt)
		end
	elseif janken.state=="achimuite" or janken.state == 'batsu' then
		if janken.continue then
			if janken.adv then
				janken.state="kachi"
			else
				janken.state="make"
			end
		else
			janken.saishyoguu(dt)
		end
	elseif janken.state=="make" or janken.state=="kachi" then
		janken.saishyoguu(dt)
	end
end

function janken.saishyoguu(dt)
	aite.mood("def")
	janken.text = {janken.sai,janken.shyo,janken.guu,''}
	janken.state="saishyo"
end
function janken.jankenpon(dt)
	janken.text = {janken.jan,janken.ken,janken.pon,''}
	janken.state="janken"
end
function janken.aikodeshyo(dt)
	janken.text = {janken.ai,janken.ko,janken.deshyo,''}
	janken.state = 'aiko'
end
function janken.achimuitehoi(dt)
	janken.text = {janken.achi,janken.muite,janken.hoi,''}
	janken.state = "achimuite"
end

function janken.setSpeed(sp)
	janken.speed=sp
end
