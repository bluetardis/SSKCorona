-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

function public.init( group )
end

function public.cleanup( )
end

function public.run( group )
	
	-- SSK Forward Declarations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random

	-- Lua and Corona Forward Declarations
	local mRand 		= math.random
	local getTimer 		= system.getTimer

	local getTimer 		= system.getTimer

	local sqlDB 		= require "samples.askEd.wordLookup.sqlDB"
	local tableDB 		= require "samples.askEd.wordLookup.tableDB"

	collectgarbage( "collect" )
	local count1 = collectgarbage("count")
	sqlDB.initDB( "images/asked/words_81k.db" )
	local count2 = collectgarbage("count")
	tableDB.initDB( "images/asked/words_81k.tbl" )
	local count3 = collectgarbage("count")

	local startY = centerY - 50


	easyIFC:quickLabel( group, " words_81k.db memory size => " .. count2 - count1 .. " KB", centerX, startY + 20 , "Consolas", 12, _W_ )
	easyIFC:quickLabel( group, "words_81k.tbl memory size => " .. count3 - count2 .. " KB", centerX, startY + 40 , "Consolas", 12, _W_ )
	--print( " words_81k.db memory size => " .. count2 - count1 .. " KB")
	--print( "words_81k.tbl memory size => " .. count3 - count2 .. " KB")

	local searchMult = onSimulator and 100 or 5



	local function runTest1()
		sqlDB.test(group, startY + 60, 5 * searchMult)
	end

	local function runTest2()
		tableDB.test(group, startY + 80, 5  * searchMult)
	end

	local function runTest3()
		tableDB.test(group, startY + 100, 10000 * searchMult)
	end

	nextFrame(function() runTest1()  
		nextFrame( function() runTest2()
			nextFrame( function() runTest3() end ) 
			end ) 
		end )

end

function public.about()
	local altName = "Word Lookup (JUN 2014)"
	local description = 
	'<font size="22" color="SteelBlue">Word Lookup (JUN 2014)</font><br><br><br>' ..
    'From this post:<a href = "https://forums.coronalabs.com/topic/48804-comparing-methods-for-storingsearching-through-large-list-of-words/">CLICK HERE</a><br><br>'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public