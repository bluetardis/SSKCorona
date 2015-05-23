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
local imagePath2 = "presets/eater/images2/"
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
    }

    --local name2 = strGSub(name,".png", "")
    if( active ) then
    	--print(path,name,k)
		params.unselImgSrc  	= imagePath .. name .. ".png"
		params.selImgSrc    	= imagePath .. name .. "_active.png"
		--table.dump(params)
		
   	elseif( hover ) then
   		--print(path,name,k)
		params.unselImgSrc  	= imagePath  .. name .. ".png"
		params.selImgSrc    	= imagePath  .. name .. "_hover.png"
		--table.dump(params)
   	else
		--print(path,name,k)
		params.unselImgSrc  	= imagePath ..path .. name .. ".png"
		params.selImgSrc    	= imagePath ..path .. name .. ".png"
		--table.dump(params)
	end
	params.unselImgSrc = strGSub(params.unselImgSrc, ".png.png",".png")
	params.selImgSrc = strGSub(params.selImgSrc, ".png.png",".png")
	if(strFind(name, "feed")) then
		print(k,name,name2,path,imagePath)
		table.dump(params)
	end

	local presetName = strGSub( k, "/", "_")

	-- Mods for certain buttons
	--
	if( strFind( presetName, "home_") ) then
		params.labelOffset 		= { 0, 24 }
	    params.labelColor 		= _K_
    	params.labelSize 		= 12
	
	elseif( strFind( presetName, "item_") ) then
		params.labelOffset 		= { 0, 35 }

	end


	mgr:addButtonPreset( presetName, params )
	--print("Added " .. presetName)
	presetList[#presetList+1] = presetName
end

-- Custom presets
--


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
	labelColor 			= _W_,

}
mgr:addButtonPreset( "filtersApplyCancelButton", params )



local params = 
{ 
	unselImgSrc  	= imagePath2 .. "toggle_off.png",
	selImgSrc    	= imagePath2 .. "toggle_on.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 16,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "filtertoggle", params )


local params = 
{ 
	unselImgSrc  	= imagePath2 .. "button_pl.png",
	selImgSrc    	= imagePath2 .. "button_pl.png",
	strokeWidth  	= 0,
    labelColor 		= _K_,
    labelSize 		= 16,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "mmbutton1", params )

local params = 
{ 
	labelColor			= _W_,
	labelSize			= 24,
	labelFont			= gameFont,
	labelOffset         = {0,0},
	unselRectFillColor	= { 0,0,0,0 },
	selRectFillColor	= { 0,0,0,0 },
	strokeWidth         = 0,
    --strokeColor         = {1,1,1,0.5},
	emboss              = false,
	touchOffset         = {0,0},
}
mgr:addButtonPreset( "mmbutton2", params )

local params = 
{ 
	labelColor			= _DARKGREY_,
	selLabelColor		= _K_,
	labelSize			= 12,
	labelFont			= gameFont2,
	labelOffset         = {0,0},
	unselImgSrc  		= imagePath2 .. "nav.png",
	selImgSrc  		= imagePath2 .. "nav.png",
	--selImgSrc    		= imagePath2 .. "nav_active.png",
	emboss              = false,
	touchOffset         = {0,0},
}
mgr:addButtonPreset( "mmnav", params )


local params = 
{ 
	unselImgSrc  	= imagePath2 .. "button_pl.png",
	selImgSrc    	= imagePath2 .. "button_pl.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 16,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "startbutton", params )

local params = 
{ 
	unselImgSrc  	= imagePath2 .. "signin_pl.png",
	selImgSrc    	= imagePath2 .. "signin_pl.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 16,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "signinbutton", params )


local params = 
{ 
	unselImgSrc  	= imagePath2 .. "fb.png",
	selImgSrc    	= imagePath2 .. "fb.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 12,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "signinfacebookbutton", params )

local params = 
{ 
	unselImgSrc  	= imagePath2 .. "google.png",
	selImgSrc    	= imagePath2 .. "google.png",
	strokeWidth  	= 0,
    labelColor 		= _W_,
    labelSize 		= 12,
    labelFont 		= gameFont,
}
mgr:addButtonPreset( "signingooglebutton", params )

return presetList
