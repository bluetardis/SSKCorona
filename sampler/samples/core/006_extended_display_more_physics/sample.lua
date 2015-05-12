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

	easyIFC:quickLabel( group, "Goofy Newton's Cradle: 17 Lines", centerX, centerY - 135, gameFont, 14 )


	local layers = ssk.display.quickLayers( group, "underlay", "ropes", "content", "overlay")

	local anchor = newRect( layers.content, centerX, centerY, {size = 10, fill = _O_ }, { bodyType = "static" } )

	local function enterFrame( self, event )
		if( self.removeSelf == nil ) then 
			Runtime:removeEventListener("enterFrame", self)
			return 
		end
		display.remove(self.rope)
		self.rope = display.newLine( layers.ropes, anchor.x, anchor.y, self.x, self.y )
		self.rope.strokeWidth = 2
	end
	local a = newImageRect( layers.content, centerX-100, centerY, 
		                    "images/kenney/physicsAssets/yellow_round.png", 
		                    { radius = 20,  enterFrame = enterFrame }, 
		                    { bounce = 1, linearDamping = -0.25 } )	
	
	local b = newImageRect( layers.content, centerX, centerY+100, 
							"images/kenney/physicsAssets/blue_round.png", 
							{ radius = 20, enterFrame = enterFrame }, 
							{ bounce = 1, density = 1, linearDamping = -0.25 } )
	
	local c = newImageRect( layers.content, centerX+100, centerY, 
							"images/kenney/physicsAssets/green_round.png", 
							{ radius = 20, enterFrame = enterFrame}, 
							{ bounce = 1, density = 1.5, linearDamping = -0.25 } )

	physics.newJoint( "distance", anchor, a, anchor.x, anchor.y, a.x, a.y )
	physics.newJoint( "distance", anchor, b, anchor.x, anchor.y, b.x, b.y )
	physics.newJoint( "distance", anchor, c, anchor.x, anchor.y, c.x, c.y )
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
	local altName = "Goofy Newton's Cradle"
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