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
	local physics = require "physics"
	physics.setDrawMode( "normal" )
	physics.stop()	

	public.isRunning = false
end

-- =============================================================
-- run( group )
--
-- group - A display group for you to place any visual content into.
--         This group is managed for you and should not be destroyed by
--         your code. 
-- =============================================================
function public.run( group )
	print("Started running @ ", system.getTimer(), group )

	public.isRunning = true

	local physics = require "physics"
	physics.setGravity( 0, 10 )
	physics.start()
	--physics.setDrawMode( "hybrid" )

	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect   	= ssk.display.newRect
	local newImageRect  = ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC

	-- =============================================================
	-- SSK Versions
	-- =============================================================

	easyIFC:quickLabel( group, "14 Lines Using SSK", centerX - 150, centerY - 100 )
	easyIFC:quickLabel( group, "(Auto-calculated Collision Settings)", centerX - 150, centerY - 80, gameFont, 10 )

	local myCC = ssk.ccmgr:newCalculator()
	myCC:addNames( "yball", "bball", "rblock", "gblock", "bblock" )
	myCC:collidesWith( "yball", "rblock", "gblock" ) -- Yellow ball collides with red block and green block
	myCC:collidesWith( "bball", "bblock", "gblock" ) -- Orange ball collides with blue block and green block
	                                                 -- Implied calculation are automatically handled.
	
	newImageRect( group, centerX - 150, centerY + 50, "images/kenney/physicsAssets/metal/square1.png", 
		          { fill = _R_, rotation = 15 }, { bodyType = "static", calculator = myCC, colliderName = "rblock"  } ) 

	newImageRect( group, centerX - 100, centerY + 100, "images/kenney/physicsAssets/metal/rectangle.png", 
		          { w = 110, h = 35, fill = _G_  }, { bodyType = "static", calculator = myCC, colliderName = "gblock"  } ) 

	newImageRect( group, centerX - 50, centerY + 50, "images/kenney/physicsAssets/metal/square1.png", 
		          { fill = _B_, rotation = -15  }, { bodyType = "static", calculator = myCC, colliderName = "bblock"  } ) 


	local function dropSSKBalls()
		if( not public.isRunning ) then return end
		
		newImageRect( group, centerX - 150 , centerY - 50, 
			          "images/kenney/physicsAssets/yellow_round.png", 
			          { size = 20 }, { radius = 10, bounce = 0.3, calculator = myCC, colliderName = "yball" } )
		newImageRect( group, centerX - 50 , centerY - 50, 
			          "images/kenney/physicsAssets/blue_round.png",
			          { size = 20 }, { radius = 10, bounce = 0.3, calculator = myCC, colliderName = "bball" } )
		
		timer.performWithDelay( 1000, dropSSKBalls ) 
	end

	dropSSKBalls()

	-- =============================================================
	-- Traditional Corona versions
	-- =============================================================

	-- Collision settings calculated via sheet on this page:
	-- http://docs.coronalabs.com/daily/guide/physics/collisionDetection/index.html#collision-filtering
	--[[
                            1     2    4    8    16      ... sum
	yball category          x                            1
	yball collides with                x    x            12

	bball category                x                      2
	bball collides with                     x    x       24

	rblock category                    x                 4
	rblock collides with    x                            1

	gblock category                         x            8
	gblock collides with    x    x                       3

	bblock category                              x       16 
	bblock collides with         x                       2
	]]

	easyIFC:quickLabel( group, "37 Lines Traditionally", centerX + 100, centerY - 100 )
	easyIFC:quickLabel( group, "(+10 lines Hand-calculations)", centerX + 100, centerY - 80, gameFont, 10 )

	local yBallFilter = { categoryBits = 1, maskBits = 12 }
	local oBallFilter = { categoryBits = 2, maskBits = 24 }
	local rBlockFilter = { categoryBits = 4, maskBits = 1 }
	local gBlockFilter = { categoryBits = 8, maskBits = 3 }
	local bBlockFilter = { categoryBits = 16, maskBits = 2 }

	local rblock = display.newImageRect( group, "images/kenney/physicsAssets/metal/square1.png", 40, 40 )
	rblock.x = centerX + 50
	rblock.y = centerY + 50
	rblock:setFillColor(1,0,0)
	physics.addBody( rblock, "static", { bounce = 0.2, friction = 0.3, density = 1, filter = rBlockFilter } )
	rblock.rotation = 15

	local gblock = display.newImageRect( group, "images/kenney/physicsAssets/metal/rectangle.png", 110, 35 )
	gblock.x = centerX + 100
	gblock.y = centerY + 100
	gblock:setFillColor(0,1,0)
	physics.addBody( gblock, "static", { bounce = 0.2, friction = 0.3, density = 1, filter = gBlockFilter } )

	local bblock = display.newImageRect( group, "images/kenney/physicsAssets/metal/square1.png", 40, 40 )
	bblock.x = centerX + 150
	bblock.y = centerY + 50
	bblock:setFillColor(0,0,1)
	physics.addBody( bblock, "static", { bounce = 0.2, friction = 0.3, density = 1, filter = bBlockFilter } )
	bblock.rotation = -15

	local function dropTraditionalBalls()
		if( not public.isRunning ) then return end

		local yball = display.newImageRect( group, "images/kenney/physicsAssets/yellow_round.png", 20, 20 )
		yball.x = centerX + 50
		yball.y = centerY - 50
		yball:setFillColor(1,1,0)
		physics.addBody( yball, { radius = 10, bounce = 0.3, density = 1, friction = 0.3, radius = 10, filter = yBallFilter  } )			

		local bball = display.newImageRect( group, "images/kenney/physicsAssets/yellow_round.png", 20, 20 )
		bball.x = centerX + 150
		bball.y = centerY - 50
		bball:setFillColor(1, 0.398, 0)
		physics.addBody( bball, { radius = 10, bounce = 0.3, density = 1, friction = 0.3, radius = 10, filter = oBallFilter  } )			

		timer.performWithDelay( 1000, dropTraditionalBalls ) 
	end

	dropTraditionalBalls()
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
	local altName = "Collision Calculator"
	local description = ""
	return altName, description
end
function public.samplerSetup( group )
	print("Did sampler setup @ ", system.getTimer() )
end
function public.samplerCleanup( group )
	print("Did sampler cleanup @ ", system.getTimer() )
end

return public