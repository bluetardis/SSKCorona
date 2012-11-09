-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- HUDS Factory
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
-- EFM make this library use trash and chained removeSelf func too

function public:createTimeHUD( x, y, presetName, group, params)
- function theHUD:get()
- function theHUD:set( seconds )
- function theHUD:autoCount( maxTime, callback)
- function theHUD:autoCountDown( minTime, callback )
- function theHUD:destroy()

function public:createNumericScoreHUD( x, y, digits, presetName, group, params)
- function theHUD:get()
- function theHUD:set( value )
- function theHUD:destroy()

--]]


public = {}

public.instances = {}

function public:cleanup()
end

-- =================================================
--  Time HUD (w/ countdown, countup features)
-- =================================================
function public:createTimeHUD( x, y, presetName, group, params)
	local theHUD = ssk.labels:presetLabel( group, presetName, "0:00", x, y, params  )

	group:insert(theHUD)

	theHUD.curTime = 0
	theHUD.x, theHUD.y = x,y
	--theHUD.myx, theHUD.myy = x,y

	function theHUD:get()
		return self.curTime
	end

	function theHUD:set( seconds )
		self.curTime = seconds
		self:setText( ssk.misc.convertSecondsToTimer( self.curTime ) )
		--self.x, self.y = self.myx, self.myy
	end

	function theHUD:autoCount( maxTime, callback)
		
		self.timer = function()
			self.curTime = self.curTime + 1
			self:setText( ssk.misc.convertSecondsToTimer( self.curTime ) )
			if( maxTime and ( self.curTime == maxTime ) )then
				if(callback) then
					callback( self )
				end
				timer.cancel(self.myTimer)
				self.myTimer = nil
				return
			end			
		end
		self.myTimer = timer.performWithDelay( 1000, self, 0 )
	end

	function theHUD:autoCountDown( minTime, callback ) -- EFM swap order of args, make minTime optional
		
		self.timer = function()
			self.curTime = self.curTime - 1
			if(self.curTime >= 0) then
				self:setText( ssk.misc.convertSecondsToTimer( self.curTime ) )
			end

			if( minTime and ( self.curTime == minTime ) )then
				if(callback) then
					callback( self )
				end
				if(self.myTimer) then
					timer.cancel(self.myTimer)
					self.myTimer = nil
				end
				return
			end			
		end
		self.myTimer = timer.performWithDelay( 1000, self, 0 )
	end

	function theHUD:stop()
		if( self.myTimer ) then
			timer.cancel(self.myTimer)
			self.myTimer = nil
		end
	end

	return theHUD
end


-- =================================================
--  Score HUD
-- =================================================
function public:createNumericScoreHUD( x, y, digits, presetName, group, params)
	local theHUD = ssk.labels:presetLabel( group, presetName, string.lpad( "0", digits,'0'), x, y, params  )

	group:insert(theHUD)

	theHUD.curValue = 0
	theHUD.x, theHUD.y = x,y
	--theHUD.myx, theHUD.myy = x,y

	theHUD.digits = digits or 0

	function theHUD:get()
		return self.curValue
	end

	function theHUD:set( value )
		self.curValue = value
		if(self.digits) then
			self:setText( string.lpad( tostring(self.curValue) , self.digits,'0') )
		else
			self:setText( tostring(value) )
		end
	end

	function theHUD:increment( value )
		self.curValue = self.curValue + value
		if(self.digits) then
			self:setText( string.lpad( tostring(self.curValue) , self.digits,'0') )
		else
			self:setText( tostring(value) )
		end
	end

	return theHUD
end

-- =================================================
--  Horizonal Image Counter 
-- =================================================
function public:createHorizImageCounter( group, x, y, imgSrc, imgW, imgH, maxValue, intialValue )
	
	local initialValue = initialValue or 0

	local theHUD = display.newGroup()
	group:insert(theHUD)

	--theHUD.myx, theHUD.myy = x,y
	theHUD.curValue = 0
	theHUD.maxValue = maxValue

	for i=1, maxValue do
		local img = display.newImageRect( theHUD, imgSrc, imgW, imgH )
		img.x = (i-1) * imgW
		img.y = 0
	end

	theHUD:setReferencePoint(display.CenterReferencePoint)
	theHUD.x, theHUD.y = x,y


	function theHUD:set( value )
		self.curValue = value
		if(self.curValue < 0) then self.curValue = 0 end
		if(self.curValue > self.maxValue) then self.curValue = self.maxValue end

		for i=1, self.maxValue do
			if(i > self.curValue) then
				self[i].isVisible = false
			else
				self[i].isVisible = true
			end
		end

	end

	theHUD:set( intialValue )

	function theHUD:get()
		return self.curValue
	end
	function theHUD:increment( value )
		self.curValue = self.curValue + value
		self:set( self.curValue )
	end

	return theHUD
end


-- =================================================
--  Percentage Dial
-- =================================================
function public:createPercentageDial( group, x, y, params )
	local params = params or 
	{
		size        = 128,
		dialSrc     = _DARKGREY_,
		backSrc     = _BLACK_,
		maskPath    = imagesDir .. "dialMask1.png",
		overlayPath = nil,
		text        = true,
		textSize    = 24,
		textFont    = system.nativeFont,
		textColor   = _WHITE_,
		textSuffix  = "%",
		textPrefix  = "",
		percent     = 100,
	}

	local hud = display.newGroup()


	local size        = params.size or 128
	local dialSrc     = params.dialSrc or _DARKGREY_ 
	local backSrc     = params.backSrc or _BLACK_
	local maskPath    = params.maskPath or imagesDir .. "dialMask1.png"
	local text        = fnn(params.text, true)
	local textSize    = params.textSize or 10
	local textFont    = params.textFont or system.nativeFont
	local textColor   = params.textColor or _WHITE_
	local textSuffix  = params.textSuffix or "%"
	local textPrefix  = params.textPrefix or ""
	local percent     = params.percent or 100

	local dialGroup = display.newGroup()

	hud:insert(dialGroup)

	local maskInfo = ssk.pnglib.getPngInfo( maskPath ) 

	hud.mask = graphics.newMask( maskPath )
	hud:setMask( hud.mask )
	hud.maskScaleX = size / maskInfo.width
	hud.maskScaleY = size / maskInfo.height

	hud.maskX = size/2
	hud.maskY = size/2

	hud.leftBack    = display.newRect(dialGroup, 0,0,size/2,size)
	hud.leftBack:setReferencePoint( display.CenterRightReferencePoint )
	hud.leftBack.x = size/2
	hud.leftBack.y = size/2
	hud.leftBack:setFillColor( unpack(backSrc) )

	hud.leftDial    = display.newRect(dialGroup, 0,0,size/2,size)
	hud.leftDial:setReferencePoint( display.CenterRightReferencePoint )
	hud.leftDial.x = size/2
	hud.leftDial.y = size/2
	hud.leftDial:setFillColor( unpack(dialSrc) )

	hud.rightBack    = display.newRect(dialGroup, 0,0,size/2,size)
	hud.rightBack:setReferencePoint( display.CenterLeftReferencePoint )
	hud.rightBack.x = size/2
	hud.rightBack.y = size/2
	hud.rightBack:setFillColor( unpack(backSrc) )

	hud.rightDial    = display.newRect(dialGroup, 0,0,size/2,size)
	hud.rightDial:setReferencePoint( display.CenterLeftReferencePoint )
	hud.rightDial.x = size/2
	hud.rightDial.y = size/2
	hud.rightDial:setFillColor( unpack(dialSrc) )

	if(params.overlayPath) then
		hud.overlay    = display.newImageRect(hud, params.overlayPath, size,size)
		hud.overlay:setReferencePoint( display.CenterReferencePoint )
		hud.overlay.x = size/2
		hud.overlay.y = size/2
	end

	if(text) then
		hud.label  = display.newText( tostring(percent) .. "%", size/2, size/2, textFont, textSize )
		hud:insert(hud.label)
		hud.label:setTextColor( unpack( textColor ) )
		hud.label:setReferencePoint( display.CenterReferencePoint )
		hud.label.x = size/2
		hud.label.y = size/2

	end


	hud:setReferencePoint( display.CenterReferencePoint )
	hud.x,hud.y = x,y

	hud.getPercent = function( self )
		return self.percent
	end


	hud.setPercent = function( self, percent )
		local percent = percent
		if(percent < 0) then
			percent = 0
		elseif(percent > 100) then
			percent = 100
		end
		
		if( percent < 0 ) then
			self.rightDial.rotation = 0
			self.leftDial.rotation = 0
			self.rightDial.isVisible = true
		elseif( percent <  50 ) then
			self.rightDial.rotation = (percent/100 * 360)
			self.leftDial.rotation = 0
			self.rightDial.isVisible = true
		elseif( percent > 100 ) then
			self.rightDial.rotation = 180
			self.leftDial.rotation = 180
			self.rightDial.isVisible = false
		elseif( percent >= 50 ) then
			self.rightDial.rotation = 180
			self.leftDial.rotation = ((percent-50)/100 * 360)
			self.rightDial.isVisible = false
		end

		if(text) then
			self.label.text = textPrefix .. tostring(percent) .. textSuffix
			self.label:setReferencePoint( display.CenterReferencePoint )
			self.label.x = size/2
			self.label.y = size/2
		end

		self.percent = percent

	end

	--hud.percent = percent

	hud:setPercent( percent )

	group:insert( hud )

	return hud
end

-- =================================================
--  Percentage Bar
-- =================================================
function public:createPercentageBar( group, x, y, params )
	local params = params or 
	{
		w            = 128,
		h            = 32,
		barSrc     = _DARKGREY_,
		backSrc    = _BLACK_,
		maskPath     = imagesDir .. "barMask1.png",
		overlayPath  = nil,
		text         = true,
		textSize     = 24,
		textFont     = system.nativeFont,
		textColor    = _WHITE_,
		textSuffix   = "%",
		textPrefix   = "",
		textRotation = 0,
		textXScale   = 1,
		percent      = 100,
	}

	local hud = display.newGroup()


	local width        = params.w or 128
	local height       = params.h or 32
	local barSrc       = params.barSrc or _DARKGREY_ 
	local backSrc      = params.backSrc or _BLACK_
	local maskPath     = params.maskPath or imagesDir .. "barMask1.png"
	local overlayPath  = params.overlayPath or nil
	local text         = fnn(params.text, true)
	local textSize     = params.textSize or 10
	local textFont     = params.textFont or system.nativeFont
	local textColor    = params.textColor or _WHITE_
	local textSuffix   = params.textSuffix or "%"
	local textPrefix   = params.textPrefix or ""
	local textRotation = params.textRotation or 0
	local textXScale   = params.textXScale or 1
	local percent      = params.percent or 100
		
	local barGroup = display.newGroup()

	hud:insert(barGroup)

	local maskInfo = ssk.pnglib.getPngInfo( maskPath ) 


	hud.mask = graphics.newMask( maskPath )
	hud:setMask( hud.mask )
	hud.maskScaleX = width / maskInfo.width
	hud.maskScaleY = height/ maskInfo.height

	hud.spacer    = display.newRect(barGroup, 0,0,3*width,2*height)
	hud.spacer:setReferencePoint( display.CenterReferencePoint )
	hud.spacer.x = 0
	hud.spacer.y = 0
	hud.spacer:setFillColor( unpack(_TRANSPARENT_) )

	hud.backBar    = display.newRect(barGroup, 0,0,width,height)
	hud.backBar:setReferencePoint( display.CenterReferencePoint )
	hud.backBar:setFillColor( unpack(backSrc) )
	hud.backBar.x = 0		
	hud.backBar.y = 0

	hud.frontBar = display.newRect(barGroup, 0,0,width,height)
	hud.frontBar:setReferencePoint( display.CenterReferencePoint )
	hud.frontBar:setFillColor( unpack(barSrc) )
	hud.frontBar.x = -width
	hud.frontBar.y = 0


	if(overlayPath) then
		hud.overlay    = display.newImageRect(hud, params.overlayPath, width,height)
		hud.overlay:setReferencePoint( display.CenterReferencePoint )
		hud.overlay.x = 0
		hud.overlay.y = 0
	end

	if(text) then
		hud.label  = display.newText( tostring(percent) .. "%", width/2, height/2, textFont, textSize )
		hud:insert(hud.label)
		hud.label:setTextColor( unpack( textColor ) )
		hud.label:setReferencePoint( display.CenterReferencePoint )
		hud.label.x = 0
		hud.label.y = 0
		hud.label.rotation = textRotation
		hud.label.xScale = textXScale
	end

	hud:setReferencePoint( display.CenterReferencePoint )
	hud.x,hud.y = x,y

	hud.getPercent = function( self )
		return self.percent
	end
	
	hud.setPercent = function( self, percent )
		local percent = percent
		if(percent < 0) then
			percent = 0
		elseif(percent > 100) then
			percent = 100
		end

		self.frontBar.x = percent/100 * self.frontBar.width * -1

		if(text) then
			self.label.text = textPrefix .. tostring(percent) .. textSuffix
			self.label:setReferencePoint( display.CenterReferencePoint )
			self.label.x = 0
			self.label.y = 0
			hud.label.rotation = textRotation
			hud.label.xScale = textXScale

		end

		self.percent = percent

	end

	--hud.percent = percent

	hud:setPercent( percent )

	group:insert( hud )

	return hud
end


-- =================================================
--  Percentage Bar
-- =================================================
function public:createPercentageImageBar( group, x, y, params )
	local params = params or 
	{
		w            = 128,
		h            = 32,
		barSrc     = _DARKGREY_,
		maskPath     = imagesDir .. "barMask1.png",
		underlayPath  = nil,
		overlayPath  = nil,
		text         = true,
		textSize     = 24,
		textFont     = system.nativeFont,
		textColor    = _WHITE_,
		textSuffix   = "%",
		textPrefix   = "",
		textRotation = 0,
		textXScale   = 1,
		percent      = 100,
	}

	local hud = display.newGroup()


	local width        = params.w or 128
	local height       = params.h or 32
	local barSrc       = params.barSrc or _DARKGREY_ 
	local maskPath     = params.maskPath or imagesDir .. "barMask1.png"
	local underlayPath  = params.underlayPath or nil
	local overlayPath  = params.overlayPath or nil
	local text         = fnn(params.text, true)
	local textSize     = params.textSize or 10
	local textFont     = params.textFont or system.nativeFont
	local textColor    = params.textColor or _WHITE_
	local textSuffix   = params.textSuffix or "%"
	local textPrefix   = params.textPrefix or ""
	local textRotation = params.textRotation or 0
	local textXScale   = params.textXScale or 1
	local percent      = params.percent or 100
		
	if(underlayPath) then
		hud.underlay    = display.newImageRect(hud, underlayPath, width,height)
		hud.underlay:setReferencePoint( display.CenterReferencePoint )
		hud.underlay.x = 0
		hud.underlay.y = 0
	end

	hud.imageBar = display.newImageRect(hud, barSrc, width, height)
	hud.imageBar:setReferencePoint( display.CenterReferencePoint )
	hud.imageBar.x = -width
	hud.imageBar.y = 0

	print(maskPath)
	local maskInfo = ssk.pnglib.getPngInfo( maskPath ) 
	local mask = graphics.newMask( maskPath )
	hud.imageBar:setMask( mask )
	hud.imageBar.maskScaleX = 1--width / maskInfo.width
	hud.imageBar.maskScaleY = 1--height/ maskInfo.height

	if(overlayPath) then
		hud.overlay    = display.newImageRect(hud, overlayPath, width,height)
		hud.overlay:setReferencePoint( display.CenterReferencePoint )
		hud.overlay.x = 0
		hud.overlay.y = 0
	end

	if(text) then
		hud.label  = display.newText( tostring(percent) .. "%", width/2, height/2, textFont, textSize )
		hud:insert(hud.label)
		hud.label:setTextColor( unpack( textColor ) )
		hud.label:setReferencePoint( display.CenterReferencePoint )
		hud.label.x = 0
		hud.label.y = 0
		hud.label.rotation = textRotation
		hud.label.xScale = textXScale
	end

	hud:setReferencePoint( display.CenterReferencePoint )
	hud.x,hud.y = x,y

	hud.getPercent = function( self )
		return self.percent
	end
	
	hud.setPercent = function( self, percent )
		local percent = percent
		if(percent < 0) then
			percent = 0
		elseif(percent > 100) then
			percent = 100
		end

		hud.imageBar.maskX = percent/100 * self.imageBar.width * -1
		--self.imageBar.x = percent/100 * self.imageBar.width * -1

		if(text) then
			self.label.text = textPrefix .. tostring(percent) .. textSuffix
			self.label:setReferencePoint( display.CenterReferencePoint )
			self.label.x = 0
			self.label.y = 0
			hud.label.rotation = textRotation
			hud.label.xScale = textXScale

		end

		self.percent = percent

	end

	--hud.percent = percent

	hud:setPercent( percent )

	group:insert( hud )

	return hud
end


return public



