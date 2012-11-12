-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- main.lua
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

print("\n\n\n****************************************************************")
print("*********************** \\/\\/ main.cs \\/\\/ **********************")
print("****************************************************************\n\n")
io.output():setvbuf("no") -- Don't use buffer for console messages

----------------------------------------------------------------------
--	1.							GLOBALS								--
----------------------------------------------------------------------
require( "ssk.globals" ) -- Load Standard Globals (DO NOT MODIFY)
require( "data.globals" ) -- Override settings  from ssk.globals here.

----------------------------------------------------------------------
-- 2. LOAD MODULES													--
----------------------------------------------------------------------
local storyboard = require "storyboard"

-- PHYSICS (Configure in ssk.globals)
if( usesPhysics ) then
	local physics = require("physics")
	physics.start()
	physics.setGravity( gravityVector[1], gravityVector[2] )
	physics.setDrawMode( physicsRenderMode )
end

-- SSKCorona Libraries
require("ssk.loadSSK")

----------------------------------------------------------------------
-- 3. ONE-TIME INITIALIZATION										--
----------------------------------------------------------------------
--
-- Cofigure various aspects of your game based on settings in 
-- ssk.globals as well as other details (simulator vs device).
--
----------------------------------------------------------------------

-- Show device status bar
display.setStatusBar(display.HiddenStatusBar)

-- Enable Multitouch
if( enableMultiTouch ) then 
	system.activate("multitouch")
end

-- Configure Font(s)
--
-- Note: Names may be different on simulator and on device due to way
-- Windows/OS X/iOS/Android differ in loading fonts
--
-- Note: You may need to extend this section, depending on how you use
-- fonts in your game.
--
if(onSimulator) then
	gameFont = "Abscissa"
	helpFont = "Courier New"
else
	gameFont = "Abscissa"
	helpFont = "Courier New"
end

-- Load User Settings (Put your custom settings in these files)
--
-- Note: These are loaded first, to allow you to supercede SSKCorona
-- presets if you want.
--
require("data.buttons")
require("data.labels")
require("data.sounds")

-- Load SSK Presets (Buttons, Labels, and Sounds)
-- 
-- Note: Do not modify these files.  Add custom settings in the user files above instead.
--
local soundsInit = require("ssk.presets.sounds")
local labelsInit = require("ssk.presets.labels")
local buttonsInit = require("ssk.presets.buttons")

local player require("data.player")

----------------------------------------------------------------------
-- 4. LOAD SPRITE / SET UP ANIMATIONS								--
----------------------------------------------------------------------
--
-- EFM WORK IN PROGRESS
--
----------------------------------------------------------------------
-- Load sprites and set up animations
--ssk.easysprites.createSpriteSet( "letterTiles", imagesDir .. "letterTiles.png", 80, 80, 54 )

----------------------------------------------------------------------
-- 5. LOAD BEHAVIORS												-- 
----------------------------------------------------------------------
--
-- EFM WORK IN PROGRESS
--
----------------------------------------------------------------------
--[[ 
local behaviorsList = 
{

	"mover_faceTouch",
	"mover_faceTouchFixedRate",
	"mover_moveToTouchFixedRate",
	"mover_moveToTouch",
	"mover_dragDrop",
--	"mover_onTouch_applyForwardForce",
--	"mover_onTouch_applyContinuousForce",
--	"mover_onTouch_applyTimedForce",
	
	"onCollisionEnded_ExecuteCallback",
	"onCollision_ExecuteCallback",

--	"onCollisionEnded_PrintMessage",
--	"onCollision_PrintMessage",
--	"onPostCollision_PrintMessage",
--	"onPreCollision_PrintMessage",
	
--	"physics_hasForce",

}

for k,v in ipairs( behaviorsList ) do
	require( "ssk.behaviors.b_" .. v )
end
 --]]

----------------------------------------------------------------------
-- 6. CALCULATE COLLISION MATRIX									-- 
----------------------------------------------------------------------
--
-- Set up a global collision calculator (here) if you have only
-- one set of collision settings.  If, on the other hand, you have
-- different settings for different parts of your game, create
-- and configure collision calulculators as you need them.
--
----------------------------------------------------------------------
--[[
_G.myCC = ssk.ccmgr:newCalculator()
_G.myCC:addName("player")
_G.myCC:addName("enemy")
_G.myCC:addName("playerBullet")
_G.myCC:addName("enemyBullet")
_G.myCC:collidesWith("player", "enemy", "enemyBullet")
_G.myCC:collidesWith("playerBullet", "enemy")
_G.myCC:dump()
--]]

----------------------------------------------------------------------
-- 7. CONFIGURE SOUND & MUSIC										--
----------------------------------------------------------------------
--  This section assumes that the current player has certain
--  settings.  To modify these settings edit "data/player.lua"
--
--  Starts a sound track if the player has music enabled.
----------------------------------------------------------------------
ssk.sounds:setEffectsVolume(currentPlayer.effectsVolume)

ssk.sounds:setMusicVolume(currentPlayer.musicVolume)

if(currentPlayer.musicEnabled) then
	ssk.sounds:play("bouncing")
end

----------------------------------------------------------------------
-- 8. DEBUG STUFF													--
----------------------------------------------------------------------
-- 
-- This section is nice to have while developing, but should be disabled
-- for production releases.
--
----------------------------------------------------------------------

-- Print all known (loaded and useable) font names
--[[
print("\nFonts found on this system:" )
local sysFonts = native.getFontNames()
for k,v in pairs(sysFonts) do print(v) end
--]]

-- Print information about the design and device resolution
ssk.misc.dumpScreenMetrics()

-- Print the default physics paramaters used by ssk.display builder functions
--[[
ssk.display.listDPP()
--]]


print("\n****************************************************************")
print("*********************** /\\/\\ main.cs /\\/\\ **********************")
print("****************************************************************")
----------------------------------------------------------------------
--								LOAD FIRST SCENE					--
----------------------------------------------------------------------
storyboard.gotoScene( "s_SplashLoading" )
--storyboard.gotoScene( "s_MainMenu" )
--storyboard.gotoScene( "s_Credits" )
--storyboard.gotoScene( "s_Options" )
--storyboard.gotoScene( "s_Join_2P_Auto" )
--storyboard.gotoScene( "s_Host_2P_Auto" )
--storyboard.gotoScene( "s_NotMe" )
--storyboard.gotoScene( "s_NotMeDialog" )
--storyboard.gotoScene( "s_PlayGUI" )