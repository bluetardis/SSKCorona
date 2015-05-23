local iPad        = ( string.find( system.getInfo("architectureInfo"), "iPad" ) ~= nil )
local iPhone4     = ( string.find( system.getInfo("architectureInfo"), "iPhone4" ) ~= nil )
local iPhone5     = ( string.find( system.getInfo("architectureInfo"), "iPhone5" ) ~= nil )
local iPhone5s     = ( string.find( system.getInfo("architectureInfo"), "iPhone6" ) ~= nil )
local iPhone6     = ( string.find( system.getInfo("architectureInfo"), "iPhone7,2" ) ~= nil )
local iPhone6Plus = ( string.find( system.getInfo("architectureInfo"), "iPhone7,1" ) ~= nil )

local androidTablet = ( (system.getInfo( "androidDisplayWidthInInches" ) or 0) > 5 or
                        (system.getInfo( "androidDisplayHeightInInches" ) or 0) > 5 ) 
local isTablet = androidTablet or iPad -- or true

if( isTablet ) then
	application = {
			content = {
				width = 384,
				height = 512, 
				scale = "letterbox", -- editting setting
				fps = 30,
			},
	}
else -- Assume it is a phone
	application = {
			content = {
				width = 320,
				height = 480, 
				scale = "letterbox", -- editting setting
				fps = 30,
			},
	}
end
