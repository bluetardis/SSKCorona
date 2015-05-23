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
	public.isRunning = true		

	local integerIndexed = require "samples.askEd.compare_iterators.integer"
	local pairsIndexed = require "samples.askEd.compare_iterators.pairs"

	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random

	-- Locals
	local integerResults = {}
	local pairsResults = {}
	local testGroup

	-- Forward Declaration
	local doInteger
	local doPairs
	local showResults

	doInteger = function()
		if( not public.isRunning ) then return end
		testGroup = display.newGroup()
		group:insert( testGroup )
		-- Idle for a moment so results are not influenced by app activity
		nextFrame( 
			function() 
				if( not public.isRunning ) then return end
				integerResults = integerIndexed.run( testGroup )
				nextFrame( doPairs, 1000 )
			end, 1000 )
	end

	doPairs = function()
		if( not public.isRunning ) then return end
		display.remove( testGroup )
		testGroup = display.newGroup()
		group:insert( testGroup )
		-- Idle for a moment so results are not influenced by app activity
		nextFrame( 
			function() 
				if( not public.isRunning ) then return end
				pairsResults = pairsIndexed.run( testGroup )				
				nextFrame( showResults, 1000 )
			end, 1000 )
	end

	showResults = function()
		if( not public.isRunning ) then return end
		display.remove( testGroup )

		local curY = 65
		easyIFC:quickLabel( group, "'for i = 1, N do' Results:", left + 50, curY , "Consolas", 14, _W_, 0 )
		curY = curY + 20

		for i = 1, #integerResults do
			easyIFC:quickLabel( group, integerResults[i], left + 50, curY , "Consolas", 10, _W_, 0 )
			curY = curY + 15
		end

		curY = curY + 30

		easyIFC:quickLabel( group, "'for k,v in pairs(myTbl) do' Results:", left + 50, curY , "Consolas", 14, _W_, 0 )
		curY = curY + 20

		for i = 1, #pairsResults do
			easyIFC:quickLabel( group, pairsResults[i], left + 50, curY , "Consolas", 10, _W_, 0 )
			curY = curY + 15
		end

		table.dump( integerResults )
		table.dump( pairsResults )
		print("DONE")
	end


	doInteger()
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
	local altName = "Compare Iterators (JUN 2014)"
	local description = 
	'<font size="22" color="SteelBlue">Compare Interator Performances (JUN 2014)</font><br><br><br>' ..
    'From this post:<a href = "https://forums.coronalabs.com/topic/48804-comparing-methods-for-storingsearching-through-large-list-of-words/">CLICK HERE</a><br><br>' ..
    'and here too:<a href = "http://roaminggamer.com/2014/06/21/word-searches-tables-vs-sqlite3-in-corona-sdk/">CLICK HERE</a><br><br>'
	

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