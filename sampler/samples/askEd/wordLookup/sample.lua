-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.AskEd.wordLookup.app"

function public.init( group )
	game.init( group )
end

function public.cleanup( )
	game.cleanup( )
end

function public.run( group )
	
	-- SSK Forward Declarations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random

	-- Lua and Corona Forward Declarations
	local mRand 			= math.random
	local getTimer 			= system.getTimer

	game.run( group )


	local getTimer = system.getTimer

	local sqlDB 		= require "samples.AskEd.wordLookup.sqlDB"
	local tableDB 		= require "samples.AskEd.wordLookup.tableDB"

	collectgarbage( "collect" )
	local count1 = collectgarbage("count")
	sqlDB.initDB( "images/asked/words_81k.db" )
	local count2 = collectgarbage("count")
	tableDB.initDB( "images/asked/words_81k.tbl" )
	local count3 = collectgarbage("count")


	easyIFC:quickLabel( group, " words_81k.db memory size => " .. count2 - count1 .. " KB", centerX, top + 20 , "Consolas", 10, _W_ )
	easyIFC:quickLabel( group, "words_81k.tbl memory size => " .. count3 - count2 .. " KB", centerX, top + 40 , "Consolas", 10, _W_ )
	--print( " words_81k.db memory size => " .. count2 - count1 .. " KB")
	--print( "words_81k.tbl memory size => " .. count3 - count2 .. " KB")

	local function runTest1()
		sqlDB.test(group, top + 60, 1000)
	end

	local function runTest2()
		tableDB.test(group, top + 80, 1000)
	end

	local function runTest3()
		tableDB.test(group, top + 100, 100000)
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