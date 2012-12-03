-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Buttons Factory
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

-- EFM bug - slider chained cb not called if finger off knob during release
-- EFM add 'auto-fit' text option so long text is scaled/shrunk to fit

--[[ 
h ssk.buttons.params
d <br>Button Parms:
d <br>
d <br>touchMask (''nil'') - Display mask to be used on button for visual and touch masking.
d <br>touchMaskW (''nil'') - Width of mask.  (Auto-calculated if not supplied and mask is a PNG file.)
d <br>touchMaskH (''nil'') - Height of mask.  (Auto-calculated if not supplied and mask is a PNG file.)
d <br>
d <br>touchOffset (''nil'') - An table containing the x- and y-offsets by which to displace a button when pressed.  Use the form { #, # } or { x = #, y = # }
d <br>
d <br>unselRectEn (''false'' or ''true'' if ''unselImgSrc'' supplied) - A boolean value to enable the creation and rendering of an unselected rectangle as part of the button layering.
d <br>selRectEn (''false'' or ''true'' if ''selImgSrc'' supplied) - A boolean value to enable the creation and rendering of a selected rectangle as part of the button layering.
d <br>
d <br>unselRectFillColor (''nil'') - A table containing a color code for the the unselected rectangle. (''unselRectEn'' must be set to ''true'')
d <br>selRectFillColor (''nil'') - A table containing a color code for the the selected rectangle. (''selRectEn'' must be set to ''true'')
d <br>
d <br>-- OR 
d <br>
d <br>unselRectGradient (''nil'') - A table containing a gradient code for the the unselected rectangle. (''unselRectEn'' must be set to ''true''; overrides ''unselRectFillColor'')
d <br>selRectGradient (''nil'') - A table containing a gradient code for the the selected rectangle. (''selRectEn'' must be set to ''true''; overrides ''unselRectFillColor'')
d <br>
d <br>strokeWidth (''nil'') - Width of selected/unselected rectangle border.
d <br>strokeColor (''nil'') - A table containing a color code for the selected/unselected rectangle borders.
d <br>
d <br>-- OR
d <br>
d <br>unselStrokeWidth (''nil'') - Width of unselected rectangle border.
d <br>unselStrokeColor (''nil'') - A table containing a color code for the unselected rectangle borders.
d <br>selStrokeWidth (''nil'') - Width of selected rectangle border.
d <br>selStrokeColor (''nil'') - A table containing a color code for the selected rectangle borders.
d <br>
d <br>unselImgSrc (''nil'') - A string providing the path and filename of an image to be used for a unselected image rectangle. (Rectangle is not created if no image is supplied.)
d <br>selImgSrc (''nil'') - A string providing the path and filename of an image to be used for a selected image rectangle. (Rectangle is not created if no image is supplied.) 
d <br>unselImgFillColor (''nil'') - A table containing a color code to be used as the fill color for the unselected image rectnagle. (Ignored if rectangle is not created.)
d <br>selImgFillColor (''nil'') - A table containing a color code to be used as the fill color for the selected image rectnagle. (Ignored if rectangle is not created.)
d <br>
d <br>buttonOverlayImgSrc (''nil'') - A string providing the path and filename of an image to be used for an overlay image rectangle. (Rectangle is not created if no image is supplied.)
d <br>
d <br>buttonOverlayRectColor (''nil'') - A table containing a color code to be used as the fill color for the overlay image rectnagle. (Ignored if rectangle is not created.)
d <br>
d <br>Note: You may set the following yourself, but many of these values are supplied as part of button builder calls.
d <br>
d <br>onPress (''nil'') - Pointer to callback function for onPress event.
d <br>onRelease (''nil'') - Pointer to callback function for onRelease event.
d <br>onEvent  (''nil'') - Pointer to callback to be called for both onPress and onRelease events.
d <br>buttonType  (''nil'') - A string specifying the button type: "push", "toggle", "radio" (Note: Sliders are treated as push-buttons.)
d <br>text  (''""'') - An optional string containing text to use as the buttons label.
d <br>fontSize (20) - Font size to use for label text.
d <br>textColor (''_WHITE_'') - A table containing the color code to use for label text.
d <br>selTextColor (''textColor'') - A table containing the color code to use for label text when a button is depressed.
d <br>textFont (''native.systemFontBold'') - A string or system value used to select which font to use for the label text.
d <br>emboss (''false'') - A boolean value specifying whether the label text should be embossed.
d <br>textOffset (''{0,0}'') - An table containing the optional {x, y} offset of the label text.  Useful for micro adjusting button label visuals.
d <br>pressSound (''nil'') - The handle to a sound which should be played when the button is presssed. (Note: Needs to be updated to use SSKCorona sound manager.)
d <br>releaseSound (''nil'') - The handle to a sound which should be played when the button is released. (Note: Needs to be updated to use SSKCorona sound manager.)
d <br>sound (''nil'') - The handle to a sound which should be played when the button is pressed / released. (Note: Needs to be updated to use SSKCorona sound manager.)
--]]

buttonClass = {}
buttonClass.presetsCatalog = {}

--[[
h ssk.buttons.getCurrentRadio
d Helper function for radio button groups, get currently selected radio button.
s buttons.getCurrentRadio( group )
s * group - Display group radio button(s) are stored in.
r Handle to currently selected/toggled radio button or ''nil'' if none selected/toggled or present.
--]]
function buttonClass.getCurrentRadio( group )
	return group.currentRadio
end

--[[
h ssk.buttons:addPreset
d Creates a new button preset (table containing visual and functional options for button).
s ssk.buttons:addPreset( presetName, params )
s * presetName - Name of new buttons preset (options table).
s * params - Parameters list. (See [ [ssk.buttons.params|ssk.buttons.params] ])
r None.
--]]
function buttonClass:addPreset( presetName, params )
	local entry = {}
	self.presetsCatalog[presetName] = entry

	entry.x      = params.x
	entry.y      = params.y
	entry.w      = params.w
	entry.h      = params.h

	entry.touchMask      = params.touchMask

	if( params.touchMask and not params.touchMaskW) then
		local maskInfo = ssk.pnglib.getPngInfo( params.touchMask ) 
		entry.touchMaskW     = maskInfo.width
		entry.touchMaskH     = maskInfo.height
	else
		entry.touchMaskW     = params.touchMaskW
		entry.touchMaskH     = params.touchMaskH
	end

	entry.touchOffset    = params.touchOffset
	

	entry.unselRectEn     = fnn(params.unselRectEn, not params.unselImgSrc)
	entry.selRectEn       = fnn(params.selRectEn, not params.selImgSrc)

	entry.selRectFillColor     = params.selRectFillColor
	entry.unselRectFillColor   = params.unselRectFillColor

	entry.selRectGradient    = params.selRectGradient
	entry.unselRectGradient  = params.unselRectGradient

	-- set strokwidth and color globally 
	entry.strokeWidth    = params.strokeWidth
	entry.strokeColor    = params.strokeColor
    -- or individually
	entry.unselStrokeWidth  = params.unselStrokeWidth
	entry.unselStrokeColor  = params.unselStrokeColor
	entry.selStrokeWidth    = params.selStrokeWidth
	entry.selStrokeColor    = params.selStrokeColor


	entry.unselImgSrc     = params.unselImgSrc
	entry.selImgSrc       = params.selImgSrc

	entry.selImgFillColor     = params.selImgFillColor
	entry.unselImgFillColor   = params.unselImgFillColor

	entry.buttonOverlayRectColor  = params.buttonOverlayRectColor

	entry.buttonOverlayImgSrc  = params.buttonOverlayImgSrc

	entry.onPress      = params.onPress
	entry.onRelease    = params.onRelease
	entry.onEvent      = params.onEvent
	entry.buttonType   = fnn(params.buttonType, "push" )

	entry.text         = fnn(params.text, "")
	entry.fontSize     = fnn(params.fontSize, 20)
	entry.textColor    = fnn(params.textColor, {255,255,255,255})
	entry.selTextColor = fnn(params.selTextColor, entry.textColor)
	entry.textFont     = fnn(params.textFont, native.systemFontBold)
	entry.textOffset   = fnn(params.textOffset, {0,0})
	--entry.isPressed    = fnn(params.isPressed, false)
	--entry.isEnabled    = fnn(params.isEnabled, true)
	entry.pressSound   = params.pressSound
	entry.releaseSound = params.releaseSound
	entry.sound        = params.sound
    entry.emboss       = fnn(params.emboss, false)

end

--[[
h ssk.buttons:new
d Core builder function for creating new buttons.
s ssk.buttons:new( params, screenGroup )
s * params - Button options list. (See [ [ssk.buttons.params|ssk.buttons.params] ])
s * screenGroup - Display group to store new button in.
r Handle to new buttonInstance.
--]]
function buttonClass:new( params, screenGroup )
	local buttonInstance = display.newGroup()

	-- 1. Check for catalog entry option and apply FIRST 
	-- (allows us to override by passing params too)
	buttonInstance.presetName = params.presetName
	local presetCatalogEntry  = self.presetsCatalog[buttonInstance.presetName]

	if(presetCatalogEntry) then
		for k,v in pairs(presetCatalogEntry) do
			buttonInstance[k] = v
		end
	end

	-- 2. Apply any passed params
	if(params) then
		for k,v in pairs(params) do
			buttonInstance[k] = v
		end
	end

	-- 3. Ensure all 'required' values have something in them or assign defaults
	buttonInstance.x            = fnn(buttonInstance.x, 0)
	buttonInstance.y            = fnn(buttonInstance.y, 0)
	buttonInstance.w            = fnn(buttonInstance.w, 178)
	buttonInstance.h            = fnn(buttonInstance.h, 56)
	buttonInstance.buttonType   = fnn(buttonInstance.buttonType, "push")

	buttonInstance.text         = fnn(buttonInstance.text, "")
	buttonInstance.fontSize     = fnn(buttonInstance.fontSize, 20)
	buttonInstance.textColor    = fnn(buttonInstance.textColor, {255,255,255,255})
	buttonInstance.selTextColor = fnn(buttonInstance.selTextColor, buttonInstance.textColor)
	buttonInstance.textFont     = fnn(buttonInstance.textFont, native.systemFontBold)
	buttonInstance.textOffset   = fnn(buttonInstance.textOffset, {0,0})
    buttonInstance.emboss       = fnn(buttonInstance.emboss, false)

	buttonInstance.isPressed    = false -- start off unpressed

	-- ====================
	-- Create the button
	-- ====================

	-- MASK
	if(buttonInstance.touchMask) then
		local tmpMask = graphics.newMask(buttonInstance.touchMask)
		buttonInstance:setMask( tmpMask )
		buttonInstance.maskScaleX = buttonInstance.w / buttonInstance.touchMaskW
		buttonInstance.maskScaleY = buttonInstance.h / buttonInstance.touchMaskH
	end

	-- UNSEL RECT
	if(buttonInstance.unselRectEn) then
		local unselRect
		unselRect = display.newRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h)

		if(buttonInstance.strokeWidth) then
			unselRect.strokeWidth = buttonInstance.strokeWidth
		elseif(buttonInstance.selStrokeWidth) then
			unselRect.strokeWidth = buttonInstance.selStrokeWidth
		end

		if(buttonInstance.unselRectFillColor ) then
			local r = fnn(buttonInstance.unselRectFillColor[1], 255)
			local g = fnn(buttonInstance.unselRectFillColor[2], 255)
			local b = fnn(buttonInstance.unselRectFillColor[3], 255)
			local a = fnn(buttonInstance.unselRectFillColor[4], 255)
			unselRect:setFillColor(r,g,b,a)
		end

		if(buttonInstance.unselRectGradient) then
			unselRect:setFillColor( buttonInstance.unselRectGradient )
		end

		if(buttonInstance.unselStrokeColor) then
			local r = fnn(buttonInstance.unselStrokeColor[1], 255)
			local g = fnn(buttonInstance.unselStrokeColor[2], 255)
			local b = fnn(buttonInstance.unselStrokeColor[3], 255)
			local a = fnn(buttonInstance.unselStrokeColor[4], 255)
			unselRect:setStrokeColor(r,g,b,a)

		elseif(buttonInstance.strokeColor) then
			local r = fnn(buttonInstance.strokeColor[1], 255)
			local g = fnn(buttonInstance.strokeColor[2], 255)
			local b = fnn(buttonInstance.strokeColor[3], 255)
			local a = fnn(buttonInstance.strokeColor[4], 255)
			unselRect:setStrokeColor(r,g,b,a)
		end

		buttonInstance:insert( unselRect, true )
		unselRect.isVisible = true
		buttonInstance.unselRect = unselRect
		
	end

	-- SEL RECT
if(buttonInstance.selRectEn) then

		local selRect
		selRect = display.newRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h)

		if(buttonInstance.strokeWidth) then
			selRect.strokeWidth = buttonInstance.strokeWidth
		elseif(buttonInstance.selStrokeWidth) then
			selRect.strokeWidth = buttonInstance.selStrokeWidth
		end

		if(buttonInstance.selRectFillColor ) then
			local r = fnn(buttonInstance.selRectFillColor[1], 255)
			local g = fnn(buttonInstance.selRectFillColor[2], 255)
			local b = fnn(buttonInstance.selRectFillColor[3], 255)
			local a = fnn(buttonInstance.selRectFillColor[4], 255)
			selRect:setFillColor(r,g,b,a)
		end

		if(buttonInstance.selRectGradient) then
			selRect:setFillColor( buttonInstance.selRectGradient )
		end

		if(buttonInstance.selStrokeColor) then
			local r = fnn(buttonInstance.selStrokeColor[1], 255)
			local g = fnn(buttonInstance.selStrokeColor[2], 255)
			local b = fnn(buttonInstance.selStrokeColor[3], 255)
			local a = fnn(buttonInstance.selStrokeColor[4], 255)
			selRect:setStrokeColor(r,g,b,a)

		elseif(buttonInstance.strokeColor) then
			local r = fnn(buttonInstance.strokeColor[1], 255)
			local g = fnn(buttonInstance.strokeColor[2], 255)
			local b = fnn(buttonInstance.strokeColor[3], 255)
			local a = fnn(buttonInstance.strokeColor[4], 255)
			selRect:setStrokeColor(r,g,b,a)
		end
	
		buttonInstance:insert( selRect, true )
		selRect.isVisible = false
		buttonInstance.selRect = selRect
	end

	-- UNSEL IMG
	if(buttonInstance.unselImgSrc) then		
		local unselImgObj
		unselImgObj = display.newImageRect( buttonInstance.unselImgSrc, buttonInstance.w, buttonInstance.h)

		if(buttonInstance.unselImgFillColor ) then
			local r = fnn(buttonInstance.unselImgFillColor[1], 255)
			local g = fnn(buttonInstance.unselImgFillColor[2], 255)
			local b = fnn(buttonInstance.unselImgFillColor[3], 255)
			local a = fnn(buttonInstance.unselImgFillColor[4], 255)
			unselImgObj:setFillColor(r,g,b,a)
		end

		buttonInstance:insert( unselImgObj, true )
		unselImgObj.isVisible = true
		buttonInstance.unsel = unselImgObj
	end
	
	-- SEL IMG
	if(buttonInstance.selImgSrc) then		
		local selImgObj
		selImgObj = display.newImageRect( buttonInstance.selImgSrc, buttonInstance.w, buttonInstance.h)

		if(buttonInstance.selImgFillColor ) then
			local r = fnn(buttonInstance.selImgFillColor[1], 255)
			local g = fnn(buttonInstance.selImgFillColor[2], 255)
			local b = fnn(buttonInstance.selImgFillColor[3], 255)
			local a = fnn(buttonInstance.selImgFillColor[4], 255)
			selImgObj:setFillColor(r,g,b,a)
		end

		buttonInstance:insert( selImgObj, true )
		selImgObj.isVisible = false
		buttonInstance.sel = selImgObj
	end
		
	-- BUTTON Overlay Rect
	if(buttonInstance.buttonOverlayRectColor) then
		local r = fnn(buttonInstance.buttonOverlayRectColor[1], 255)
		local g = fnn(buttonInstance.buttonOverlayRectColor[2], 255)
		local b = fnn(buttonInstance.buttonOverlayRectColor[3], 255)
		local a = fnn(buttonInstance.buttonOverlayRectColor[4], 255)
		local overlayRect = display.newRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h)
		buttonInstance:insert( overlayRect, true )
		buttonInstance.overlayRect = overlayRect
		buttonInstance.overlayRect:setFillColor( r,g,b,a )
	end

	-- BUTTON Overlay Image
	if(buttonInstance.buttonOverlayImgSrc) then
		local overlayImage = display.newImageRect( buttonInstance.buttonOverlayImgSrc, buttonInstance.w, buttonInstance.h)
		buttonInstance:insert( overlayImage, false )
		buttonInstance.overlayImage = overlayImage
	end

	-- BUTTON TEXT
	local labelText 
	if(buttonInstance.emboss) then
		labelText = display.newEmbossedText( buttonInstance.text, 0, 0, buttonInstance.textFont, buttonInstance.fontSize, buttonInstance.textColor )
	else
		labelText = display.newText( buttonInstance.text, 0, 0, buttonInstance.textFont, buttonInstance.fontSize )
	end	

	buttonInstance.labelText = labelText
	labelText:setTextColor( buttonInstance.textColor[1], buttonInstance.textColor[2], 
	                        buttonInstance.textColor[3], buttonInstance.textColor[4] )
	labelText:setReferencePoint( display.CenterReferencePoint )
	buttonInstance:insert( labelText, true )
	labelText.x = buttonInstance.textOffset[1]
	labelText.y = buttonInstance.textOffset[2]

	buttonInstance:addEventListener( "touch", self )

	-- ============= pressed() -- Return true if pressed
--[[
h buttonInstance:pressed
d Check if button is pressed (down).
s myButton:pressed()
r ''true'' if button is currently pressed, ''false'' otherwise.
--]]
	function buttonInstance:pressed( ) 
		return self.isPressed
	end

	-- ============= toggle() -- Toggle the state of a button (executes callbacks)
--[[
h buttonInstance:toggle
d Change the pressed state of a button.  (Meant to be used on toggle and radio buttons.)
s myButton:toggle()
r None.
--]]
	function buttonInstance:toggle( ) 
		--for k,v in pairs(self) do print(k,v) end

		local buttonEvent = {}
		buttonEvent.target = self
		buttonEvent.id = math.random(10000, 50000) -- must have a numeric id to be propagated
		buttonEvent.x = self.x
		buttonEvent.y = self.y
		buttonEvent.name = "touch"
		buttonEvent.phase = "began"
		buttonEvent.forceInBounds = true
		--print(tostring(buttonEvent) .. SPC .. buttonEvent.id) -- EFM bug: Not actually dispatching event
		--table.dump(buttonEvent)
		self:dispatchEvent( buttonEvent )
		buttonEvent.phase = "ended"
		self:dispatchEvent( buttonEvent )
	end

	-- ============= disable() -- Disable button and reduce alpha as visual feedback
--[[
h buttonInstance:disable
d Disable the current button.  (Make button translucent and ignores touches.)
s myButton:disable()
r None.
--]]
	function buttonInstance:disable( ) 
		self.isEnabled = false
		self.alpha = 0.3
	end

	-- ============= enable() -- Enable button and increase alpha as visual feedback
--[[
h buttonInstance:enable
d Enables the current button.  (Make button opaque and acknowledge touches.)
s myButton:enable()
r None.
--]]
	function buttonInstance:enable( ) 
		self.isEnabled = true
		self.alpha = 1.0
	end

	-- ============= isEnabled() -- Return true if button is enabled
--[[
h buttonInstance:isEnabled
d Checks if button is enabled.
s myButton:isEnabled()
r ''true'' if button is enabled, ''false'' otherwise.
--]]
	function buttonInstance:isEnabled() 
		return (self.isEnabled == true)
	end

	-- ============= getText() -- Return current text displayed on button
--[[
h buttonInstance:getText
d Get the currently displayed text for the current button if any.
s myButton:getText()
r A string containing the text that the button is currently displaying.
--]]
	function buttonInstance:getText( ) 
		--print( "buttonInstance:getText() self.text == " .. tostring(self.text) )
		return tostring(self.text)
	end

	-- ============= setText() -- Set current text displayed on button
--[[
h buttonInstance:setText
d Set the currently displayed text for the current button.
s myButton:setText()
r None.
--]]
	function buttonInstance:setText( text ) 
		local labelText = self.labelText
		if(self.emboss) then
			labelText:setText( text )
		else
			labelText.text = text
		end

		self.text = text

		--print( "buttonInstance:setText() self.text == " .. tostring(self.text) )
		
		labelText:setReferencePoint( display.CenterReferencePoint )
		labelText.x = self.textOffset[1]
		labelText.y = self.textOffset[2]
	end

	-- ============= getTextColor() -- Get label color
--[[
h buttonInstance:getTextColor
d Get the color of the text on the current button.
s myButton:getTextColor()
r A table containing the color code for the buttons text.
--]]
	function buttonInstance:getTextColor( text ) 
		local labelText = self.labelText
		return labelText._color 
	end

	-- ============= setTextColor() -- Set label color
--[[
h buttonInstance:setTextColor
d Set the color of the text on the current button.
s myButton:setTextColor( color )
s * color - A table containing a color code.
r None.
--]]
	function buttonInstance:setTextColor( color ) 
		local labelText = self.labelText
		labelText:setTextColor( unpack( color ) )
		labelText._color  = color
	end


	-- ============= adjustTextOffset() -- Move button text by specified x,y
--[[
h buttonInstance:adjustTextOffset
d Adjust the x- and y-offset of the current button's (text) label.
s myButton:adjustTextOffset( offset )
s * offset - An indexed table containing two values, where value [1] is the x-offset, and value [2] is the y-offset.
r None.
--]]
	function buttonInstance:adjustTextOffset( offset ) 
		local offset = fnn(offset, {0,0})
		local labelText = self.labelText
		self.textOffset = offset
		labelText:setReferencePoint( display.CenterReferencePoint )
		labelText.x = self.textOffset[1]
		labelText.y = self.textOffset[2]
	end


	-- ============= setHighlight() -- Set button images fill color
--[[
h buttonInstance:setHighlight
d Highlight (or unhighlight) the button.
s myButton:setHighlight( vis )
s * vis - ''true'' means highlight, ''false'' means un-highlight.
r None.
--]]
	function buttonInstance:setHighlight( vis )	
		--if(not self.selRect) then print "NO RECT" end	
		--if(not self.sel) then print "NO IMAGE" end	
		--if(not self.overlayRect) then print "NO OVERLAY RECT" end	
		--if(not self.overlayImage) then print "NO OVERLAY IMAGE" end	

		if(self.highlighted == nil or self.highlighted ~= vis) then

			if(self.selRect) then self.selRect.isVisible = vis end
			if(self.unselRect) then self.unselRect.isVisible = (not vis) end
			if(self.sel) then self.sel.isVisible = vis end
			if(self.unsel) then self.unsel.isVisible = (not vis) end
		
			if (self.touchOffset) then
				local xOffset = self.touchOffset[1] or self.x
				local yOffset = self.touchOffset[2] or self.y
				if(vis) then						
					self.x = self.x + xOffset
					self.y = self.y + yOffset
				else
					self.x = self.x - xOffset
					self.y = self.y - yOffset
				end
			end

			if(self.selTextColor) then 
				if(vis) then		
					self.labelText:setTextColor( unpack( self.selTextColor ) )
				else
					self.labelText:setTextColor( unpack( self.textColor ) )
				end
			end

			self.highlighted = vis

		end
	end
	
	screenGroup:insert( buttonInstance )

	return buttonInstance
end


-- ============= presetPush() -- Quick push button creator
--[[
h ssk.buttons:presetPush
d Create a new push-button based on a previously configured preset (settings table).
s ssk.buttons:presetPush( screenGroup, presetName, x,y,w,h [, text [ , onRelease [, overrideParams] ] ] )
s * screenGroup - Display group to store new button in.
s * presetName - String containing the name of a previously configured preset (settings table).
s * x,y - <x,y> position to place button at
s * w,h - Width and height of button.
s * text - (optional) Text to display as button label.
s * onRelease - (optional) Callback to execute when button is released.
s * overrideParams - (optional) A table containing parameters you wish to set or change (overrides preset values) when making the button.
r Handle to a new buttonInstance.
--]]
function buttonClass:presetPush( screenGroup, presetName, x,y,w,h, text,onRelease, overrideParams)
	local presetName = presetName or "default"

	--print("PUSH BUTTON w = " .. w .. " h = " .. h)
	local tmpParams = 
	{ 
		presetName = presetName,
		w = w,
		h = h,
		x = x,
		y = y,
		buttonType = "push",
		text = text,
		onRelease = onRelease,
	}

	if(overrideParams) then
		for k,v in pairs(overrideParams) do
			tmpParams[k] = v
		end
	end


	local tmpButton = self:new( tmpParams, screenGroup )

	return tmpButton
end


-- ============= presetToggle() -- Quick toggle button creator
--[[
h ssk.buttons:presetToggle
d Create a new toggle-button based on a previously configured preset (settings table).
s ssk.buttons:presetToggle( screenGroup, presetName, x,y,w,h [, text [ , onEvent [, overrideParams] ] ] )
s * screenGroup - Display group to store new button in.
s * presetName - String containing the name of a previously configured preset (settings table).
s * x,y - <x,y> position to place button at
s * w,h - Width and height of button.
s * text - (optional) Text to display as button label.
s * onEvent - (optional) Callback to execute when button is pressed and released.
s * overrideParams - (optional) A table containing parameters you wish to set or change (overrides preset values) when making the button.
r Handle to a new buttonInstance.--]]
function buttonClass:presetToggle( screenGroup, presetName, x,y,w,h, text,onEvent, overrideParams)
	local presetName = presetName or "default"

	--print("PUSH BUTTON w = " .. w .. " h = " .. h)
	local tmpParams = 
	{ 
		presetName = presetName,
		w = w,
		h = h,
		x = x,
		y = y,
		buttonType = "toggle",
		text = text,
		onEvent = onEvent,
	}

	if(overrideParams) then
		for k,v in pairs(overrideParams) do
			tmpParams[k] = v
		end
	end

	local tmpButton = self:new( tmpParams, screenGroup )

	return tmpButton
end


-- ============= presetRadio() -- Quick radio button creator
--[[
h ssk.buttons:presetRadio
d Create a new radio-button based on a previously configured preset (settings table).
d <br>Note: To work properly, associated radio buttons should be placed in their own display group without other un-related radios buttons.
s ssk.buttons:presetRadio( screenGroup, presetName, x,y,w,h [, text [ , onRelease [, overrideParams] ] ] )
s * screenGroup - Display group to store new button in.
s * presetName - String containing the name of a previously configured preset (settings table).
s * x,y - <x,y> position to place button at
s * w,h - Width and height of button.
s * text - (optional) Text to display as button label.
s * onRelease - (optional) Callback to execute when button is released.
s * overrideParams - (optional) A table containing parameters you wish to set or change (overrides preset values) when making the button.
r Handle to a new buttonInstance.
--]]
function buttonClass:presetRadio( screenGroup, presetName, x,y,w,h, text,onRelease, overrideParams)
	local presetName = presetName or "default"
	
	--print("PUSH BUTTON w = " .. w .. " h = " .. h)
	local tmpParams = 
	{ 
		presetName = presetName,
		w = w,
		h = h,
		x = x,
		y = y,
		buttonType = "radio",
		text = text,
		onRelease = onRelease,
	}

	if(overrideParams) then
		for k,v in pairs(overrideParams) do
			tmpParams[k] = v
		end
	end


	local tmpButton = self:new( tmpParams, screenGroup )
	return tmpButton
end


-- ============= quickHorizSlider() -- Quick slider creator
--[[
h ssk.buttons:quickHorizSlider
d Create a new radio-button based on a previously configured preset (settings table).
d <br>Note: To work properly, associated radio buttons should be placed in their own display group without other un-related radios buttons.
s ssk.buttons:quickHorizSlider( x, y, w, h, imageBase, onEvent or nil , onRelease or nil , knobImg, kw, kh, screenGroup )
s * x,y - <x,y> position to place slider bar at.
s * w,h - Width and height of slider bar.
s * imageBase - File path and name base for normal and Over textures. i.e. If a slider uses two textures sliderBar.png and sliderBarOver.png, the ''imageBase'' is "slideBar".
s * onEvent - (optional) Callback to execute when slider is moved.
s * onRelease - (optional) Callback to execute when slider is released.
s * knobImg - Path and filname of image file to use for knob.
s * kw,kh - Width and height of slider knob.
s * screenGroup - Display group to store slider in.
r Handle to a new sliderInstance.
--]]
function buttonClass:quickHorizSlider( x,y,w,h,imageBase,onEvent,onRelease,knobImg, kw,kh, screenGroup)
	local tmpParams = 
	{ 
		w = w,
		h = h,
		x = x,
		y = y,
		unselImgSrc = imagesDir .. imageBase .. ".png",
		selImgSrc   = imagesDir .. imageBase .. "Over.png",
		buttonType = "push",
		pressSound = buttonSound,
		onEvent = onEvent,
		onRelease = onRelease,
		emboss = true,
	}
	local tmpButton = self:new( tmpParams, screenGroup )

	local sliderKnob = display.newImageRect(knobImg, kw, kh )
	sliderKnob.x = tmpButton.x - tmpButton.width/2  + tmpButton.width/2
	sliderKnob.y = tmpButton.y
	tmpButton.myKnob = sliderKnob
	tmpButton.value = 0

	screenGroup:insert(sliderKnob)

--[[
h sliderInstance:getValue
d Get the current value for the slider.
s mySlider.getValue( )
r A floating-point value in the range [ 0.0 , 1.0 ] representing the left-to-right position of the slider.
--]]
	function tmpButton:getValue()
		return  tonumber(string.format("%1.2f", self.value))
	end

--[[
h sliderInstance:setValue
d Sets the current value of the slider and updates the knob-position.
s mySlider.setValue( val )
s * val - A floating-point value in the range [ 0.0 , 1.0 ] representing the left-to-right position of the slider.
r None.
--]]
	function tmpButton:setValue( val )
		local knob = self.myKnob
		local left = (self.x - self.width/2) + knob.width/2
		local right = (self.x + self.width/2)  - knob.width/2
		local width = right-left

		if(val < 0) then
			self.value = 0
		elseif( val > 1 ) then
			self.value = 1
		else
			self.value = tonumber(string.format("%1.2f", val))
		end

		knob.x = left + (width * self.value)
	end

	-- ============= disable() -- Disable button and reduce alpha as visual feedback
--[[
h sliderInstance:disable
d Disables the slider and makes is translucent.  
s mySlider.disable( )
r None.
--]]
	function tmpButton:disable( ) 
		self.isEnabled = false
		self.sel.alpha = 0.3
		self.unsel.alpha = 0.3
		self.myKnob.alpha = 0.3
	end

	-- ============= enable() -- Enable button and increase alpha as visual feedback
--[[
h sliderInstance:enable
d Enables the slider and makes is opaque.  
s mySlider.disable( )
r None.
--]]
	function tmpButton:enable( ) 
		self.isEnabled = true
		self.sel.alpha = 1.0
		self.unsel.alpha = 1.0
		self.myKnob.alpha = 1.0		
	end

	return tmpButton, sliderKnob
end



-- ============= touch() -- Touch handler for all button types
function buttonClass:touch( params )
	--for k,v in pairs(params) do print(k,v) end
	local result         = true
	local id		     = params.id 
	local theButton      = params.target 
	local phase          = params.phase
	local sel            = theButton.sel
	local unsel          = theButton.unsel
	local onPress        = theButton.onPress
	local onRelease      = theButton.onRelease
	local onEvent        = theButton.onEvent
	local buttonType     = theButton.buttonType
	local parent         = theButton.parent
	local sound          = theButton.sound
	local pressSound     = theButton.pressSound
	local releaseSound   = theButton.releaseSound
	local forceInBounds  = params.forceInBounds


	-- If not enabled, exit immediately
	if(theButton.isEnabled == false) then
		return result
	end

	local buttonEvent = params -- For passing to callbacks

	if(phase == "began") then
		theButton:setHighlight(true)
		display.getCurrentStage():setFocus( theButton, id )
		theButton.isFocus = true

		-- Only Pushbutton fires event here
		if(buttonType == "push") then
			-- PUSH BUTTON
			--print("push button began")
			theButton.isPressed = true
			if( sound ) then audio.play( sound ) end
			if( pressSound ) then audio.play( pressSound ) end
			if( onPress ) then result = result and onPress( buttonEvent ) end
			if( onEvent ) then result = result and onEvent( buttonEvent ) end
		end

	elseif theButton.isFocus then
		local bounds = theButton.stageBounds
		local x,y = params.x, params.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if( forceInBounds == true ) then
			isWithinBounds = true
		end

		if( phase == "moved") then
			if(buttonType == "push") then
				theButton:setHighlight(isWithinBounds)
				--sel.isVisible   = isWithinBounds
				--unsel.isVisible = not isWithinBounds
				if( onEvent ) then result = result and onEvent( buttonEvent ) end
			elseif(buttonType == "toggle") then
				if( not isWithinBounds ) then
					theButton:setHighlight(theButton.isPressed)
					--sel.isVisible   = theButton.isPressed
					--unsel.isVisible = not theButton.isPressed					
				else
					theButton:setHighlight(true)
					--sel.isVisible   = true
					--unsel.isVisible = false
				end
			elseif(buttonType == "radio") then
			end

		elseif(phase == "ended" or phase == "cancelled") then
			--print("buttonType " .. buttonType )
			------------------------------------------------------
			if(buttonType == "push") then -- PUSH BUTTON
			------------------------------------------------------
				--print "push button ended"				
				theButton:setHighlight(false)
				--sel.isVisible   = false
				--unsel.isVisible = true

				theButton.isPressed = false

				if isWithinBounds then
					if( sound ) then audio.play( sound ) end
					if( releaseSound ) then audio.play( releaseSound ) end
					if( onRelease ) then result = result and onRelease( buttonEvent ) end
					if( onEvent ) then result = result and onEvent( buttonEvent ) end
				end
			
			------------------------------------------------------
			elseif(buttonType == "toggle") then -- TOGGLE BUTTON				
			------------------------------------------------------
				--print( "\ntoggle button ended -- " .. buttonEvent.phase )
				if isWithinBounds then
					if(theButton.isPressed == true) then
						theButton.isPressed = false
						if( sound ) then audio.play( sound ) end
						if( releaseSound ) then audio.play( releaseSound ) end
						if( onRelease ) then result = result and onRelease( buttonEvent ) end
						if( onEvent ) then result = result and onEvent( buttonEvent ) end
					else
						theButton.isPressed = true
						buttonEvent.phase = "began"
						if( sound ) then audio.play( sound ) end
						if( pressSound ) then audio.play( pressSound ) end
						if( onPress ) then result = result and onPress( buttonEvent ) end
						if( onEvent ) then result = result and onEvent( buttonEvent ) end
					end					
				end
				theButton:setHighlight(theButton.isPressed)
				--sel.isVisible   = theButton.isPressed
				--unsel.isVisible = not theButton.isPressed				
			------------------------------------------------------
			elseif(buttonType == "radio") then -- RADIO BUTTON
			------------------------------------------------------
				--print "radio button ended" 
				if isWithinBounds then
					--print( "parent.currentRadio ==> " .. tostring(parent.currentRadio))
					if( not parent.currentRadio ) then
						--print("First radio press")
					 
					elseif( parent.currentRadio ~= theButton ) then
						local oldRadio = parent.currentRadio
						if( oldRadio ) then
							oldRadio.isPressed = false
							oldRadio:setHighlight(false)
						end
					end
						
					parent.currentRadio = theButton
					buttonEvent.theButton = theButton

					theButton.isPressed = true
					--buttonEvent.phase = "ended"
					if( sound ) then audio.play( sound ) end
					if( onEvent ) then result = result and onEvent( buttonEvent ) end

					if( releaseSound ) then audio.play( releaseSound ) end
					if( onRelease ) then result = result and onRelease( buttonEvent ) end


				end
				
				theButton:setHighlight(theButton.isPressed)
				--sel.isVisible   = theButton.isPressed
				--unsel.isVisible = not theButton.isPressed
			end
			
			-- Allow touch events to be sent normally to the objects they "hit"
			display.getCurrentStage():setFocus( nil )
			theButton.isFocus = false


		end
	end
	return result
end

return buttonClass