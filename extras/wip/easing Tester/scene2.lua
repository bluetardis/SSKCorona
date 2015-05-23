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
-- Forward Declarations

-- Callbacks/Functions
local onBack

-- Localizations


----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local group = self.view
	newImageRect( group, centerX, centerY, "img3.png", { w = w, h = h} )

	easyIFC:presetPush( group, "default", w - 50, h - 20, 100, 40, "Back", onBack )
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
	local options = { effect = nil, time = nil }
	composer.gotoScene( "scene1", options  )	
	return true
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
