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

local sceneOverlayLabel
local easingLabel
local timeLabel

-- Forward Declarations

-- Callbacks/Functions
local onBack

local onSceneOverlay
local onEasing
local onTime

local sceneOverlay = { "scene", "overlay" }

local easings = {
	"fade",
	"crossFade",
	"zoomOutIn",
	"zoomOutInFade",
	"zoomInOut",
	"zoomInOutFade",
	"flip",
	"flipFadeOutIn",
	"zoomOutInRotate",
	"zoomOutInFadeRotate",
	"zoomInOutRotate",
	"zoomInOutFadeRotate",
	"fromRight",
	"fromLeft",
	"fromTop",
	"fromBottom",
	"slideLeft",
	"slideRight",
	"slideDown",
	"slideUp"
}

local curSO = 2
local curEasing = 16
local curTime = 5

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
	newImageRect( group, centerX, centerY, "img1.png", { w = w, h = h} )

	easyIFC:presetPush( group, "default", w - 50, h - 20, 100, 40, "Test", onBack )

	sceneOverlayLabel = easyIFC:quickLabel( group, sceneOverlay[curSO], centerX, centerY + 90, nil, 22, _K_ )
	local tmp = easyIFC:presetPush( group, "default", centerX - 120, sceneOverlayLabel.y, 30, 30, "-", onSceneOverlay )
	tmp.incr = -1
	local tmp = easyIFC:presetPush( group, "default", centerX + 120, sceneOverlayLabel.y, 30, 30, "+", onSceneOverlay )
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


table.print_r(composer.effectList)


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
onBack = function ( event ) 
	local time = tonumber(timeLabel.text)
	local curEasing = tostring(easingLabel.text)
	local options = { effect = curEasing, time = time}
	if( sceneOverlayLabel.text == "overlay" ) then
		composer.showOverlay( "scene2", options  )	
	else
		composer.gotoScene( "scene2", options  )	
	end
	return true
end


onSceneOverlay = function( event )
	local incr = event.target.incr
	curSO = curSO+incr
	if(curSO>#sceneOverlay) then curSO = 1 end
	if(curSO<1) then curSO = #sceneOverlay end
	sceneOverlayLabel.text = sceneOverlay[curSO]
end


onEasing = function( event )
	local incr = event.target.incr
	curEasing = curEasing+incr
	if(curEasing>#easings) then curEasing = 1 end
	if(curEasing<1) then curEasing = #easings end
	easingLabel.text = easings[curEasing]
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
