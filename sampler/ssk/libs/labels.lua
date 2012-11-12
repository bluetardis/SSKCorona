-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Labels Factory
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
--[[ 
h ssk.labels.params
d <br>text (''nil'') - Text to use for label.
d <br>font (''native.systemFontBold'') - A string or system value used to select which font to use for the label text.
d <br>fontSize (20) - Font size to use for label text.
d <br>textColor (''_WHITE_'') - A table containing the color code to use for label text.
d <br>emboss (''false'') - A boolean value specifying whether the label text should be embossed.
d <br>embossTextColor (''_WHITE_'') - A table containing the color code to use for emobossed text.
d <br>embossHighlightColor (''_WHITE_'') - A table containing the color code to use for emobossed text highlight.
d <br>embossShadowColor (''_WHITE_'') - A table containing the color code to use for emobossed text shadow.
d <br>referencePoint (''display.CenterReferencePoint'') - The default position of {0,0} on the label. i.e. By default, labels are positioned by their centers.
--]]

-- External helper functions
labelClass = {}
labelClass.presetsCatalog = {}

-- ============= addPreset()
--[[
h ssk.labels:addPreset
d Creates a label button preset (table containing visual options for label).
s ssk.labels:addPreset( presetName, params )
s * presetName - Name of new label preset (options table).
s * params - Parameters list. (See [ [ssk.labels.params|ssk.labels.params] ])
r None.
--]]
function labelClass:addPreset( presetName, params )
	local entry = {}

	self.presetsCatalog[presetName] = entry

	entry.text           = fnn(params.text, "")
	entry.font           = fnn(params.font, native.systemFontBold)
	entry.fontSize       = fnn(params.fontSize, 20)
	entry.textColor          = fnn(params.textColor, {255,255,255,255})

	entry.emboss         = fnn(params.emboss, false)
	entry.embossTextColor     = fnn(params.embossTextColor, {255,255,255,255})
	entry.embossHighlightColor = fnn(params.embossHighlightColor, {255,255,255,255})
	entry.embossShadowColor    = fnn(params.embossShadowColor, {0,0,0,255})

	entry.referencePoint = fnn(params.referencePoint, display.CenterReferencePoint)
end

-- ============= new()
--[[
h ssk.labels:new
d Core builder function for creating new labels.
s ssk.labels:new( params, screenGroup )
s * params - Label options list. (See [ [ssk.labels.params|ssk.labels.params] ])
s * screenGroup - Display group to store new button in.
r Handle to new labelInstance.
--]]
function labelClass:new( params, screenGroup )

	local tmpParams = {}

	-- 1. Check for catalog entry option and apply FIRST 
	-- (allows us to override by passing params too)
	tmpParams.presetName     = params.presetName, nil 
	local presetCatalogEntry = self.presetsCatalog[tmpParams.presetName]
	if(presetCatalogEntry) then
		for k,v in pairs(presetCatalogEntry) do
			tmpParams[k] = v
		end
	end

	-- 2. Apply any passed params
	if(params) then
		for k,v in pairs(params) do
			tmpParams[k] = v
		end
	end

	-- 3. Ensure all 'required' values have something in them Snag Setting (assume all set)
	tmpParams.x              = fnn(tmpParams.x, display.contentWidth/2)
	tmpParams.y              = fnn(tmpParams.y, 0)
	tmpParams.embossTextColor     = fnn(tmpParams.embossTextColor, {255,255,255,255})
	tmpParams.embossHighlightColor = fnn(tmpParams.embossHighlightColor, {255,255,255,255})
	tmpParams.embossShadowColor    = fnn(tmpParams.embossShadowColor, {0,0,0,255})
	tmpParams.referencePoint = fnn(tmpParams.referencePoint, display.CenterReferencePoint)

	-- Create the label
	local labelInstance
	if(tmpParams.emboss) then
		labelInstance = display.newEmbossedText( tmpParams.text, 0, 0, tmpParams.font, tmpParams.fontSize, tmpParams.textColor )
	else
		labelInstance = display.newText( tmpParams.text, 0, 0, tmpParams.font, tmpParams.fontSize )
	end	

	-- 4. Store the params directly in the 
	for k,v in pairs(tmpParams) do
		labelInstance[k] = v
	end

	-- 5. Assign methods based on embossed or not
	if(labelInstance.emboss) then

		function labelInstance:setText( text )
			self.label.text = text
			self.highlight.text = text
			self.shadow.text = text
			self.text = text
			return self.text
		end

--[[
h labelInstance:setLabelTextColor
d Changes the text color of the label (works for embossed and regular text).
s myLabel:setLabelTextColor( textColor )
s * textColor - A table containing a color code to use for the label's text.
r None.
--]]
		function labelInstance:setLabelTextColor( textColor )
			local r = textColor[1] or 255
			local g = textColor[2] or 255
			local b = textColor[3] or 255
			local a = textColor[4] or 255
			self.label:setTextColor(r,g,b,a)
		end

--[[
h labelInstance:setHighlightTextColor
d Changes the embossed text highlight color of the label.
s myLabel:setHighlightTextColor( textColor )
s * textColor - A table containing a color code to use for the label's embossed highlight.
r None.
--]]
		function labelInstance:setHighlightTextColor( textColor )
			local r = textColor[1] or 255
			local g = textColor[2] or 255
			local b = textColor[3] or 255
			local a = textColor[4] or 255
			self.highlight:setTextColor(r,g,b,a)
		end

--[[
h labelInstance:setShadowTextColor
d Changes the embossed text shadow color of the label.
s myLabel:setShadowTextColor( textColor )
s * textColor - A table containing a color code to use for the label's embossed shadow.
r None.
--]]
		function labelInstance:setShadowTextColor( textColor )
			local r = textColor[1] or 255
			local g = textColor[2] or 255
			local b = textColor[3] or 255
			local a = textColor[4] or 255
			self.shadow:setTextColor(r,g,b,a)
		end

--[[
h labelInstance:setTextColors
d Changes text, highlight, and shadow colors for a embossed label.
s myLabel:setTextColors( embossTextColor, embossHighlightColor, embossShadowColor )
s * embossTextColor - A table containing a color code to use for the label's embossed text.
s * embossHighlightColor - A table containing a color code to use for the label's embossed highlight.
s * embossShadowColor - A table containing a color code to use for the label's embossed shadow.
r None.
--]]
		function labelInstance:setTextColors( embossTextColor, embossHighlightColor, embossShadowColor )
			self:setLabelTextColor(embossTextColor)
			self:setHighlightTextColor(embossHighlightColor)
			self:setShadowTextColor(embossShadowColor)
		end

--[[
h labelInstance:getText
d Gets the label text.
s myLabel:getText( )
r A string containing the current label text.
--]]
		function labelInstance:getText()
			return self.text
		end

	else

--[[
h labelInstance:setText
d Changes the label text.
s myLabel:setText( text )
s * text - A string containin the new text to use for the label.
r None.
--]]
		function labelInstance:setText( text )
			self.text = text
			return self.text
		end

		function labelInstance:setLabelTextColor( textColor )
			print("warning: not embossed text" )
		end

		function labelInstance:setHighlightTextColor( textColor )
			print("warning: not embossed text" )
		end

		function labelInstance:setShadowTextColor( textColor )
			print("warning: not embossed text" )
		end

		function labelInstance:setTextColors( embossTextColor, embossHighlightColor, embossShadowColor )
			print("warning: not embossed text" )
		end

		function labelInstance:getText()
			return self.text
		end

	end	

	-- 6. Set textColor
	if(labelInstance.emboss) then
		if(labelInstance.textColor) then
			local r = fnn(labelInstance.textColor[1],  255)
			local g = fnn(labelInstance.textColor[2],  255)
			local b = fnn(labelInstance.textColor[3],  255)
			local a = fnn(labelInstance.textColor[4],  255)
			labelInstance:setTextColor(r,g,b,a)
		end

		if(labelInstance.embossTextColor) then
			labelInstance:setLabelTextColor(labelInstance.embossTextColor)
		end
		if(labelInstance.embossHighlightColor) then
			labelInstance:setHighlightTextColor(labelInstance.embossHighlightColor)
		end
		if(labelInstance.embossShadowColor) then
			labelInstance:setShadowTextColor(labelInstance.embossShadowColor)
		end
	else
		if(labelInstance.textColor) then
			local r = fnn(labelInstance.textColor[1],  255)
			local g = fnn(labelInstance.textColor[2],  255)
			local b = fnn(labelInstance.textColor[3],  255)
			local a = fnn(labelInstance.textColor[4],  255)
			labelInstance:setTextColor(r,g,b,a)
		end
	end

	-- 6. Set reference point and do final positioning
	labelInstance:setReferencePoint( labelInstance.referencePoint )
	labelInstance.x = tmpParams.x
	labelInstance.y = tmpParams.y

	if(screenGroup) then
		screenGroup:insert(labelInstance)
	end

	return labelInstance
end


--[[
h ssk.labels:presetLabel
d A label builder utilizing a preset to set the label's visual options.
s ssk.labels:presetLabel( group, presetName, text, x, y [, params ] )
s * group - A display group to insert the label into.
s * presetName - Name of new label preset (options table).
s * text - Label text ("" for empty label).
s * x,y - Position to place label at.
s * params - (Options) Extra and override parameters table. (See [ [ssk.labels.params|ssk.labels.params] ])
r A labelInstance.
--]]
function labelClass:presetLabel( group, presetName, text, x, y, params  )
	local presetName = presetName or "default"
		
	local tmpParams = params or {}
	tmpParams.presetName = presetName
	tmpParams.text = text
	tmpParams.x = x
	tmpParams.y = y
	
	local tmpLabel = self:new(tmpParams, group)
	return tmpLabel
end


--[[
h ssk.labels:quickLabel
d An alternative label builder.  Only supports basic text options.
s ssk.labels:quickLabel( group, text, x, y [, font [, fontSize [, textColor ] ] ] )
s * group - A display group to insert the label into.
s * text - Label text ("" for empty label).
s * x,y - Position to place label at.
s * font - (optional) Font to use for label text. Defaults to ''native.systemFont''
s * fontSize - (optional) Font size to use for label text. Defaults to ''16''
s * textColor - (optional) Table containig color code for text color. Defaults to ''_WHITE_''. 
r A basic text labelInstance.
--]]
function labelClass:quickLabel( group, text, x, y, font, fontSize, textColor )
	local tmpParams = 
	{ 
		text = text,
		x = x,
		y = y,
		font = font or native.systemFont,
		fontSize = fontSize or 16,
		textColor  = textColor or _WHITE_
	}

	local tmpLabel = self:new(tmpParams, group)
	return tmpLabel
end


--[[
h ssk.labels:quickEmbossedLabel
d An alternative embossed label builder.  Only supports basic embossed options.
s ssk.labels:quickEmbossedLabel( group, text, x, y [, font [, fontSize [, embossTextColor [, embossHighlightColor [, embossShadowColor ] ] ] ] ] )
s * group - A display group to insert the label into.
s * text - Label text ("" for empty label).
s * x,y - Position to place label at.
s * font - (optional) Font to use for label text. Defaults to ''native.systemFont''
s * fontSize - (optional) Font size to use for label text. Defaults to ''16''
s * embossTextColor - (optional) Table containig color code for text color. Defaults to ''_GREY_''. 
s * embossHighlightColor - (optional) Table containig color code for highlight color. Defaults to ''_WHITE_''. 
s * embossShadowColor - (optional) Table containig color code for shadow color. Defaults to ''_BLACK_''. 
r An embossed labelInstance.
--]]
function labelClass:quickEmbossedLabel( group, text, x, y, font, fontSize, embossTextColor, embossHighlightColor, embossShadowColor )
	local tmpParams = 
	{ 
		text = text,
		x = x,
		y = y,
		font = font or native.systemFont,
		fontSize = fontSize or 16,
		embossTextColor  = embossTextColor or _GREY_,
		embossHighlightColor  = embossHighlightColor or _WHITE_,
		embossShadowColor  = embossShadowColor or _BLACK_,
		emboss = true
	}

	local tmpLabel = self:new(tmpParams)
	group:insert(tmpLabel)
	return tmpLabel
end


return labelClass