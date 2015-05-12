-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

-- =============================================================
-- init( group )
-- Code that needs to run before the sample can be executed goes here.
-- This is usually stuff like loading sprites, sound files, or prepping
-- data.
--
-- group - A display group for you to place any visual content into.
--         This group is managed for you and should not be destroyed by
--         your code.
-- =============================================================
function public.init( group )
	print("Did init @ ", system.getTimer() )
end

-- =============================================================
-- cleanup()
-- Any special cleanup code goes here.  
--
-- The module itself will be destroyed as well as all content rendered into
-- the group, so you don't need to do that.
-- =============================================================
function public.cleanup( )
	print("Did cleanup @ ", system.getTimer() )
	public.isRunning = false

	local physics = require("physics")
	physics.setDrawMode( "normal" )
	physics.stop()


end

-- =============================================================
-- run( group )
--
-- group - A display group for you to place any visual content into.
--         This group is managed for you and should not be destroyed by
--         your code. 
-- =============================================================
function public.run( group )

	public.isRunning = true		

	local physics = require("physics")
	physics.start()
	physics.setGravity(0,9.8)
	--physics.setDrawMode( "hybrid" )

	-- Localizations
	local mRand 		= math.random

	-- Locals
	--
	local allBalloons = {}

	local function onTouch( self, event )
		allBalloons[self] = nil
		display.remove(self)
		return true
	end

	local function createBalloon( )
		-- Abort!  Example no longer running
		--
		if( not public.isRunning ) then return end

		-- Randomly create one of five balloon images
		local imgNum = mRand( 1, 5 )	
		local tmp = display.newImageRect( group, "images/asked/balloon" .. imgNum .. ".png", 295/5, 482/5 )	

		-- Randomly place the balloon
		tmp.y = top - 50
		tmp.x = mRand( left + 50, right - 50 )

		-- Scale it to make a 'smaller' balloon
		--tmp:scale( 0.1, 0.1 )

		-- add a touch listener
		tmp.touch = onTouch
		tmp:addEventListener( "touch" )

		-- Give it a body so 'gravity' can pull on it
		physics.addBody( tmp, { radius = tmp.contentWidth/2} )

		-- Give the body a random rotation
		tmp.angularVelocity = mRand( -180, 180 )

		-- Give it drag so it doesn't accelerate too fast
		tmp.linearDamping = 1

		-- Self destruct in 5 seconds
		timer.performWithDelay( 5000,
			function()
				allBalloons[tmp] = nil
				display.remove( tmp )
			end )
		timer.performWithDelay( 500, createBalloon  )
	end


	-- Create a new baloon every 1/2 second  forever
	timer.performWithDelay( 500, createBalloon  )

end

-- =============================================================
-- More... add any additional functions you need below
-- =============================================================


-- =============================================================
-- Functions below this marker are optional.
-- They are used by the sampler to provide more details about the
-- sample and to do special sampler-only setup or cleanup.
-- =============================================================
function public.about()
	local altName = "Balloon Pop (JUN 2014)"
	local description = 
	'<font size="22" color="SteelBlue">Balloon Pop (JUN 2014)</font><br><br><br>' ..
    'A simple example of how to use touch inputs to make a basic "popper". <br><br>' ..
    'From this post:<a href = "http://roaminggamer.com/2014/06/27/touch-listeners-and-balloon-popper-corona-sdk/">CLICK HERE</a><br><br>' ..
    'Balloons from here:<a href = "clipart.nicubunu.ro">http://clipart.nicubunu.ro/</a><br>'
    
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end
function public.samplerSetup( group )
	print("Did sampler setup @ ", system.getTimer() )
end
function public.samplerCleanup( group )
	print("Did sampler cleanup @ ", system.getTimer() )
end

return public