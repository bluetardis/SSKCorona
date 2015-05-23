-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Buttons Presets
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================

--
-- labelsInit.lua - Create Label Presets
--
local mgr = require "ssk.interfaces.buttons"
local imagePath = "presets/eater/images/"
local gameFont = gameFont or native.systemFontBold

local piecesDB = table.load( imagePath .. "piecesDB.txt", system.ResourceDirectory )
--local piecesDB = table.load( imagePath .. "piecesDB.txt" )
--table.print_r(piecesDB)

local strGSub = string.gsub
local strFind = string.find

local presetList = {}

----[[
-- ============================
-- ======= Generate Presets
-- ============================
for k,v in pairs(piecesDB) do
	local width 	= v.w
	local height 	= v.h
	local name 		= v.name
	local path 		= v.path
	local active 	= v.active
	local hover 	= v.hover

	local params 	= 
	{ 
	    labelFont 		= gameFont,
	    w 				= width,
	    h 				= height,
	    labelColor 		= _W_,
    }

    

    if( active ) then
    	print(path,name,k)
		params.unselImgSrc  	= imagePath ..path .. name .. ".png"
		params.selImgSrc    	= imagePath ..path ..k .. "_active.png"
		--table.dump(params)
		
   	elseif( hover ) then
   		print(path,name,k)
		params.unselImgSrc  	= imagePath ..path .. name .. ".png"
		params.selImgSrc    	= imagePath ..path ..k .. "_hover.png"
		--table.dump(params)
   	else
		--print(path,name,k)
		params.unselImgSrc  	= imagePath ..path .. name
		params.selImgSrc    	= imagePath ..path .. name
		--table.dump(params)
	end
	local presetName = strGSub( path .. k, "/", "_")
	mgr:addButtonPreset( presetName, params )
	--print("Added " .. presetName)
	presetList[#presetList+1] = presetName
end

--table.dump(presetList)

return presetList


--]]
--[[
-- ============================
-- ======= MISC
-- ============================

local params = 
{ 
	unselImgSrc  	= imagePath .. "toggle_off.png",
	selImgSrc    	= imagePath .. "toggle_on.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 16,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "filtertoggle", params )

local params = 
{ 
	labelColor			= _R_,
	labelSize			= 14,
	labelFont			= gameFont2,
	labelOffset         = {0,0},
	unselRectFillColor	= { 1, 1, 1, 0 },
	selRectFillColor	= { 1, 1, 1, 0 },
	emboss              = false,
	touchOffset         = {0,0},
}
mgr:addButtonPreset( "mmitemflipbutton", params )



local params = 
{ 
	labelColor			= _R_,
	labelSize			= 14,
	labelFont			= gameFont2,
	labelOffset         = {0,0},
	unselRectFillColor	= { 1, 1, 1, 0 },
	selRectFillColor	= { 1, 1, 1, 0 },
	emboss              = false,
	touchOffset         = {0,0},
	labelSize 			= 16,
	labelColor 			= _R_,

}
mgr:addButtonPreset( "filtersApplyCancelButton", params )


local params = 
{ 
	unselImgSrc  	= imagePath .. "button_pl.png",
	selImgSrc    	= imagePath .. "button_pl.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 16,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "mmbutton1", params )

local params = 
{ 
	unselImgSrc  	= imagePath .. "button_pl.png",
	selImgSrc    	= imagePath .. "button_pl.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 16,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "startbutton", params )

local params = 
{ 
	unselImgSrc  	= imagePath .. "signin_pl.png",
	selImgSrc    	= imagePath .. "signin_pl.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 16,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "signinbutton", params )


local params = 
{ 
	unselImgSrc  	= imagePath .. "fb.png",
	selImgSrc    	= imagePath .. "fb.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 12,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "signinfacebookbutton", params )

local params = 
{ 
	unselImgSrc  	= imagePath .. "google.png",
	selImgSrc    	= imagePath .. "google.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 12,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "signingooglebutton", params )


local params = 
{ 
	unselImgSrc  	= imagePath .. "close2.png",
	selImgSrc    	= imagePath .. "close2.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 18,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "mmclose", params )


local params = 
{ 
	labelColor			= {38/255,38/255,38/255,1},
	labelSize			= 24,
	labelFont			= gameFont,
	labelOffset         = {5,-1},
	unselRectFillColor	= { 1, 1, 1 },
	selRectFillColor	= { 0.8,  0.8,  0.8 },
	strokeWidth         = 0,
    --strokeColor         = {1,1,1,0.5},
	emboss              = false,
	touchOffset         = {0,0},
	labelHorizAlign 	= "left",
}
mgr:addButtonPreset( "mmsidebar", params )


local params = 
{ 
	labelColor			= {38/255,38/255,38/255,1},
	labelSize			= 24,
	labelFont			= gameFont,
	labelOffset         = {0,0},
	--unselRectFillColor	= { 1, 1, 1 },
	--selRectFillColor	= { 0.8,  0.8,  0.8 },
	unselImgSrc  		= imagePath .. "home/nav.png",
	selImgSrc    		= imagePath .. "home/nav_active.png",
	emboss              = false,
	touchOffset         = {0,0},
}
mgr:addButtonPreset( "mmbutton1", params )

--]]
