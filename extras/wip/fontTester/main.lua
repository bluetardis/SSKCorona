-- Free font editing tool: http://sourceforge.net/projects/ttfedit/ 
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
require "ssk.loadSSK"
local multiscroller 	= require "multiscroller"
local createVScroller 	= multiscroller.createVScroller
-- IGNORE ABOVE ---------------------------------------------
-- IGNORE ABOVE ---------------------------------------------
-- IGNORE ABOVE ---------------------------------------------
local printString 	= " abcdefghABCDEFGH01234567890!@#$%^&*()[]- "
local fontSizes 	= { 10, 15, 20, 30, 40 }

local indexedFonts = {
	-- NO OTF/TTF EXTENSION HERE
	-- Note: Comments after names are OSs that work with this font name
	"OpenSans Bold",
	"OpenSans Bold Italic",

	"AvenirLTStd-Light", -- Android, iOS, Win(name as "Avenir LT Std 35 Light")
	"AvenirNextLTPro-Regular", -- Android, iOS, Win (name as "AvenirNext LT Pro 35 Regular"),
	"AvenirNextLTPro-BoldIt", -- Android, iOS, Win (name as "AvenirNext LT Pro 35 Medium")

	"Open Sans Condensed", -- Android, iOS, (same as: 'Open Sans Condensed Bold.ttf')
	"Open Sans",-- Android, iOS, Win
	"Oswald",-- Android, iOS, Win
}

--IGNORE BELOW ---------------------------------------------
--IGNORE BELOW ---------------------------------------------
--IGNORE BELOW ---------------------------------------------
local scroller = createVScroller( display.currentStage, { cTop = 0 } )
scroller:setActive( true )
local curY = top + 10
for i = 1, #indexedFonts do
	local line = display.newLine( scroller, left, curY, right, curY )
	line.strokeWidth = 2
	curY = curY + 5
	local fontName = display.newText( scroller, indexedFonts[i], left + 10, curY, "consolas", 20 )
	fontName.anchorX = 0
	curY = curY + fontName.contentHeight / 2
	fontName.y = curY
	curY = curY + fontName.contentHeight / 2 + 4

	local fontName2 = display.newText( scroller, indexedFonts[i], left + 10, curY, "none", 20 )
	fontName2:setFillColor(0,1,0,0.5)
	local fontName3 = display.newText( scroller, indexedFonts[i], left + 10, curY, indexedFonts[i], 20 )
	fontName2.anchorX = 0
	fontName3.anchorX = 0
	curY = curY + fontName2.contentHeight / 2
	fontName2.y = curY
	fontName3.y = curY
	curY = curY + fontName2.contentHeight / 2 + 4

	local line = display.newLine( scroller, left, curY, right, curY )
	line.strokeWidth = 1
	curY = curY + 5

	for j = 1, #fontSizes do
		print(i,j)

		local fontSample = display.newText( scroller, fontSizes[j] .. " - " .. printString, 
			left + 10, curY, indexedFonts[i], fontSizes[j] )
		fontSample.anchorX = 0
		curY = curY + fontSample.contentHeight / 2
		fontSample.y = curY
		curY = curY + fontSample.contentHeight / 2 + 4

	end
	local line = display.newLine( scroller, left, curY, right, curY )
	line.strokeWidth = 2
	curY = curY + 5
end

