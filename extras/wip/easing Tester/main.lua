-- =============================================================
-- main.lua
-- =============================================================
-- 
-- =============================================================
local getTimer  = system.getTimer
local strGSub   = string.gsub
local strSub    = string.sub
local strFormat = string.format
local mFloor = math.floor

_G.oniOS = ( system.getInfo("platformName") == "iPhone OS") 
_G.onAndroid = ( system.getInfo("platformName") == "Android") 
_G.onOSX = ( system.getInfo("platformName") == "Mac OS X")
_G.onWin = ( system.getInfo("platformName") == "Win")

io.output():setvbuf("no") -- Don't use buffer for console messages
--display.setStatusBar(display.TranslucentStatusBar)  -- Hide that pesky bar
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar


----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
require "ssk.loadSSK"
local composer 		= require( "composer" )


composer.gotoScene( "scene1" )
