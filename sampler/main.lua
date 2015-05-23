-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- SSK Sampler
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

--profiler = require "Profiler"; 
--profiler.startProfiler({time = 1000, delay = 5000});

display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

--_G.gameFont = "KenVector Future"
--_G.gameFont = "Lucida Console"
--_G.gameFont = "AdelonSerial"
--_G.gameFont = "Stentiga"
gameFont = "Prime"
--gameFont = "Aileron Thin"


require "ssk.loadSSK"

--require "rgmeter.create"
require "presets.kenney.presets"

local sampleMgr =  require "scripts.sampler.manager"
sampleMgr.autoUpdate = false
require "scripts.sampler.menu"
