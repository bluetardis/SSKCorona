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

require "scripts.sampler.menu"

--[[

--local full = ssk.display.newImageRect( nil, centerX, centerY, "images/asked/alcatraz.png", { w = 300, h = 240 } )

local function onTouch( self, event )
	if( event.phase == "began" ) then
		self:setFillColor(unpack(_G_))
		self.x0 = self.x 
		self.y0 = self.y
		self.isFocus = true
		display.currentStage:setFocus( self )
		self:toFront()
	elseif( self.isFocus ) then
		if( event.phase == "moved" ) then 
			self.x = self.x0 + event.x - event.xStart
			self.y = self.y0 + event.y - event.yStart
		else
			self:setFillColor(unpack(_W_))
			self.x = self.x0 
			self.y = self.y0
			self.isFocus = false
			display.currentStage:setFocus( nil )
		end
	else
		return false
	end
	return true
end


for i = 1, 6 do
	local piece = ssk.display.newImageRect( nil, centerX, centerY, "images/asked/alcatraz.png", { w = 300, h = 240, touch = onTouch } )
	local mask = graphics.newMask( "images/asked/puzzleA_mask" .. i .. ".png" )
	piece:setMask( mask )
end
--]]

