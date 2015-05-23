-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Buttons Presets
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
--
-- DO NOT MODIFY THIS FILE.  MODIFY "data/buttons.lua" instead.
--
-- =============================================================
--
-- labelsInit.lua - Create Label Presets
--
local mgr = ssk.buttons

local imagePath = "data/rg_blueGelOverrideButtons/images/"

local gameFont = gameFont or native.systemFont


-- ============================
-- ========= DEFAULT BUTTON
-- ============================
local default_params = 
{ 
	font				= gameFont,
	textColor			= _WHITE_,
	fontSize			= 16,
	textFont			= native.systemFontBold,
	unselRectFillColor	= {24,112,143},
	selRectFillColor	= {31,134,171},
	strokeWidth         = 1,
    strokeColor         = {1,1,1,128},
	textOffset          = {0,1},
	emboss              = false,	
}
mgr:addPreset( "default", default_params )


-- ============================
-- ======= Default Check Box (Toggle Button)
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "check.png",
	selImgSrc    = imagePath .. "checkOver.png",
	strokeWidth  = 0,
    strokeColor  = {0,0,0,0},
}
mgr:addPreset( "defaultcheck", params )

-- ============================
-- ======= Default Radio Button 
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "radio.png",
	selImgSrc    = imagePath .. "radioOver.png",
	strokeWidth  = 0,
    strokeColor  = {0,0,0,0},
}
mgr:addPreset( "defaultradio", params )


-- ============================
-- ======= Default Horizontal Slider
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "trackHoriz.png",
	selImgSrc    = imagePath .. "trackHorizOver.png",
	unselKnobImg = imagePath .. "thumbHoriz.png",
	selKnobImg   = imagePath .. "thumbHorizOver.png",
	kw           = 29,
	kh           = 19,
	strokeWidth  = 0,
    strokeColor  = {0,0,0,0},
}
mgr:addPreset( "defaultslider", params )

-- ============================
-- ================== RG BUTTON
-- ============================
local params = 
{ 
	unselImgSrc  = imagesDir .. "badges/rg.png",
	selImgSrc    = imagesDir .. "badges/rg.png",
}
mgr:addPreset( "RGButton", params )

-- ============================
-- ======= Corona  BADGE/BUTTON 150 x 144
-- ============================
local params = 
{ 
	unselImgSrc  = imagesDir .. "badges/coronaBadge_smallt.png",
	selImgSrc    = imagesDir .. "badges/coronaBadge_smallt.png",
}
mgr:addPreset( "CoronaButton", params )


-- ============================
-- ======= Corona  BADGE/BUTTON 75 x 72
-- ============================
params.buttonOverlayRectColor = nil
params.unselImgSrc = imagesDir .. "badges/coronaBadge_tinyt.png"
params.selImgSrc   = imagesDir .. "badges/coronaBadge_tinyt.png"
params.unselRectEn = false
params.selRectEn   = false
params.strokeWidth = 0
mgr:addPreset( "CoronaButtonTiny", params )

