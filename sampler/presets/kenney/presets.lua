-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
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
-- =============================================================
--
-- labelsInit.lua - Create Label Presets
--
local mgr = require "ssk.interfaces.buttons"
local imagePath = "presets/kenney/images/"
local gameFont = gameFont or native.systemFont


-- ============================
-- ========= Push BUTTON
-- ============================
local params = 
{ 
	labelColor			= {0,0,0,1},
	labelSize			= 12,
	labelFont			= gameFont,
	labelOffset         = {0,1},
	touchOffset         = {1,1},
	unselImgSrc  		= imagePath .. "blue_button.png",
	selImgSrc    		= imagePath .. "blue_button.png",
	emboss              = false,	
}
mgr:addButtonPreset( "kenney_blue", params )

local params = table.deepCopy( params )
params.unselImgSrc 	= imagePath .. "yellow_button.png"
params.selImgSrc 	= imagePath .. "yellow_button.png"
mgr:addButtonPreset( "kenney_yellow", params )

local params = table.deepCopy( params )
params.unselImgSrc 	= imagePath .. "green_button.png"
params.selImgSrc 	= imagePath .. "green_button.png"
mgr:addButtonPreset( "kenney_green", params )

local params = table.deepCopy( params )
params.unselImgSrc 	= imagePath .. "grey_button.png"
params.selImgSrc 	= imagePath .. "grey_button.png"
mgr:addButtonPreset( "kenney_grey", params )


-- ============================
-- ======= Back Button
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "back2.png",
	selImgSrc    = imagePath .. "back.png",
}
mgr:addButtonPreset( "kenney_back", params )

-- ============================
-- ======= Check Box (Toggle Button)
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "toggle_unsel.png",
	selImgSrc    = imagePath .. "toggle_sel.png",
}
mgr:addButtonPreset( "kenney_toggle", params )

local params = 
{ 
	unselImgSrc  = imagePath .. "green_circle.png",
	selImgSrc    = imagePath .. "green_circle.png",
	touchOffset  = {1,1},
	labelOffset  = { 1, 0 },
}
mgr:addButtonPreset( "buy_button", params )

local params = 
{ 
	unselImgSrc  = imagePath .. "grey_box.png",
	selImgSrc    = imagePath .. "grey_box.png",
	touchOffset  = {1,1},
	labelOffset  = { 1, 0 },
}
mgr:addButtonPreset( "grey_box", params )


local params = 
{ 
	unselImgSrc  = imagePath .. "green_box.png",
	selImgSrc    = imagePath .. "green_box.png",
	touchOffset  = {1,1},
	labelOffset  = { 1, 0 },
}
mgr:addButtonPreset( "green_box", params )

