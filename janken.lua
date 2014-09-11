require "aite"
require "player"

janken={}
function janken.load()
	aite.load()
	player.load()
	love.graphics.newFont()

	janken.text={}
	janken.speed=2
	janken.interval=0
	janken.beat=0


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
end
function janken.update(dt)
	aite.update(dt,janken.state,janken.beat)
	player.update(dt,janken.state)
	janken.interval = janken.interval + dt

	if janken.state ~= "make" and janken.state ~= "kachi" then 
		if janken.interval > 0.5 then
			if janken.beat<3 then 
				janken.beat=janken.beat+1 
				
				if janken.beat==2 then 
					if janken.state=="janken" then
						if aite.move() ~= player.move() then
							janken.continue=true 
							if ((aite.move() + player.move())%2)==0 then
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
						else janken.continue=false end
					elseif janken.state=="achimuite" then
						if aite.move() == player.move() then
							if janken.adv then player.score=player.score+1
							else aite.score=aite.score+1 end
							janken.continue=true
						else janken.continue=false end
					end
				end
			else 
				janken.beat=0 
				
				janken.gamestate(dt) 
			end
			janken.count:play()
			--janken.sfx(janken.beat)

			janken.interval=0
		end
	else 
		if love.keyboard.isDown('z') then janken.gamestate(dt) end
	end
end

function janken.draw()
	local xoff=114
	aite.draw()
	player.draw()
	local beats = janken.beat+1
	for i=1,3 do
		if beats < 4 then love.graphics.drawq(janken.sheet,janken.text[i],
			xoff+((i-1)*32)
			,10) end
		if i == beats then break end
	end
	local x,y=160,120
	if janken.state=="kachi" then
		love.graphics.drawq(janken.sheet,janken.ka,x,y)
		love.graphics.drawq(janken.sheet,janken.chi,x+32,y)
	elseif janken.state=="make" then
		love.graphics.drawq(janken.sheet,janken.ma,x,y)
		love.graphics.drawq(janken.sheet,janken.ke,x+32,y)
	end

	love.graphics.print(aite.score,32,12)
	love.graphics.print(player.score,264,12)
	janken.db()
end

function janken.db()
	local yoff=30
	love.graphics.print("state " .. janken.state,0,yoff)
	love.graphics.print("beat " .. janken.beat,0,yoff+10)
	if janken.adv then love.graphics.print("advantage true",0,yoff+20)
	else love.graphics.print("advantage false",0,yoff+20) end
	love.graphics.print("interval " .. janken.interval,0,yoff+30)
	if janken.continue then love.graphics.print("continue true",0,yoff+40)
	else love.graphics.print("continue false",0,yoff+40) end
end

--runs at the end of a measure
function janken.gamestate(dt)
	aite.mood("def")
	if janken.state=="saishyo" then 
		janken.jankenpon(dt) 
	elseif janken.state=="janken" then
		if janken.continue then
			janken.achimuitehoi(dt)
		else
			janken.aikodeshyo(dt)
		end
	elseif janken.state=="achimuite" then
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
function janken.sfx(beat)
	if beat==2 then
		janken.dasu:play()
	else
		janken.count:play()
	end
end

function janken.saishyoguu(dt)
	janken.text = {janken.sai,janken.shyo,janken.guu}
	janken.state="saishyo"
end
function janken.jankenpon(dt)
	janken.text = {janken.jan,janken.ken,janken.pon}
	janken.state="janken"
end
function janken.aikodeshyo(dt)
	janken.text = {janken.ai,janken.ko,janken.deshyo}
end
function janken.achimuitehoi(dt)
	janken.text = {janken.achi,janken.muite,janken.hoi}
	janken.state = "achimuite"
end

function janken.setSpeed(sp)
	janken.speed=sp
end
