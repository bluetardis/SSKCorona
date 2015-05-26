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
	physics.setDrawMode( "hybrid" )

	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random

	-- Locals
	--

	-- A 'floor'
	--
	newRect( group, centerX, bottom - 10, 
		     { w = 260, h = 20, fill = _G_, alpha = 0.5},
		     { bodyType = "static" } )

	-- A fulcrum
	--
	local fulcrum = newCircle( group, centerX, bottom - 60, 
		       { radius = 10, fill = _Y_, alpha = 0.5}, 
		       { bodyType = "static" } )

	-- A beam (the lever)
	--
	local beam = newRect( group, centerX, bottom - 80, 
		     { w = 200, h = 20, fill = _C_, alpha = 0.5},
		     { bodyType = "dynamic", friction = 1 } )

	-- The Pivot
	--
	local pivotJoint = physics.newJoint( "pivot", beam, fulcrum, fulcrum.x, fulcrum.y )

	pivotJoint.isLimitEnabled = true
	pivotJoint:setRotationLimits( -10, 10 )

	-- Drop a 'box' on the beam
	--
	newRect( group, centerX + 60, bottom - 120, 
		     { size = 40, fill = _R_, alpha = 0.5},
		     { bodyType = "dynamic", friction = 1 } )


	-- Over time, drop smaller boxes on the other side
	--
	local function onTimer()
		if( not public.isRunning ) then return end

		local tmp = newRect( group, centerX - mRand(60, 90), bottom - 160, 
			     { size = 20, fill = _O_, alpha = 0.5},
			     { bodyType = "dynamic", friction = 0.5 } )

		tmp.timer = display.remove
		timer.performWithDelay( 8000, tmp )



		timer.performWithDelay( 1500, onTimer )

	end
	timer.performWithDelay( 1500, onTimer )



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
	local altName = "Balance Beam (MAY 2015)"
	local description = 
	'<font size="16" color="SteelBlue">Balance Beam (AKA Lever & Fulcrum) (MAY 2015)</font><br><br><br>' ..
    'A user asked how to make a "Balance Beam" in this post: <a href = "http://bit.ly/ssk_balance_beam">CLICK HERE</a><br><br>'
	
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