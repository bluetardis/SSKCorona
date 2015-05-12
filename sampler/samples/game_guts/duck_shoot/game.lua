-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local game = {}

local startTime = -1
local lastTime = startTime

-- Initialize the game
--
function game.init( group )
end

-- Stop, cleanup, and destroy the game.;
--
function game.cleanup( )
	game.isRunning = false
end

-- Run the Game
--
function game.run( group )
	game.isRunning = true		

	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random

	-- Locals
	--

	function convertSecondsToTimer( seconds )
		local seconds = tonumber(seconds)
		local minutes = math.floor(seconds/60)
		local remainingSeconds = seconds - (minutes * 60)

		local timerVal = "" 

		if(remainingSeconds < 10) then
			timerVal =  minutes .. ":" .. "0" .. remainingSeconds
		else
			timerVal = minutes .. ":"  .. remainingSeconds
		end

		return timerVal
	end


	startTime = -1
	lastTime = startTime

	local layers = ssk.display.quickLayers( group, "bot", "mid", "top" )


	local timer = display.newText( layers.bot, "0:00", 0, 0, native.systemFont, 32)
	timer.x = centerX - w/4
	timer.y = 60


	local score = display.newText( layers.top, 0, 0, 0, native.systemFont, 32)
	score.x = centerX + w/4
	score.y = 60


	local function onEnterFrame( event )
		if( not game.isRunning ) then
			ignore("enterFrame", onEnterFrame)
			return
		end

		local curTime = event.time

		if(startTime == -1) then
			startTime = curTime
		end
		
		local delta = curTime - lastTime

		if( delta >= 1000 ) then
			lastTime = curTime
			--print( convertSecondsToTimer( (curTime-lastTime)/1000 ) ) 
			--print( lastTime/1000 ) 
			local newTime = convertSecondsToTimer( round(lastTime/1000) )
			timer.text = newTime
			--print(  )
		end
	end

	listen( "enterFrame", onEnterFrame )

	local bar = newRect( layers.mid, centerX, centerY + 60, 
		{ w = fullw, h = 60, fill = {0,0,0.5} } )

	local ping = audio.loadSound("images/gameGuts/duckshoot/ping.wav")

	local function onTouch( self, event )
		if(event.phase == "ended") then
			transition.to( self, { yScale  = 0.05, time = 100, y = self.y + self.height/2 } )
			audio.play( ping )
			score.text = score.text + 1
		end
		return true
	end


	local function newDuck( y, delay )

		local duck = newImageRect( layers.bot, w + w/4, y, "images/gameGuts/duckshoot/duck.png",
			{ w = 80, h = 63 } )

		duck.x0 = duck.x
		duck.y0 = duck.y

		duck.touch = onTouch

		duck:addEventListener( "touch", duck )

		local onComplete

		onComplete = function( obj )
			obj.x = obj.x0
			obj.y = obj.y0
			obj.xScale = 1
			obj.yScale = 1
			transition.to( obj, { x = -w/4, time = 6000, onComplete = onComplete } )
		end

		transition.to( duck, { x = -w/4, time = 6000, delay = delay, onComplete = onComplete } )

	end

	newDuck( centerY, 0 )
	newDuck( centerY, 1000 )
	newDuck( centerY, 2000 )
	newDuck( centerY, 3000 )
	newDuck( centerY, 4000 )
	newDuck( centerY, 5000 )



end

return game