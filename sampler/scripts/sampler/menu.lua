-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Corona SSK - Sampler Kit Menu
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC 		= ssk.easyIFC
local rgFiles 		= ssk.rgFiles
local oleft 		= ssk.misc.oleft
local oright 		= ssk.misc.oright
local otop 			= ssk.misc.otop
local obottom 		= ssk.misc.obottom
local ovcenter 		= ssk.misc.ovcenter
local ohcenter 		= ssk.misc.ohcenter

local createVScroller 		= ssk.multiScroller.createVScroller
local addContentTouch 		= ssk.multiScroller.addContentTouch
local addContentTouch2 		= ssk.multiScroller.addContentTouch2
local addOnScreenExecute 	= ssk.multiScroller.addOnScreenExecute
local createHScroller 		= ssk.multiScroller.createHScroller

local getTimer 		= system.getTimer


local buttonScale = 1.08

-- Set up Rendering Layers
--
local layers = ssk.display.quickLayers( screenGroup, "underlay", "content", { "background", "menu", }, "currentSample", "overlay", "description" )
layers.overlay.alpha = 0


-- Draw Background
--
newRect( layers.background, centerX, centerY, { w = fullw, h = fullh, fill = hexcolor("#154088")} )

-- Discover Samples and Draw Menu & Interface
--
local sampleMgr =  require "scripts.sampler.manager"
--sampleMgr.autoUpdate = true
sampleMgr.discover()

local mlText = require "scripts.sampler.mltext.mltext"

local categoryButton, categoryLabel
local sampleButton, sampleLabel
local buyButton
local helpButton
local runButton, lastRunButton
local homeButton
local createCategoryButton
local createSampleButton
local createBuyButton
local createRunButton
local createLastRunButton
local createOptionButtons

local isAlreadyRunning = false

local lastSamplePath
local samplePathLabel
local fpsButton
local memButton
local fpsMeter
local memMeter
local videoButton
local descriptionButton

local onVideo
local onDescription

local function onVideo( event )
	system.openURL( event.target.lastVideo )
end

local function onDescription( event )
	if( not event.target.lastDescr or string.len(event.target.lastDescr) == 0 ) then return end
	fpsMeter.alpha = 0
	memMeter.alpha = 0

	layers.description.alpha = 0
	transition.to( layers.description, { alpha = 1, time = 250, transition = easing.inOutQuad })

	layers:purge( "description" )
	newImageRect( layers.description, centerX, centerY, "images/fillW.png", { w = fullw, h = fullh, fill = _G_, alpha = 0.2, touch = function() return true end  } )

	-- draw background
	newImageRect( layers.description, left, top, "images/interface/menu/ul_descr.png", { w = 5, h = 12, anchorX = 0, anchorY = 0 } )
	newImageRect( layers.description, right, top, "images/interface/menu/ul_descr.png", { w = 5, h = 12, xScale = -1, anchorX = 0, anchorY = 0 } )
	newImageRect( layers.description, left, bottom, "images/interface/menu/ul_descr.png", { w = 5, h = 12, yScale = -1, anchorX = 0, anchorY = 0 } )
	newImageRect( layers.description, right, bottom, "images/interface/menu/ul_descr.png", { w = 5, h = 12, xScale = -1, yScale = -1, anchorX = 0, anchorY = 0 } )
	newImageRect( layers.description, centerX, top, "images/interface/menu/top_descr.png", { w = fullw - 6, h = 12, anchorY = 0 } )
	newImageRect( layers.description, centerX, bottom, "images/interface/menu/top_descr.png", { w = fullw - 6, h = 12, yScale = -1, anchorY = 0 } )
	newImageRect( layers.description, left, centerY, "images/interface/menu/left_descr.png", { w = 5, h = fullh-24, anchorX = 0} )
	newImageRect( layers.description, right, centerY, "images/interface/menu/left_descr.png", { w = 5, h = fullh-24, anchorX = 0, xScale = -1} )
	newImageRect( layers.description, centerX, centerY, "images/interface/menu/mid.png", { w = fullw - 6, h = fullh-24 } )

	local scroller = createVScroller( layers.description, { cTop = 10 } )

	local function onBack( event)
		layers:purge( "description" )
		fpsMeter.alpha = 1
		memMeter.alpha = 1
		return true
	end
	easyIFC:presetPush( layers.description, "kenney_back", right-14, top+14, 20, 20, "", onBack )


	local myMLString = '<font size="22" color="ForestGreen">This is a test of</font><br><br>' ..
                   	'MLText by <a href = "www.roaminggamer.com">Roaming Gamer, LLC.</a><br><br>' ..
				   	'<font face = "Stentiga" size="26" color="red">This is some red size 26 Stentiga!</font><br><br>' --..
				   	--'And an image of a <a href = "www.roaminggamer.com"><img src="images/water.png" alt="Smiley face" height="40" width="40" yOffset = "-12">Joker!</a>'


	-- Base settings for text without <font> statements.
	local params =
		{
			font 		= gameFont, --"AdelonSerial",
			fontSize 	= 11,
			fontColor 	= _K_,
			spaceWidth = 13,
			lineHeight = 15,
			linkColor1 = {0,0,1},
			linkColor2 = _PURPLE_,
		}

	local tmp = mlText.newMLText( event.target.lastDescr, 10, 0, params )
	tmp.anchorY = 0
	scroller:insert(tmp)
end

local lastExample = table.load("lastExample.json") or {}

local function unloadLast()
	if( lastSamplePath ) then
		--print("Unloading: " .. lastSamplePath .. " @ " .. system.getTimer() )
		local sample = require( lastSamplePath )
		if( sample.samplerCleanup ) then sample.samplerCleanup() end
		if( sample.cleanup ) then sample.cleanup() end
		-- If path is supplied, completely unload the module
		package.loaded[lastSamplePath] = nil
		_G[lastSamplePath] = nil	
	end
end	

local function onCategory( event )
	local target = event.target
	local text = target:getText()
	local samples = sampleMgr.getSamples( text )
	--table.dump( samples,nil,text )
	createSampleButton( target.parent, centerX, centerY + 5, samples )
	categoryLabel.text = table.indexOf(target.categories, text) .. " of " .. #target.categories

	if( samplePathLabel ) then samplePathLabel:update() end
end

local function onSample( event )
	local target = event.target
	local text = target:getText()
	sampleLabel.text = table.indexOf(target.samples, text) .. " of " .. #target.samples

	if( samplePathLabel ) then samplePathLabel:update() end
end


local function onCloseSample( event )
	layers.overlay.alpha = 0
	homeButton:disable()
	unloadLast()
	layers:purge("currentSample")	
	layers.content.x = 0
	transition.to( layers.content, { alpha = 1, onComplete = onComplete, transition = easing.inOutQuad, time = 250 } )	
	isAlreadyRunning = false
end

local function onBuy( event )
end


local function onRun( event )
	if( isAlreadyRunning ) then return end
	local category = categoryButton:getText()
	--category = string.gsub( category, " ", "_" )
	local sample = sampleButton:getText()
	--local samplePath = "samples." .. category .. "." .. sample .. ".sample"
	local samplePath = sampleMgr.getSamplePath( category, sample )
	if( not samplePath ) then return end
	lastSamplePath = samplePath
	--print(samplePath)
	local sample = require( samplePath )	
	if( sample.init ) then sample.init( layers.currentSample ) end
	if( sample.samplerSetup ) then sample.samplerSetup() end
	local function onComplete()
		if( sample.run ) then 
			sample.run( layers.currentSample ) 
			transition.to( layers.overlay, {alpha = 1, time = 250 } )
			homeButton:enable()
			layers.content.x = -1000000
			isAlreadyRunning = true
		else
			onCloseSample()
			isAlreadyRunning = false
		end
	end

	lastExample.path = samplePath
	table.save( lastExample, "lastExample.json")

	transition.to( layers.content, { alpha = 0, onComplete = onComplete, transition = easing.inOutQuad, time = 250 } )	
end

local function onRunLast( event )
	if( isAlreadyRunning ) then return end
	local samplePath = lastExample.path
	if( not samplePath ) then return end
	lastSamplePath = samplePath
	print(samplePath)
	local sample = require( samplePath )	
	if( sample.init ) then sample.init( layers.currentSample ) end
	if( sample.samplerSetup ) then sample.samplerSetup() end
	local function onComplete()
		if( sample.run ) then 
			sample.run( layers.currentSample ) 
			transition.to( layers.overlay, {alpha = 1, time = 250 } )
			homeButton:enable()
			layers.content.x = -1000000
			isAlreadyRunning = true
		else
			onCloseSample()
			isAlreadyRunning = false
		end
	end

	transition.to( layers.content, { alpha = 0, onComplete = onComplete, transition = easing.inOutQuad, time = 250 } )	
end

createCategoryButton = function (  group, x, y )
	display.remove( categoryButton )
	local categories = sampleMgr.getCategories()
	table.print_r( categories )
	for i = 1, #categories do
		--categories[i] = string.gsub( categories[i], "_", " " )
	end
	categoryButton = easyIFC:presetTableRoller( group, "kenney_yellow", x, y, 190*buttonScale, 45*buttonScale, categories, onCategory )
	categoryButton.categories = categories
	categoryLabel = easyIFC:quickLabel( group, 1 .. " of " .. #categories , categoryButton.x + categoryButton.contentWidth/2 + 10, categoryButton.y, gameFont, 12, _W_, 0 )
end

createSampleButton = function ( group, x, y, samples )
	display.remove( sampleButton )
	sampleButton = easyIFC:presetTableRoller( group, "kenney_yellow", x, y, 190*buttonScale, 45*buttonScale, samples, onSample )
	sampleButton.samples = samples
	if( not sampleLabel ) then 
		sampleLabel = easyIFC:quickLabel( group, 1 .. " of " .. #samples , sampleButton.x + sampleButton.contentWidth/2 + 10, sampleButton.y, gameFont, 12, _W_, 0 )
	else
		sampleLabel.text = 1 .. " of " .. #samples
	end	
end

createBuyButton = function( group, x , y, buyLink  )
	display.remove( buyButton )
	buyButton = easyIFC:presetPush( group, "buy_button", x, y, 25, 25, "$", onBuy, { labelSize = 12 } )
	buyButton.buyLink = buyLink
	buyButton.isVisible = false
end

createRunButton = function (  group, x, y )
	display.remove( runButton )
	runButton = easyIFC:presetPush( group, "kenney_green", x, y, 95, 22.5, "Run", onRun )
	local categories = sampleMgr.getCategories()
	--table.print_r( categories )
end

createLastRunButton = function (  group, x, y )
	display.remove( lastRunButton )
	lastRunButton = easyIFC:presetPush( group, "kenney_blue", x, y, 95, 22.5, "Last", onRunLast )	
	lastRunButton.isVisible = false
end

createHB = function (  group )
	homeButton = easyIFC:presetPush( group, "kenney_back", right-14, top+14, 24, 24, "", onCloseSample )
	homeButton:disable()
end

createHelpButton = function (  group )
	help = easyIFC:presetPush( group, "green_box", right-14, top+14, 24, 24, "?", onDescription, { labelColor = _W_, labelSize = 14 } )
	help.lastDescr =  
		'<font size="18" color="SteelBlue">What Is SSK?</font><br><br>' ..		
		'<font color="ForestGreen">SSK</font>is short for "Super Starter Kit".  It is a collection of libraries and modules (mostly)<br>' ..
		'written by "The Roaming Gamer".  It is provided free of charge for use in app and game<br>' ..
		'development.  This library is designed to simplify development while reducing the amount<br>' ..
		'of code you need to write.<br><br>' ..
		'To get a sense of how to use the library and how much coding it will save you, please<br>' ..
		'take a look at the "core" samples.<br><br>' ..
		'<font size="10" color="Tan">(Please note, some elements of SSK have been derived from work by other authors.<br>' ..
		'In each case, credit [and a license statement where required] has been provided in the code.)</font><br><br>' ..

		'<font size="18" color="SteelBlue">About The Sampler</font><br><br>' ..
		'The sampler can be run in the (OS X and Windows) simulators as well as on Android<br>' .. 
		'and iOS devices.<br>' ..
		'The samples themselves have been split into five categories:<br><br>' ..
		'1. <font color="ForestGreen">askEd</font>These are samples derived from my answers to interesting forums questions.<br><br>' ..
		
		'2. <font color="ForestGreen">core</font>These samples provide usage examples for core SSK features.  If you are trying<br>' ..
		'to learn how to use SSK, you should take a look at these.<br><br>' ..
		
		'3. <font color="ForestGreen">demos</font>These samples demonstrate free and paid modules developed solve specific<br>' ..
		'app & game development problems.<br><br>' ..
		
		'4. <font color="ForestGreen">game_guts</font>These samples show how to make interesting game mechanics.  This<br>' ..
		'set of samples will grow over time, so be sure to check back!<br><br>' ..
		
		'Within each category you will find an ever growing list of samples.<br><br>' ..

		'<font size="18" color="SteelBlue">Running The Sampler</font><br><br>' ..
		'<a href = "http://bit.ly/ssk_run_sampler">Please click here to watch an (external) video that talks about how the sampler works.</a><br><br>' ..

		'<font size="18" color="SteelBlue">Extracting SSK Sampler Code</font><br><br>' ..
		'You should feel free to extract code from the SSK samples and to use it in your own<br>' ..
		'apps and games.  This video will show you how:<br>' ..
		'<a href = "http://bit.ly/ssk_extracting_samples">Please click here to watch an (external) video that talks about how to extract sample code.</a><br><br>' ..

		'<font size="18" color="SteelBlue">Installing SSK and using it in your projects.</font><br><br>' ..
		'Besides desmonstrating the how and why of using SSK, the sampler is here to encourage<br>'..
		'you to use SSK.  This document will show you how:<br>' ..
		'<a href = "http://bit.ly/ssk_users_guide">Please click here to download a PDF.</a><br><br>' ..

		'<font size="18" color="SteelBlue">Thank You</font><br><br>' ..
		'Thank you very much for downloading and using the sampler.  If you want to give me<br>'..
		'feedback, please email me at <font color="ForestGreen">roaminggamer@gmail.com</font> and add the words:<br>' ..
		'<font size="10" color="Tan">SSK Sampler</font> to the title of your e-mail.<br><br><br>  '
		


end

createOptionButtons = function (  group )
	local function onFPS( event )
		if( not fpsMeter ) then return end
		fpsMeter.isVisible = event.target:pressed()
	end
	fpsButton = easyIFC:presetToggle( group, "kenney_toggle", centerX - 90, centerY + 112, 24, 24, "", onFPS )
	local tmp = easyIFC:quickLabel( group, "Show FPS" , fpsButton.x + fpsButton.contentWidth/2 + 5, fpsButton.y, gameFont, 10, _W_, 0 )	

	local function onMem( event )
		if( not memMeter ) then return end
		memMeter.isVisible = event.target:pressed()
	end

	memButton = easyIFC:presetToggle( group, "kenney_toggle", centerX + 30, centerY + 112, 24, 24, "", onMem )
	local tmp = easyIFC:quickLabel( group, "Show Mem" , memButton.x + memButton.contentWidth/2 + 5, memButton.y, gameFont, 10, _W_, 0 )	

	--nextFrame( function() fpsButton:toggle(); memButton:toggle() end )


	videoButton = easyIFC:presetPush( group, "kenney_grey", centerX-55, centerY + 145, 95, 22.5, "Watch Video", onVideo, {labelSize = 10, labelColor =  _PURPLE_ } )
	descriptionButton = easyIFC:presetPush( group, "kenney_grey", centerX+55, centerY + 145, 95, 22.5, "View Details", onDescription, {labelSize = 10, labelColor =  _ORANGE_ } )
	--videoButton:disable()
	--descriptionButton:disable()

end

--[[
local categories = sampleMgr.getCategories()
print("Got categories")
table.print_r( categories )
local samples = sampleMgr.getSamples( "core" )
print("Got samples")
table.print_r( samples )
local path = sampleMgr.getSamplePath( "core", "SSK Globals" )
--]]
----[[
createCategoryButton( layers.menu, centerX, centerY - 50 )
local category = categoryButton:getText()
--category = string.gsub( category, " ", "_" )
local samples = sampleMgr.getSamples( category )
--table.dump(samples,nil,category)
createSampleButton( layers.menu, centerX, centerY + 5, samples )
createRunButton( layers.menu, centerX, centerY + 80, samples )
--createLastRunButton( layers.menu, centerX-55, centerY + 80, samples )
createOptionButtons(layers.menu)

createBuyButton( layers.menu, centerX - 120, centerY + 5 )

createHB( layers.overlay )
createHelpButton( layers.menu )


--samplePathLabel = easyIFC:quickLabel( layers.menu, "" , centerX, centerY + 50, "Lucida Console", 12, _W_ )
samplePathLabel = easyIFC:quickLabel( layers.menu, "" , centerX, centerY + 50, gameFont, 12, _W_ )
samplePathLabel.update = function( self )
	local category = categoryButton:getText()
	--category = string.gsub( category, " ", "_" )
	local sample = sampleButton:getText()
	local samplePath = sampleMgr.getSamplePath( category, sample )
	self.text = string.gsub( samplePath, "%.sample", "" )

	local lastDescr, lastVideo, buyLink = sampleMgr.getDescriptionVideo( samplePath )
	if( lastDescr and lastDescr:len() > 0 ) then 
		descriptionButton.lastDescr = lastDescr
		descriptionButton:enable()
	else 
		descriptionButton:disable()
	end

	if( lastVideo and lastVideo:len() > 0 ) then 
		videoButton.lastVideo = lastVideo
		videoButton:enable()
	else 
		videoButton:disable()
	end


	if( buyButton and buyLink and buyLink:len() > 0 ) then 
		buyButton.buyLink = buyLink
		buyButton:enable()
		--buyButton.isVisible = true
	else 
		buyButton:disable()
		--buyButton.isVisible = false
	end

end
samplePathLabel:update()

easyIFC:quickLabel( layers.menu, "SSK Sampler (" .. sampleMgr.getSamplesCount() .. " samples)" , centerX, centerY - 110, gameFont, 22, _W_ )
local ver = easyIFC:quickLabel( layers.menu, "SSK Version: " .. ssk.getVersion() , right - 10, bottom - 5, gameFont, 9, _W_, 1 )
ver.anchorY = 1
easyIFC:quickLabel( layers.menu, "by: Roaming Gamer, LLC." , centerX, centerY - 88, gameFont, 10, _W_ )
--]]

local function onKey( event )
	--table.dump(event)
	if( event.phase == "up" and event.descriptor == "r" and not event.isCtrlDown ) then
		onRunLast()
	end
end; 

nextFrame( function() listen( "ON_KEY", onKey ) end, 30 )

display.setStatusBar( display.HiddenStatusBar )


-- Create FPS Meter
--
fpsMeter = display.newGroup()
fpsMeter.back = newImageRect( fpsMeter, left + 2, top + 2, "images/interface/menu/box.png", { w = 195, h = 49, scale = 0.5, anchorX = 0, anchorY = 0 } )
fpsMeter.lastTime = getTimer()
fpsMeter.label = easyIFC:quickLabel(fpsMeter, "initializing...", ohcenter(fpsMeter.back), ovcenter(fpsMeter.back), gameFont, 12, _K_ )
fpsMeter.avgWindow = {}
fpsMeter.maxWindowSize = display.fps * 2 or 60

fpsMeter.enterFrame = function(self)
	local avgWindow = fpsMeter.avgWindow	
	local curTime = getTimer()
	local dt = curTime - self.lastTime
	self.lastTime = curTime
	if( dt == 0 ) then return end
	avgWindow[#avgWindow+1] = 1000/dt
	while( #avgWindow > self.maxWindowSize ) do table.remove(avgWindow,1) end
	if( #avgWindow ~= self.maxWindowSize ) then return end
	local sum = 0
	for i = 1, #avgWindow do
		sum = avgWindow[i] + sum
	end
	fpsMeter.label.text = round(sum/#avgWindow) .. " FPS"
	--print(curTime,dt,1000/dt)
end; 
nextFrame( function() listen("enterFrame", fpsMeter) end, 1000 )
fpsMeter.isVisible = false

-- Create Mem Meter
-- Create FPS Meter
--
memMeter = display.newGroup()
memMeter.back = newImageRect( memMeter, left + 2, bottom - 2, "images/interface/menu/box.png", { w = 195, h = 49, scale = 0.5, anchorX = 0, anchorY = 1 } )
memMeter.label = easyIFC:quickLabel(memMeter, 0, ohcenter(memMeter.back), ovcenter(memMeter.back), gameFont, 8, _K_ )
memMeter.enterFrame = function(self)
	local avgWindow = memMeter.avgWindow	

	collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
	local mmem = collectgarbage( "count" ) 
	local mmtext = "M: " .. round(mmem/(1024),1) .. " /	 "

	-- Fill in current texture memory usage
	local tmem = system.getInfo( "textureMemoryUsed" )
	local tmtext = "T: " .. round(tmem/(1024 * 1024),1) .. " (MB)"

	memMeter.label.text = mmtext .. tmtext
	--print(curTime,dt,1000/dt)
end; listen("enterFrame", memMeter)
memMeter.isVisible = false

