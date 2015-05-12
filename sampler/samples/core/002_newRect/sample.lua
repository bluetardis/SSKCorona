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
	local newRect = ssk.display.newRect
	local easyIFC   = ssk.easyIFC	

	-- =============================================================
	-- SSK Versions
	-- =============================================================

	easyIFC:quickLabel( group, "Each made with one line using SSK", centerX, centerY - 100 )

	-- 1
	newRect( group, 45, centerY - 50 )	 

	-- 2
	newRect( group, 95, centerY - 50, { fill = _R_ } )

	-- 3
	newRect( group, 145, centerY - 50, { radius = 10, fill = _B_, stroke = _W_, strokeWidth = 2 } )

	-- 4
	newRect( group, 195, centerY - 50, { size = 20, fill = _O_ } )

	-- 5
	newRect( group, 245, centerY - 50, { radius = 20, scale = 0.5, fill = _Y_ } )

	-- 6
	newRect( group, 295, centerY - 50, { xScale = 0.75, fill = _C_ } )

	-- 7
	newRect( group, 345, centerY - 50, { yScale = 0.75, rotation = 15, fill = _PURPLE_ } )

	-- 8
	newRect( group, 395, centerY - 50, { fill = { type = "image", baseDir = system.ResourceDirectory, filename = "images/water.png"} } )

	-- 9
	newRect( group, 445, centerY - 50, { 
		fill = { type = "gradient", color1 = { 1, 0, 0.4 }, color2 = { 1, 0, 0, 0.2 }, direction = "down" }, strokeWidth = 4, 
		stroke = { type = "gradient", color1 = { 0, 1, 0.4 }, color2 = { 0, 0, 1, 0.2 }, direction = "up" } } )


	-- =============================================================
	-- Traditional Corona versions
	-- =============================================================

	easyIFC:quickLabel( group, "Each made with N lines using traditional Corona", centerX, centerY )

	-- 1
	local tmp = display.newRect( group, 45, centerY + 50, 40, 40 )
	easyIFC:quickLabel( group, "1", 45, centerY + 100 )

	-- 2
	local tmp = display.newRect( group, 95, centerY + 50, 40, 40 )
	tmp:setFillColor( 1, 0, 0 )
	easyIFC:quickLabel( group, "2", 95, centerY + 100 )

	-- 3
	local tmp = display.newRect( group, 145, centerY + 50, 40, 40 )
	tmp:setFillColor( 0, 0, 1 )
	tmp:setStrokeColor( 1, 1, 1 )
	tmp.strokeWidth = 2
	easyIFC:quickLabel( group, "4", 145, centerY + 100 )

	-- 4
	local tmp = display.newRect( group, 195, centerY + 50, 20, 20 )
	tmp:setFillColor( 1, 0.398, 0 )
	easyIFC:quickLabel( group, "2", 195, centerY + 100 )

	-- 5
	local tmp = display.newRect( group, 245, centerY + 50, 40, 40 )
	tmp:setFillColor( 1, 1, 0 )
	tmp.xScale = 0.5
	tmp.yScale = 0.5
	easyIFC:quickLabel( group, "4", 245, centerY + 100 )

	-- 6
	local tmp = display.newRect( group, 295, centerY + 50, 40, 40 )
	tmp:setFillColor( 0, 1, 1 )
	tmp.xScale = 0.75
	easyIFC:quickLabel( group, "3", 295, centerY + 100 )
	
	-- 7
	local tmp = display.newRect( group, 345, centerY + 50, 40, 40 )
	tmp:setFillColor( 0.625, 0.125, 0.938 )
	tmp.yScale = 0.75
	tmp.rotation = 15
	easyIFC:quickLabel( group, "4", 345, centerY + 100 )

	-- 8
	local tmp = display.newRect( group, 395, centerY + 50, 40, 40 )
	tmp.fill = { type = "image", baseDir = system.ResourceDirectory, filename = "images/water.png"}
	easyIFC:quickLabel( group, "2", 395, centerY + 100 )
	
	-- 9
	local tmp = display.newRect( group, 445, centerY + 50, 40, 40 )
	tmp.fill = { type = "gradient", color1 = { 1, 0, 0.4 }, color2 = { 1, 0, 0, 0.2 }, direction = "down" }
	tmp.strokeWidth = 4
	tmp.stroke = { type = "gradient", color1 = { 0, 1, 0.4 }, color2 = { 0, 0, 1, 0.2 }, direction = "up" }
	easyIFC:quickLabel( group, "4", 445, centerY + 100 )

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
	local altName = "Extended newRect()"
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