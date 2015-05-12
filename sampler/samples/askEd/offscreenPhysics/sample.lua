-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}


function public.init( group )
end

function public.cleanup( )
	public.isRunning = false

	local physics = require("physics")
	physics.setDrawMode( "normal" )
	physics.stop()
end

function public.run( group )
	public.isRunning = true		
	local physics = require("physics")
	physics.start()
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )

	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC

	local angle2Vector  = ssk.math2d.angle2Vector
	local vector2Angle  = ssk.math2d.vector2Angle
	local scaleVec      = ssk.math2d.scale
	local addVec        = ssk.math2d.add
	local subVec        = ssk.math2d.sub
	local getNormals    = ssk.math2d.normals
	local lenVec        = ssk.math2d.length
	local lenVec2       = ssk.math2d.length2
	local normVec       = ssk.math2d.normalize

	local mRand 		= math.random

	-- Locals
	--


	-- Group to contain all physics objects.
	local tmpGroup = display.newGroup()
	group:insert(tmpGroup)
	tmpGroup.x = centerX
	tmpGroup.y = centerY


	-- Collisions calculator (names are easier than numbers!)
	local myCC = ssk.ccmgr:newCalculator()
	myCC:addNames( "ball", "wall" )
	myCC:collidesWith( "ball", "wall"  )


	local top = newRect( tmpGroup, 0, 0 - 100, 
	                     { w = 300, h = 20, fill = _ORANGE },
	                     { calculator = myCC, colliderName = "wall", bodyType = "static",
	                       bounce = 1, density = 1  } ) 

	local bot = newRect( tmpGroup, 0, 0 + 100, 
	                     { w = 300, h = 20, fill = _ORANGE },
	                     { calculator = myCC, colliderName = "wall", bodyType = "static",
	                       bounce = 1, density = 1  } ) 

	local left = newRect( tmpGroup, 0 - 140 , 0, 
	                     { w = 20, h = 180, fill = _ORANGE },
	                     { calculator = myCC, colliderName = "wall", bodyType = "static",
	                       bounce = 1, density = 1  } ) 

	local right = newRect( tmpGroup, 0 + 140 , 0, 
	                     { w = 20, h = 180, fill = _ORANGE },
	                     { calculator = myCC, colliderName = "wall", bodyType = "static",
	                       bounce = 1, density = 1  } ) 

	local ball1 = newCircle( tmpGroup, 0, 0, 
	                     { radius = 10, fill = _Y_ },
	                     { calculator = myCC, colliderName = "ball", bounce = 1, density = 1  } )
	local ball2 = newCircle( tmpGroup, 0, 0, 
	                     { radius = 10, fill = _C_ },
	                     { calculator = myCC, colliderName = "ball", bounce = 1, density = 1  } )

	local angle = mRand( 1, 359 )
	local vec = angle2Vector( angle, true )
	vec = scaleVec( vec, 200 )
	ball1:setLinearVelocity( vec.x, vec.y  )

	local angle = mRand( 1, 359 )
	local vec = angle2Vector( angle, true )
	vec = scaleVec( vec, 200 )
	ball2:setLinearVelocity( vec.x, vec.y )


	local sizeUp
	local sizeDown

	sizeUp = function( )
	    transition.to( tmpGroup, { xScale = 4, yScale = 4, delay = 1000, time = 3000, onComplete = sizeDown } )
	end

	sizeDown = function( )
	    transition.to( tmpGroup, { xScale = 1, yScale = 1, delay = 1000, time = 3000, onComplete = sizeUp } )
	end

	sizeUp()	

end

function public.about()
	local altName = "Offscreen Physics (SEP 2014)"
	local description = 
	'<font size="22" color="SteelBlue">Offscreen Physics (SEP 2014)</font><br><br><br>' ..
    'From this post:<a href = "https://forums.coronalabs.com/topic/50898-physics-bodies-offscreen-culling">CLICK HERE</a><br><br>'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public