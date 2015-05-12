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

	-- Localizations
	local newPointsLine 	= ssk.display.newPointsLine
	local newPoints 		= ssk.points.new
	local easyIFC 			= ssk.easyIFC
	local mRand				= math.random


	easyIFC:quickLabel( group, "Various Point Lines Using SSK", centerX, centerY - 75, gameFont, 14 )

	local reDrawLines
	local lastGroup

	reDrawLines = function()
		if( not public.isRunning ) then return end

		display.remove( lastGroup )

		lastGroup = display.newGroup()
		group:insert( lastGroup )

		local curY = 125

		local points = newPoints()
		for i = 1, 36 do
			points:add( 50 + (i-1) * 10, curY + mRand(-5,5) )
		end
		local tmp = newPointsLine( lastGroup, points  )
		
		local points = newPoints()	
		curY = curY + 20
		for i = 1, 36 do
			points:add( 50 + (i-1) * 10, curY + mRand(-5,5) )
		end
		local tmp = newPointsLine( lastGroup, points, { w = 2, fill = _R_ } )

		local points = newPoints()
		curY = curY + 20	
		for i = 1, 36 do
			points:add( 50 + (i-1) * 10, curY + mRand(-5,5) )
		end
		local tmp = newPointsLine( lastGroup, points, { w = 1, dashLen = 1, gapLen = 2, fill = _C_, style = "dashed" } )

		local points = newPoints()
		curY = curY + 20
		for i = 1, 36 do
			points:add( 50 + (i-1) * 10, curY + mRand(-5,5) )
		end
		local tmp = newPointsLine( lastGroup, points, { radius = 3, gapLen = 5, fill = _O_, style = "dotted", stroke = _Y_, strokeWidth = 1} )

		local points = newPoints()
		curY = curY + 20
		for i = 1, 36 do
			points:add( 50 + (i-1) * 10, curY + mRand(-5,5) )
		end
		local tmp = newPointsLine( lastGroup, points, { gapLen = 10, dashLen = 6, headSize = 4, fill = _O_, style = "arrowheads"} )

		local points = newPoints()
		curY = curY + 20
		for i = 1, 36 do
			points:add( 50 + (i-1) * 10, curY + mRand(-5,5) )
		end
		local tmp = newPointsLine( lastGroup, points, { fill = {1,1,1,0.2} } )
		local tmp = newPointsLine( lastGroup, points, { gapLen = 10, dashLen = 1, headSize = 4, fill = _C_, style = "arrowheads"} )

		timer.performWithDelay( 100, reDrawLines )
	end

	reDrawLines()
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
	local altName = "Point Lines"
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