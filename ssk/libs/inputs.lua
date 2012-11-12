-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Input Objects Factory
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

--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print


-- EFM Convert all of these to use parameters
-- EFM Add skinning

local inputsFactory = {}

-- =======================
-- ====================== Joystick
-- =======================
--[[
h ssk.inputs:createJoystick
d Creates a simple joystick input device on the screen.
d <br>'''WARNING!''' - This feature is scheduled for a change.  The function arguments will be changing in the future... 10 NOV 2012
d <br>
d <br> This joystick sends out global (Runtime) named messages when it is moved/touched.  These messages take the form { name == ''eventName'', angle=[0.0, 360.0), vx=[0.0, N.M], vy=[0.0, N.M], nx=[0.0, 1.0], ny=[0.0, 1.0], percent=[0.0, 1.0], phase = "began/moved/ended", state = "on/off" }) 
s ssk.inputs:createJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, group )
s * x,y - The position at which to place the center of the joystick. 
s * outerRadius - Radius of joystick outer circle. Represents radius within which the joystick is considered to be off.
s * deadZoneRadius - - Radius of joystick dead-zone circle.
s * stickRadius - - Radius of joystick stick circle.  This is the part representing the joystick knob.
s * eventName - A string containing the name of the event the joystick is to post (dispatch) when the stick is moved.
s * group - A display group to insert the joystick into.
r A reference to the joystick object.
--]]
function inputsFactory:createJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, group )

	local joystick  = display.newGroup()

	local eventName = eventName or "joystickEvent"

	if( group ) then
		group:insert(joystick)
	end
	

	local outerRing  = ssk.display.circle( joystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 4, 
		  radius = outerRadius, myName = "aJoystick" }, nil, nil ) 
	outerRing.alpha = 0.50
	
	local innerRing  = ssk.display.circle( joystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  radius = deadZoneRadius, myName = "aJoystick" }, nil, nil ) 
	innerRing.alpha = 0.50

	local stick  = ssk.display.circle( joystick, x, y,
		{ fill = _GREY_, stroke = _GREY_, strokeWidth = 0, 
		  radius = stickRadius, myName = "aJoystick" }, nil, nil ) 

	local radiusDelta = outerRadius - deadZoneRadius
	
	function joystick:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			stick.x,stick.y = event.x, event.y
		end

		local vx,vy = ssk.math2d.sub(outerRing.x, outerRing.y, event.x, event.y)
		local nx,ny = ssk.math2d.normalize(vx,vy)

		if(vx == 0 ) then
			nx = 0
		else
			nx = round(nx,4)
		end

		if(vy == 0 ) then
			ny = 0
		else
			ny = round(ny,4)	
		end

		local angle 

		if(nx == 0 and ny == 0 ) then
			angle = 0
		else
			angle = ssk.math2d.vector2Angle(vx,vy)
		end

		local vLen  = ssk.math2d.length(vx,vy)
		
		local iLen  = vLen - deadZoneRadius

		local percent = 0

		if(event.phase == "began") then
			if(iLen < 0) then
				percent = 0
			elseif(iLen > radiusDelta) then
				percent = 1
			else
				percent = iLen/radiusDelta
			end

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x,stick.y = outerRing.x, outerRing.y

				angle = 0
				vx = 0
				vy = 0
				nx = 0
				ny = 0
				percent = 0

			elseif(event.phase == "moved") then
				if(vLen <= outerRadius ) then
					stick.x,stick.y = event.x, event.y
				else
					local dx,dy = ssk.math2d.angle2Vector(angle)
					dx,dy = ssk.math2d.scale(dx,dy,outerRadius)
					stick.x,stick.y = ssk.math2d.add( outerRing.x, outerRing.y, dx,dy)
				end
				if(iLen < 0) then
					percent = 0
				elseif(iLen > radiusDelta) then
					percent = 100
				else
					percent = round(iLen/radiusDelta,4) * 100
				end
			end
		end
		
		dprint(2, round(angle,2), round(nx,2), round(ny,2), round(percent,2))
		if(percent == 0 ) then
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "off" })
		else
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "on" })
		end
		return true
	end

	outerRing:addEventListener( "touch", joystick )		

	function joystick:destroy( event )
--[[ EFM remove me?
		outerRing:removeEventListener( "touch", joystick )		
		stick:removeSelf()
		innerRing:removeSelf()
		outerRing:removeSelf()
--]]
	end
	return joystick
end

-- =======================
-- ====================== Virtual Joystick
-- =======================
--[[
h ssk.inputs:createVirtualJoystick
d Creates a simple joystick input device on the screen.  Unlike the one created with ''createJoystick'', the touch input source is an external objects.  
d <br>'''Note:''' This object is hidden until touches occur on the input object and then it is un-hidden and moved to the point of the touch.  On release, it is re-hidden.
d <br>'''WARNING!''' - This feature is scheduled for a change.  The function arguments will be changing in the future... 10 NOV 2012
d <br>
d <br> This joystick sends out global (Runtime) named messages when it is moved/touched.  These messages take the form { name == ''eventName'', angle=[0.0, 360.0), vx=[0.0, N.M], vy=[0.0, N.M], nx=[0.0, 1.0], ny=[0.0, 1.0], percent=[0.0, 1.0], phase = "began/moved/ended", state = "on/off" }) 
s ssk.inputs:createVirtualJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, inputObj, group )
s * x,y - The position at which to place the center of the joystick. 
s * outerRadius - Radius of joystick outer circle. Represents radius within which the joystick is considered to be off.
s * deadZoneRadius - - Radius of joystick dead-zone circle.
s * stickRadius - - Radius of joystick stick circle.  This is the part representing the joystick knob.
s * eventName - A string containing the name of the event the joystick is to post (dispatch) when the stick is moved.
s * inputObj - An object that takes touch inputs and sends them to the 'virtual' joystick.
s * group - A display group to insert the joystick into.
r A reference to the 'virtual' joystick object.
--]]
function inputsFactory:createVirtualJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, inputObj, group )

	local virtualJoystick  = display.newGroup()

	local eventName = eventName or "joystickEvent"

	if( not inputObj ) then
		error("inputObj argument required for virtualJoystick")
	end
	
	if( group ) then
		group:insert(virtualJoystick)
	end

	local outerRing  = ssk.display.circle( virtualJoystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 4, 
		  radius = outerRadius, myName = "aJoystick" }, nil, nil ) 
	outerRing.alpha = 0.50
	
	local innerRing  = ssk.display.circle( virtualJoystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  radius = deadZoneRadius, myName = "aJoystick" }, nil, nil ) 

	local stick  = ssk.display.circle( virtualJoystick, x, y,
		{ fill = _GREY_, stroke = _GREY_, strokeWidth = 0, 
		  radius = stickRadius, myName = "aJoystick" }, nil, nil ) 
	innerRing.alpha = 0.50

	local radiusDelta = outerRadius - deadZoneRadius

	virtualJoystick.isVisible = false

	function virtualJoystick:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true

			local newX,newY = event.x,event.y

			if( (newX + outerRing.width/2) >= w) then
				newX = w - outerRing.width/2
			end

			if( (newX - outerRing.width/2) <= 0 ) then
				newX = outerRing.width/2
			end

			if( (newY + outerRing.height/2) >= h) then
				newY = h - outerRing.height/2
			end

			if( (newY - outerRing.height/2) <= 0) then
				newY = outerRing.height/2
			end

			outerRing.x,outerRing.y = newX, newY
			innerRing.x,innerRing.y = newX, newY
			stick.x,stick.y = event.x,event.y
			virtualJoystick.isVisible = true
		end

		local vx,vy = ssk.math2d.sub(outerRing.x, outerRing.y, event.x, event.y)
		local nx,ny = ssk.math2d.normalize(vx,vy)

		if(vx == 0 ) then
			nx = 0
		else
			nx = round(nx,4)
		end

		if(vy == 0 ) then
			ny = 0
		else
			ny = round(ny,4)	
		end

		local angle 

		if(nx == 0 and ny == 0 ) then
			angle = 0
		else
			angle = ssk.math2d.vector2Angle(vx,vy)
		end

		local vLen  = ssk.math2d.length(vx,vy)
		
		local iLen  = vLen - deadZoneRadius

		local percent = 0

		if(event.phase == "began") then
			if(iLen < 0) then
				percent = 0
			elseif(iLen > radiusDelta) then
				percent = 1
			else
				percent = iLen/radiusDelta
			end

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x,stick.y = outerRing.x, outerRing.y

				angle = 0
				vx = 0
				vy = 0
				nx = 0
				ny = 0
				percent = 0

				virtualJoystick.isVisible = false

			elseif(event.phase == "moved") then
				if(vLen <= outerRadius ) then
					stick.x,stick.y = event.x, event.y
				else
					local dx,dy = ssk.math2d.angle2Vector(angle)
					dx,dy = ssk.math2d.scale(dx,dy,outerRadius)
					stick.x,stick.y = ssk.math2d.add( outerRing.x, outerRing.y, dx,dy)
				end
				if(iLen < 0) then
					percent = 0
				elseif(iLen > radiusDelta) then
					percent = 100
				else
					percent = round(iLen/radiusDelta,4) * 100
				end
			end
		end
		
		dprint(2, round(angle,2), round(nx,2), round(ny,2), round(percent,2))
		if(percent == 0 ) then
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "off" })
		else
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "on" })
		end
		return true
	end


	inputObj:addEventListener( "touch", virtualJoystick )			

	function virtualJoystick:destroy( event )
--[[ EFM remove me?
		inputObj:removeEventListener( "touch", virtualJoystick )		
		stick:removeSelf()
		innerRing:removeSelf()
		outerRing:removeSelf()
--]]	
	end
	return virtualJoystick
end

-- =======================
-- ====================== horizSnap
-- =======================
--[[
h ssk.inputs:createHorizontalSnap
d Creates a horizontal input bar that snaps back to center when the 'stick' is released.
d <br>'''WARNING!''' - This feature is scheduled for a change.  The function arguments will be changing in the future... 10 NOV 2012
d <br>
d <br> This snap device sends out global (Runtime) named messages when it is moved/touched.  These messages take the form { name == ''eventName'', angle=[0.0, 360.0), vx=[0.0, N.M], vy=[0.0, N.M], nx=[0.0, 1.0], ny=[0.0, 1.0], percent=[0.0, 1.0], phase = "began/moved/ended", state = "on/off" }) 
s ssk.inputs:createHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, group )
s * x,y - The position at which to place the center of the snap device. 
s * snapHeight,snapWidth - Width and height of the snap device.
s * deadZoneRadius - Width of snap device dead-zone.
s * stickSize - Width of the 'stick'.
s * eventName - A string containing the name of the event the snap device is to post (dispatch) when the stick is moved.
s * group - A display group to insert the snap device into.
r A reference to the snap device object.
--]]
function inputsFactory:createHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, group )

	local horizSnap  = display.newGroup()

	local eventName = eventName or "horizSnapEvent"

	if( group ) then
		group:insert(horizSnap)
	end

	local horizSnapOutline  = ssk.display.rect( horizSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  width = snapWidth, height = snapHeight, myName = "ahorizSnap" }, nil, nil ) 
	horizSnapOutline.alpha = 0.50

	local horizSnapDeadZone  = ssk.display.rect( horizSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   width = deadZoneWidth, height = snapHeight-2, myName = "ahorizSnap" }, nil, nil ) 
	horizSnapDeadZone.alpha = 0.50

	local stick  = ssk.display.rect( horizSnap, x, y,
		{ fill = _DARKGREY_, 
		  width = stickSize, height = snapHeight-2, myName = "ahorizSnap" }, nil, nil ) 
		
	function horizSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		local vx = event.x - horizSnapOutline.x 
		local direction = "left"

		if(vx > 0) then
			direction = "right"
		end

		local magnitude = math.abs(vx)
		local maxMag = snapWidth/2
		local minMag = deadZoneWidth/2

		local percent = 0

		if(magnitude < minMag) then
			percent = 0
		elseif(magnitude > maxMag) then
			percent = 100
		else
			percent = round(magnitude/(maxMag-minMag),2) * 100
		end

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			stick.x = event.x

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x = horizSnapOutline.x
				
				vx=0
				percent=0
				direction = "center"


			elseif(event.phase == "moved") then
				stick.x = event.x
				if(percent == 100 and direction == "left" ) then
					stick.x = horizSnapOutline.x - horizSnapOutline.width/2
				elseif(percent == 100 and direction == "right" ) then
					stick.x = horizSnapOutline.x + horizSnapOutline.width/2
				end
			end
		end
		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	horizSnapOutline:addEventListener( "touch", horizSnap )		


	function horizSnap:destroy( event )
--[[ EFM remove me?
		horizSnapOutline:removeEventListener( "touch", horizSnap )		
		stick:removeSelf()
		horizSnapDeadZone:removeSelf()
		horizSnapOutline:removeSelf()
--]]
	end
		
	return horizSnap
end

-- =======================
-- ====================== virtualHorizSnap
-- =======================
--[[
h ssk.inputs:createVirtualHorizontalSnap
d Creates a horizontal input bar that snaps back to center when the 'stick' is released.
d <br>'''Note:''' This object is hidden until touches occur on the input object and then it is un-hidden and moved to the point of the touch.  On release, it is re-hidden.
d <br>'''WARNING!''' - This feature is scheduled for a change.  The function arguments will be changing in the future... 10 NOV 2012
d <br>
d <br> This snap device sends out global (Runtime) named messages when it is moved/touched.  These messages take the form { name == ''eventName'', angle=[0.0, 360.0), vx=[0.0, N.M], vy=[0.0, N.M], nx=[0.0, 1.0], ny=[0.0, 1.0], percent=[0.0, 1.0], phase = "began/moved/ended", state = "on/off" }) 
s ssk.inputs:createVirtualHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, group )
s * x,y - The position at which to place the center of the snap device. 
s * snapHeight,snapWidth - Width and height of the snap device.
s * deadZoneRadius - Width of snap device dead-zone.
s * stickSize - Width of the 'stick'.
s * eventName - A string containing the name of the event the snap device is to post (dispatch) when the stick is moved.
s * inputObj - An object that takes touch inputs and sends them to the 'virtual' snap device.
s * group - A display group to insert the snap device into.
r A reference to the snap device object.
--]]
function inputsFactory:createVirtualHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, inputObj, group )

	local virtualhorizSnap  = display.newGroup()

	local eventName = eventName or "horizSnapEvent"

	if( not inputObj ) then
		error("inputObj argument required for virtualJoystick")
	end

	if( group ) then
		group:insert(virtualhorizSnap)
	end

	local horizSnapOutline  = ssk.display.rect( virtualhorizSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  width = snapWidth, height = snapHeight, myName = "avirtualhorizSnap" }, nil, nil ) 
	horizSnapOutline.alpha = 0.50

	local horizSnapDeadZone  = ssk.display.rect( virtualhorizSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   width = deadZoneWidth, height = snapHeight-2, myName = "avirtualhorizSnap" }, nil, nil ) 
	horizSnapDeadZone.alpha = 0.50

	local stick  = ssk.display.rect( virtualhorizSnap, x, y,
		{ fill = _DARKGREY_, 
		  width = stickSize, height = snapHeight-2, myName = "avirtualhorizSnap" }, nil, nil ) 

	virtualhorizSnap.isVisible = false
		
	function virtualhorizSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			
			local newX,newY = event.x,event.y

			if( (newX + horizSnapOutline.width/2) >= w) then
				newX = w - horizSnapOutline.width/2
			end

			if( (newX - horizSnapOutline.width/2) <= 0 ) then
				newX = horizSnapOutline.width/2
			end

			if( (newY + horizSnapOutline.height/2) >= h) then
				newY = h - horizSnapOutline.height/2
			end

			if( (newY - horizSnapOutline.height/2) <= 0) then
				newY = horizSnapOutline.height/2
			end

			horizSnapOutline.x,horizSnapOutline.y = newX, newY
			horizSnapDeadZone.x,horizSnapDeadZone.y = newX, newY
			stick.x,stick.y = event.x,newY

			virtualhorizSnap.isVisible = true
		end

		local vx = event.x - horizSnapOutline.x 
		local direction = "left"

		if(vx > 0) then
			direction = "right"
		end

		local magnitude = math.abs(vx)
		local maxMag = snapWidth/2
		local minMag = deadZoneWidth/2

		local percent = 0

		if(magnitude < minMag) then
			percent = 0
		elseif(magnitude > maxMag) then
			percent = 100
		else
			percent = round(magnitude/(maxMag-minMag),2) * 100
		end

		if(event.phase == "began") then

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x = horizSnapOutline.x				
				vx=0
				percent=0
				direction = "center"

				virtualhorizSnap.isVisible = false

			elseif(event.phase == "moved") then
				stick.x = event.x
				if(percent == 100 and direction == "left" ) then
					stick.x = horizSnapOutline.x - horizSnapOutline.width/2
				elseif(percent == 100 and direction == "right" ) then
					stick.x = horizSnapOutline.x + horizSnapOutline.width/2
				end
			end
		end
		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	inputObj:addEventListener( "touch", virtualhorizSnap )		


	function virtualhorizSnap:destroy( event )
--[[ EFM remove me?
		inputObj:removeEventListener( "touch", virtualhorizSnap )		
		stick:removeSelf()
		horizSnapDeadZone:removeSelf()
		horizSnapOutline:removeSelf()
--]]
	end
		
	return virtualhorizSnap
end

-- =======================
-- ====================== vertSnap
-- =======================
--[[
h ssk.inputs:createVerticalSnap
d Creates a vertical input bar that snaps back to center when the 'stick' is released.
d <br>'''WARNING!''' - This feature is scheduled for a change.  The function arguments will be changing in the future... 10 NOV 2012
d <br>
d <br> This snap device sends out global (Runtime) named messages when it is moved/touched.  These messages take the form { name == ''eventName'', angle=[0.0, 360.0), vx=[0.0, N.M], vy=[0.0, N.M], nx=[0.0, 1.0], ny=[0.0, 1.0], percent=[0.0, 1.0], phase = "began/moved/ended", state = "on/off" }) 
s ssk.inputs:createVerticalSnap( x, y, snapWidth, snapHeight, deadZoneWidth, stickSize, eventName, group )
s * x,y - The position at which to place the center of the snap device. 
s * snapWidth,snapHeight - Width and height of the snap device.
s * deadZoneRadius - Width of snap device dead-zone.
s * stickSize - Width of the 'stick'.
s * eventName - A string containing the name of the event the snap device is to post (dispatch) when the stick is moved.
s * group - A display group to insert the snap device into.
r A reference to the snap device object.
--]]
function inputsFactory:createVerticalSnap( x, y, snapWidth, snapHeight, deadZoneHeight, stickSize, eventName, group )

	local vertSnap  = display.newGroup()

	local eventName = eventName or "vertSnapEvent"

	if( group ) then
		group:insert(vertSnap)
	end

	local vertSnapOutline  = ssk.display.rect( vertSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  width = snapWidth, height = snapHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapOutline.alpha = 0.50

	local vertSnapDeadZone  = ssk.display.rect( vertSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   width = snapWidth-2, height = deadZoneHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapDeadZone.alpha = 0.50

	local stick  = ssk.display.rect( vertSnap, x, y,
		{ fill = _DARKGREY_, 
		  width = snapWidth, height = stickSize, myName = "avertSnap" }, nil, nil ) 

	function vertSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		local vy = event.y - vertSnapOutline.y 
		local direction = "up"

		if(vy > 0) then
			direction = "down"
		end

		local magnitude = math.abs(vy)
		local maxMag = snapHeight/2
		local minMag = deadZoneHeight/2

		local percent = 0

		if(magnitude < minMag) then
			percent = 0
		elseif(magnitude > maxMag) then
			percent = 100
		else
			percent = round(magnitude/(maxMag-minMag),2) * 100
		end

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			stick.y = event.y

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.y = vertSnapOutline.y
				
				vy=0
				percent=0
				direction = "center"


			elseif(event.phase == "moved") then
				stick.y = event.y
				if(percent == 100 and direction == "up" ) then
					stick.y = vertSnapOutline.y - vertSnapOutline.height/2
				elseif(percent == 100 and direction == "down" ) then
					stick.y = vertSnapOutline.y + vertSnapOutline.height/2
				end
			end
		end
		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	vertSnapOutline:addEventListener( "touch", vertSnap )		


	function vertSnap:destroy( event )
--[[ EFM remove me?
		vertSnapOutline:removeEventListener( "touch", vertSnap )		
		stick:removeSelf()
		vertSnapDeadZone:removeSelf()
		vertSnapOutline:removeSelf()
--]]
	end

	return vertSnap
end


-- =======================
-- ====================== virtualVertSnap
-- =======================

--[[
h ssk.inputs:createVirtualVerticalSnap
d Creates a vertical input bar that snaps back to center when the 'stick' is released.
d <br>'''Note:''' This object is hidden until touches occur on the input object and then it is un-hidden and moved to the point of the touch.  On release, it is re-hidden.
d <br>'''WARNING!''' - This feature is scheduled for a change.  The function arguments will be changing in the future... 10 NOV 2012
d <br>
d <br> This snap device sends out global (Runtime) named messages when it is moved/touched.  These messages take the form { name == ''eventName'', angle=[0.0, 360.0), vx=[0.0, N.M], vy=[0.0, N.M], nx=[0.0, 1.0], ny=[0.0, 1.0], percent=[0.0, 1.0], phase = "began/moved/ended", state = "on/off" }) 
s ssk.inputs:createVirtualVerticalSnap( x, y, snapWidth, snapHeight, deadZoneWidth, stickSize, eventName, group )
s * x,y - The position at which to place the center of the snap device. 
s * snapWidth,snapHeight - Width and height of the snap device.
s * deadZoneRadius - Width of snap device dead-zone.
s * stickSize - Width of the 'stick'.
s * eventName - A string containing the name of the event the snap device is to post (dispatch) when the stick is moved.
s * inputObj - An object that takes touch inputs and sends them to the 'virtual' snap device.
s * group - A display group to insert the snap device into.
r A reference to the snap device object.
--]]
function inputsFactory:createVirtualVerticalSnap( x, y, snapWidth, snapHeight, deadZoneHeight, stickSize, eventName, inputObj, group )

	local virtualVertSnap  = display.newGroup()

	local eventName = eventName or "vertSnapEvent"

	if( not inputObj ) then
		error("inputObj argument required for virtualJoystick")
	end

	if( group ) then
		group:insert(virtualVertSnap)
	end

	local vertSnapOutline  = ssk.display.rect( virtualVertSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  width = snapWidth, height = snapHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapOutline.alpha = 0.50

	local vertSnapDeadZone  = ssk.display.rect( virtualVertSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   width = snapWidth-2, height = deadZoneHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapDeadZone.alpha = 0.50

	local stick  = ssk.display.rect( virtualVertSnap, x, y,
		{ fill = _DARKGREY_, 
		  width = snapWidth, height = stickSize, myName = "avertSnap" }, nil, nil ) 

	virtualVertSnap.isVisible = false

	function virtualVertSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			
			local newX,newY = event.x,event.y

			if( (newX + vertSnapOutline.width/2) >= w) then
				newX = w - vertSnapOutline.width/2
			end

			if( (newX - vertSnapOutline.width/2) <= 0 ) then
				newX = vertSnapOutline.width/2
			end

			if( (newY + vertSnapOutline.height/2) >= h) then
				newY = h - vertSnapOutline.height/2
			end

			if( (newY - vertSnapOutline.height/2) <= 0) then
				newY = vertSnapOutline.height/2
			end

			vertSnapOutline.x,vertSnapOutline.y = newX, newY
			vertSnapDeadZone.x,vertSnapDeadZone.y = newX, newY
			stick.x,stick.y = newX, event.y

			virtualVertSnap.isVisible = true
		end

		local vy = event.y - vertSnapOutline.y 
		local direction = "up"

		if(vy > 0) then
			direction = "down"
		end

		local magnitude = math.abs(vy)
		local maxMag = snapHeight/2
		local minMag = deadZoneHeight/2

		local percent = 0

		if(magnitude < minMag) then
			percent = 0
		elseif(magnitude > maxMag) then
			percent = 100
		else
			percent = round(magnitude/(maxMag-minMag),2) * 100
		end

		if(event.phase == "began") then

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.y = vertSnapOutline.y

				vy=0
				percent=0
				direction = "center"

				virtualVertSnap.isVisible = false

			elseif(event.phase == "moved") then
				stick.y = event.y
				if(percent == 100 and direction == "up" ) then
					stick.y = vertSnapOutline.y - vertSnapOutline.height/2
				elseif(percent == 100 and direction == "down" ) then
					stick.y = vertSnapOutline.y + vertSnapOutline.height/2
				end
			end
		end		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	inputObj:addEventListener( "touch", virtualVertSnap )		

	function virtualVertSnap:destroy( event )
--[[ EFM remove me?
		inputObj:removeEventListener( "touch", virtualVertSnap )		
		stick:removeSelf()
		vertSnapDeadZone:removeSelf()
		vertSnapOutline:removeSelf()
--]]
	end

	return virtualVertSnap
end


return inputsFactory