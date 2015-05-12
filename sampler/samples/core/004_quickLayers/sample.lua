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

	-- Without Layers (all in group)
	--
	local red = ssk.display.newCircle( group, centerX - 100, centerY - 10, { radius = 20, fill = _R_ } )	
	local green = ssk.display.newCircle( group, centerX - 10 - 100, centerY + 10, { radius = 20, fill = _G_ } )
	local blue = ssk.display.newCircle( group, centerX + 10 - 100, centerY + 10, { radius = 20, fill = _B_ } )

	-- Using Layers
	--
	local layers = ssk.display.quickLayers( group, "underlay", "content", "overlay")
	local red = ssk.display.newCircle( layers.overlay, centerX + 100, centerY - 10, { radius = 20, fill = _R_ } )	
	local green = ssk.display.newCircle( layers.content, centerX - 10 + 100, centerY + 10, { radius = 20, fill = _G_ } )
	local blue = ssk.display.newCircle( layers.underlay, centerX + 10 + 100, centerY + 10, { radius = 20, fill = _B_ } )

	-- Notice how order no longer affects which object is over which object?

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
	local altName = "Quick Layers"
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