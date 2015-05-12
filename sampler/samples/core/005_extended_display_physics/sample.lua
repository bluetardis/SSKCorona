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
	easyIFC:quickLabel( group, "2 Lines Using SSK", centerX - 100, centerY - 100 )

	newImageRect( group, centerX - 100 , centerY - 50,
		          "images/kenney/physicsAssets/yellow_round.png", {}, { radius = 20, bounce = 1, gravityScale = 0.2 } )	

	newImageRect( group, centerX - 100, centerY + 100, 
		          "images/kenney/physicsAssets/stone/square2.png", {}, { bodyType = "static" } ) 


	-- =============================================================
	-- Traditional Corona versions
	-- =============================================================

	easyIFC:quickLabel( group, "9 Lines Traditionally", centerX + 100, centerY - 100 )

	local ball = display.newImageRect( group, "images/kenney/physicsAssets/yellow_round.png", 40, 40 )
	ball.x = centerX + 100
	ball.y = centerY - 50
	physics.addBody( ball, { radius = 20, bounce = 1, radius = 20  } )
	ball.gravityScale = 0.2

	local block = display.newImageRect( group, "images/kenney/physicsAssets/stone/square2.png", 40, 40 )
	block.x = centerX + 100
	block.y = centerY + 100
	physics.addBody( block, "static" )

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
	local altName = "Easy Physics Bodies"
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