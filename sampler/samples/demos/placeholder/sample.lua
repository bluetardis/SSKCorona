-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

function public.init( group )
end

function public.cleanup( )
end

function public.run( group )
	-- Localizations
	local easyIFC   = ssk.easyIFC
	easyIFC:quickLabel( group, "Content Coming This Week - 11 MAY 2015", centerX, centerY, nil, 10, _W_ )
end

function public.about()
	local altName = "Demos Coming Soon"
	local description = 
	'<font size="22" color="SteelBlue">Demos Coming Soon</font><br><br><br>' ..
    'The demos are not ready for distribution quite yet.  These will start<br>' ..
    'to roll out this week.<br><br>11 MAY 2015'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public