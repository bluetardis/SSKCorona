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
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random

	-- Locals
	--
	local shakeGroup = group

	--
	-- The shake code
	--
	local shakeCount = 0
	local xShake = 8
	local yShake = 4
	local shakePeriod = 2

	local function shake()
		if(shakeCount % shakePeriod == 0 ) then
			shakeGroup.x = shakeGroup.x0 + math.random( -xShake, xShake )
			shakeGroup.y = shakeGroup.y0 + math.random( -yShake, yShake )
		end
		shakeCount = shakeCount + 1
	end

	local function startShake()
		-- Shake group still valid?  If not, exit!
		if( shakeGroup.removeSelf == nil ) then return end

		shakeGroup.x0 = shakeGroup.x
		shakeGroup.y0 = shakeGroup.y
		shakeCount = 0
		Runtime:addEventListener( "enterFrame", shake )
	end
	
	local function stopShake()
		Runtime:removeEventListener( "enterFrame", shake )

		-- Shake group still valid?  If not, exit!
		if( shakeGroup.removeSelf == nil ) then return end

		timer.performWithDelay( 50, 
			function()			
				shakeGroup.x = shakeGroup.x0 
				shakeGroup.y = shakeGroup.y0
			end )
		timer.performWithDelay( 250, 
			function()			
				print("STOPPED SHAKE: ", shakeGroup.x, shakeGroup.x0, shakeGroup.y, shakeGroup.y0 )
			end )		
	end	

	--
	-- Images and scene items to help visualize the effect
	--
	local back = display.newImageRect( group, "images/asked/hawaii_2014.jpg", fullw, fullh )
	back.x = display.contentCenterX
	back.y = display.contentCenterY

	local ground = display.newRect( group, 0, 0, fullw, 20 )
	ground:setFillColor(0,1,0)
	ground.x = display.contentCenterX
	ground.y = bottom-10
	physics.addBody( ground, "static", { bounce = 0 } )


	local ball = display.newCircle( group, display.contentCenterX,20,20)
	ball:setFillColor(1,0,0)
	physics.addBody( ball, "dynamic", { radius = 20, bounce = 1, isBullet = true } )

	ball.collision = function( self, event )
		if( event.phase == "began" ) then
			startShake()
			timer.performWithDelay( 500, stopShake  )
		end
		return true
	end
	ball:addEventListener( "collision" )

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
	local altName = "Camera Shake (JUN 2014)"
	local description = 
	'<font size="22" color="SteelBlue">Camera Shake (JUN 2014)</font><br><br><br>' ..
    'From this post:<a href = "http://roaminggamer.com/2014/06/24/camera-shake-for-corona-sdk/">CLICK HERE</a><br><br>'
	

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