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

	-- Localizations
	local newSprite = ssk.display.newSprite
	local easyIFC   = ssk.easyIFC

	easyIFC:quickLabel( group, "Animated Sprite In One Line Using SSK", centerX, centerY - 50, gameFont, 14 )

	local tmp = newSprite( group, centerX, centerY - 10, "images/test/kenney_numbers.png", 
		                   {  frames = { 1,2,3,4,5,6,7,8,9,10 }, time = 1000, loopCount = 0 }, { autoPlay = true, scale = 2 } )


	easyIFC:quickLabel( group, "More Complex Sequence Data, Same Simple SSK", centerX, centerY + 60, gameFont, 14 )

	local sequenceData = 
	{
		{
		    name = 1, time = 500, loopCount = 2,
		    frames = { 1,2,3,4,5,6,7,8,9,9 },
		},
		{
		    name = 2, time = 500, loopCount = 3,
		    frames = { 1,2,3,4,5,6,7,8,9,7 },
		},
		{
		    name = 3, time = 500, loopCount = 4,
		    frames = { 1,2,3,4,5,6,7,8,9,8 },
		},
		{
		    name = 4, time = 500, loopCount = 5,
		    frames = { 1,2,3,4,5,6,7,8,9,6 },
		},
		{
		    name = 5, time = 500, loopCount = 6,
		    frames = { 1,2,3,4,5,6,7,8,9,4 },
		},
		{
		    name = 6, time = 500, loopCount = 7,
		    frames = { 1,2,3,4,5,6,7,8,9,1 },
		},
		{
		    name = 7, time = 500, loopCount = 8,
		    frames = { 1,2,3,4,5,6,7,8,9,10 },
		},
	}

	for i = 1, #sequenceData do
		local tmp = newSprite( group, centerX - 90 + (i-1) * 30, centerY + 100, 
			                   "images/test/kenney_numbers.png", sequenceData,
		                       { autoPlay = true, sequence = i, scale = 1.5 } )
	end

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
	local altName = "Extended Sprites"
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