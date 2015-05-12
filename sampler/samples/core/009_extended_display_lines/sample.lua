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
	local newLine 	= ssk.display.newLine
	local easyIFC   = ssk.easyIFC

	easyIFC:quickLabel( group, "Various Lines in 6 Lines Using SSK", centerX, centerY - 25, gameFont, 14 )

	newLine( group, 50, centerY, 450, centerY )
	newLine( group, 50, centerY + 20, 450, centerY + 20, { w = 2, fill = _R_ } )
	newLine( group, 50, centerY + 40, 450, centerY + 40, { w = 1, dashLen = 3, gapLen = 5, fill = _C_, style = "dashed" } )
	newLine( group, 50, centerY + 60, 450, centerY + 60, { radius = 3, gapLen = 5, fill = _O_, style = "dotted", stroke = _Y_, strokeWidth = 1} )
	newLine( group, 50, centerY + 80, 450, centerY + 80, { gapLen = 10, dashLen = 6, headSize = 4, fill = _O_, style = "arrows"} )
	newLine( group, 50, centerY + 100, 450, centerY + 100, { gapLen = 10, dashLen = 0, headSize = 4, fill = _C_, style = "arrows"} )

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
	local altName = "Various Lines"
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