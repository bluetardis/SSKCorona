-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--io.output():setvbuf("no") -- Don't use buffer for console messages
--display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

-- SSK Forward Declarations
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC   	= ssk.easyIFC
local mRand 		= math.random

local angle2Vector 		= ssk.math2d.angle2Vector
local vector2Angle 		= ssk.math2d.vector2Angle
local scaleVec 			= ssk.math2d.scale
local addVec 			= ssk.math2d.add
local subVec 			= ssk.math2d.sub
local getNormals 		= ssk.math2d.normals
local lenVec			= ssk.math2d.length
local normVec			= ssk.math2d.normalize

-- Lua and Corona Forward Declarations
local mRand 			= math.random
local getTimer 			= system.getTimer

local app = {}

-- Initialize the app
--
function app.init( group )
end

-- Stop, cleanup, and destroy the app.;
--
function app.cleanup( )
	ignore( "enterFrame", app.world )
end

-- Run the Game
--
function app.run( group )

	app.world = display.newGroup()
	group:insert( app.world )

	-- Locals
	--
	local planetRadius = fullh/2

	app.world.x = centerX
	app.world.y = bottom + planetRadius/3

	-- Create Planet
	local planet = newImageRect( app.world, 0, 0, "images/asked/earth.png", { w = planetRadius * 2, h = planetRadius * 2 } )

	-- Create Clouds
	local i = 0
	while i < 360 do
		local vec = angle2Vector( i, true )
		local scale = planetRadius * mRand( 100, 130) / 90
		vec = scaleVec( vec, scale )
		print(scale, vec.x, vec.y)
		local cloudImg = "cloud" .. mRand(1,3) .. ".png"
		local scale = mRand(55,70)/100
		local tmp = display.newImageRect( app.world, "images/asked/cloud1.png", 129 * 0.5, 71 * 0.5 )
		tmp.x = vec.x
		tmp.y = vec.y
		tmp.rotation = i
		tmp:scale( scale, scale )
		i = i + mRand( 15, 25 )
	end
	

	-- Center the 'world' and rotate it
	app.world.rotRate = 0.05
	app.world.enterFrame = function( self, event )
		self.rotation = self.rotation - self.rotRate
		if(self.rotation < 0 ) then self.rotation = self.rotation + 360 end
	end
	listen( "enterFrame", app.world )
end

return app