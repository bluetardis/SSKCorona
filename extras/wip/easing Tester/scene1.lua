local newCircle,newRect,newImageRect,easyIFC,ternary,quickLayers,isDisplayObject,easyPushButton,isInBounds,angle2Vector,vector2Angle,scaleVec,addVec,subVec,getNormals,lenVec,lenVec2,normVec,mAbs,mRand,mDeg,mRad,mCos,mSin,mAcos,mAsin,mSqrt,mCeil,mFloor,mAtan2,mPi,getInfo,getTimer,strMatch,strFormat,pairs,fnn;ssk.al.run()
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
--
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables

local subEasingLabel
local easingLabel
local timeLabel

local img
local dir = 1
local dir2 = 1

-- Forward Declarations

-- Callbacks/Functions
local onTest
local onTest2

local onEasing
local onSubEasing
local onTime

local subEasings = {"", "in", "inOut", "out", "outIn"}

local easings = {
	"linear",
	"Back", 
	"Bounce", 
	"Circ", 
	"Cubic", 
	"Elastic", 
	"Expo", 
	"Quad", 
	"Quart", 
	"Quint", 
	"Sine", 
}

local curSub = 1
local curEasing = 1
local curTime = 1

local times = {}
for i = 1, 100 do
	times[i] = i * 100
end


-- Localizations


----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local group = self.view
	newRect( group, centerX, centerY, { w = w, h = h, fill = _LIGHTGREY_ }  )

	img = newImageRect( group, centerX - 70, centerY-80, "img2.png", { w = 128 * 1.25, h = 228 * 1.25 }  )

	easyIFC:presetPush( group, "default", 50, h - 20, 100, 40, "Test1", onTest )
	easyIFC:presetPush( group, "default", w - 50, h - 20, 100, 40, "Test2", onTest2 )

	subEasingLabel = easyIFC:quickLabel( group, subEasings[curSub], centerX, centerY + 90, nil, 22, _K_ )
	local tmp = easyIFC:presetPush( group, "default", centerX - 120, subEasingLabel.y, 30, 30, "-", onSubEasing )
	tmp.incr = -1
	local tmp = easyIFC:presetPush( group, "default", centerX + 120, subEasingLabel.y, 30, 30, "+", onSubEasing )
	tmp.incr = 1


	easingLabel = easyIFC:quickLabel( group, easings[curEasing], centerX, centerY + 125, nil, 22, _K_ )
	local tmp = easyIFC:presetPush( group, "default", centerX - 120, easingLabel.y, 30, 30, "-", onEasing )
	tmp.incr = -1
	local tmp = easyIFC:presetPush( group, "default", centerX + 120, easingLabel.y, 30, 30, "+", onEasing )
	tmp.incr = 1

	timeLabel = easyIFC:quickLabel( group, times[curTime], centerX, centerY + 160, nil, 22, _K_ )
	local tmp = easyIFC:presetPush( group, "default", centerX - 120, timeLabel.y, 30, 30, "-", onTime )
	tmp.incr = -1
	local tmp = easyIFC:presetPush( group, "default", centerX + 120, timeLabel.y, 30, 30, "+", onTime )
	tmp.incr = 1



end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
end


----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
end


----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onTest = function ( event ) 
	local time = tonumber(timeLabel.text)
	local sub = tostring(subEasingLabel.text)
	local curEasing = tostring(easingLabel.text)

	if(curEasing ~= "linear") then
		curEasing = sub .. curEasing
	end

	print(dir, time, curEasing)

	if(dir == 1) then
		dir = 2
		transition.to( img, { xScale = 0.05, yScale = 0.05, time = time, transition = easing[curEasing]  } )
	else 
		dir = 1
		transition.to( img, { xScale = 1, yScale = 1, time = time, transition = easing[curEasing]  } )
	end

	event.target.alpha = 0

	transition.to( event.target, { delay = time, alpha = 1, time = 0 } )

	return true
end

onTest2 = function ( event ) 
	local time = tonumber(timeLabel.text)
	local sub = tostring(subEasingLabel.text)
	local curEasing = tostring(easingLabel.text)

	if(curEasing ~= "linear") then
		curEasing = sub .. curEasing
	end

	print(dir2, time, curEasing)

	if(dir2 == 1) then
		dir2 = 2
		transition.to( img, { x = centerX + 70, time = time, transition = easing[curEasing]  } )
	else 
		dir2 = 1
		transition.to( img, { x = centerX - 70, time = time, transition = easing[curEasing]  } )
	end

	event.target.alpha = 0

	transition.to( event.target, { delay = time, alpha = 1, time = 0 } )

	return true
end



onEasing = function( event )
	local incr = event.target.incr
	curEasing = curEasing+incr
	if(curEasing>#easings) then curEasing = 1 end
	if(curEasing<1) then curEasing = #easings end
	easingLabel.text = easings[curEasing]
end

onSubEasing = function( event )
	local incr = event.target.incr
	curSub = curSub+incr
	if(curSub>#subEasings) then curSub = 1 end
	if(curSub<1) then curSub = #subEasings end
	subEasingLabel.text = subEasings[curSub]
end

onTime = function( event )
	local incr = event.target.incr
	curTime = curTime+incr
	if(curTime>#times) then curTime = 1 end
	if(curTime<1) then curTime = #times end
	timeLabel.text = times[curTime]
end

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	screenGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	screenGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willExit( event )
	elseif( willDid == "did" ) then
		self:didExit( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
