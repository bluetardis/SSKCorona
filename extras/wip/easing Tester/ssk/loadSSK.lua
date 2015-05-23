-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- SSKCorona Loader 
-- =============================================================
-- =============================================================

-- ==
-- TheSSKCorona super object; Most libraries will be attached to this.
-- ==
require "ssk.RGGlobals"
require "ssk.RGExtensions"

require "ssk.RGAds"
--require "ssk.RGAnalytics"

require "ssk.RGAndroidButtons" -- Conflicts with CoronaViewer
require "ssk.RGCamera"
require "ssk.RGCC"
require "ssk.RGDisplay"
require "ssk.RGEasyInterfaces"
require "ssk.RGEasyKeys"
require "ssk.RGEasyPush"
require "ssk.RGInputs"
require "ssk.RGMath2D"
require "ssk.RGTimerHUD"

require "ssk.RGEasySocial"

require "ssk.RGAutoLocalization"

require "ssk.RGShader"

require "ssk.presets.bluegel.presets"
require "ssk.presets.gel.presets"
require "ssk.presets.superpack.presets"

-- Modified version of GlitchGames' GGFile
ssk.GGFile = require( "ssk.external.GGFile" )

-- Modified version of Bjorn's OOP-ing code
ssk.object = require "ssk.external.object"

require "ssk.fixes.finalize"

ssk.randomlua = require "ssk.external.randomlua"

ssk.getVersion = function() return "31 AUG 2014" end

--[[
-- predictive aiming
--http://developer.coronalabs.com/code/predictive-aiming-tower-defense

-- EDOCHI add to math2d

function crossVec( a, b )
        return a.x * b.y - a.y * b.x;
end


-- As this code solves the target/bullet impact location the firing angle and bullet velocity x,y still need to be calculated.

-- source: http://stackoverflow.com/questions/2248876/2d-game-fire-at-a-moving-target-by-predicting-intersection-of-projectile-and-u
-- ref: http://gamedev.stackexchange.com/questions/25277/how-to-calculate-shot-angle-and-velocity-to-hit-a-moving-target

local tiny = 0.000001

quad = function (a,b,c)
	local sol -- var sol = null;
	if (math.abs(a) < tiny) then 
		if (math.abs(b) < tiny) then 
			if (math.abs(c) < tiny) then 
				sol = {x=0, y=0} else sol = nil 
			end 
		else
			sol = {x=-c/b, y=-c/b} 
		end 
	else 
		local disc = b*b - 4*a*c 
		if (disc >= 0) then 
			disc = math.sqrt(disc)
			a = 2*a
			sol = { x=(-b-disc)/a, y=(-b+disc)/a }
		end
	end
	return sol
end 

intercept =  function (src, dst, v, aimJitter) -- {
	if (dst.getLinearVelocity) then
		dst.vx, dst.vy = dst:getLinearVelocity()
	end

	-- EDOCHI
	if( aimJitter and aimJitter > 0) then
		local curJitter = mRand( -aimJitter, aimJitter )/100

		dst.vx = dst.vx * (1 + curJitter)
		dst.vy = dst.vy * (1 + curJitter)
	end


	local tx, ty, tvx, tvy = dst.x - src.x, dst.y - src.y, dst.vx, dst.vy 

	-- Get quadratic equation components
	local a = tvx*tvx + tvy*tvy - v*v 
	local b = 2 * (tvx * tx + tvy * ty)
	local c = tx*tx + ty*ty 

	-- Solve quadratic
	local ts = quad(a, b, c)

	-- Find smallest positive solution
	local sol 
	if (ts) then 
		local t0, t1 = ts.x, ts.y 
		local t = math.min(t0, t1) 
		if (t < 0) then 
			t=math.max(t0,t1) 
		end 

		if (t > 0) then
			sol = {x=dst.x + dst.vx*t, y=dst.y + dst.vy*t} 
		end 
	end 

	return sol, sol ~= nil
end 
 
]]
-- Advanced Logger: http://forums.coronalabs.com/topic/50004-corona-advanced-logging/ 
-- q: Quick oneliner way to print calling function file: name: args?
-- Consider LUA DOCS
-- http://forums.coronalabs.com/topic/39094-code-for-rotated-rectangle-collision-detection/
  -- --http://gamedevelopment.tutsplus.com/tutorials/collision-detection-with-the-separating-axis-theorem--gamedev-169
-- Lots of intereesting samples; https://github.com/Poordeveloper/corona_code/tree/master/Game
-- Lua FFT https://github.com/vection/LuaFFT 
-- Lua Neural Nets - https://github.com/wixico/luann 
-- add slider (in this somewhere) http://www.csse.monash.edu.au/~cema/fugu/
-- Lua Cookbook - https://github.com/lua-cookbook/lua-cookbook/wiki/The-table-of-contents 
-- Tween Lua - https://github.com/kikito/tween.lua
-- hump - http://vrld.github.io/hump/
   -- -- EXCEPTIONALLY USEFUL FOR IMPROVING MY MATH 2D - https://github.com/vrld/hump/blob/master/vector.lua 
-- Moses lua library http://forums.coronalabs.com/topic/49461-liblua-moses-140/#entry255866 
-- https://gist.github.com/HoraceBury/9431861
-- http://forums.coronalabs.com/topic/49570-displaynewpolygon-path/#entry256518 
-- Tagged Timers - https://github.com/swipeware/taggedtimer
-- predict arc - http://gamasutra.com/blogs/AlexRose/20140711/220882/2D_Physics_Analytically_Targeted_Rigidbody_Projectiles.php?elq=f690aa0946694576a11358d24daaf324&elqCampaignId=6210 
-- https://github.com/dedoubleyou1/Corona-Flipbook-Module
-- Add sprite support to buttons
-- http://forums.coronalabs.com/topic/47691-looking-for-feedbacksuggestions-on-my-free-bitmap-font-library-bit-like-textcandy/
-- http://coronalabs.com/blog/2013/05/21/tutorial-using-zip-plugin/
-- math http://developer.coronalabs.com/code/elitemath
-- depth sorthable groups https://github.com/Rakoonic/Sprite-sorting
-- Math https://gist.github.com/Xeoncross/9511295
-- Pie Chart - http://ragdogstudios.com/?p=1401
-- Create Complex Non-Convex Bodies - http://code.coronalabs.com/code/create-complex-non-convex-bodies
-- https://bitbucket.org/develephant/mod_pushbots/wiki/Home (https://pushbots.com/)
-- set reference piont for graphics 2.0 http://code.coronalabs.com/code?field_code_group_tid=All&sort_by=created_1&sort_order=DESC&page=2
-- cb effects http://code.coronalabs.com/code/cbeffects-visual-effects-engine
-- drop box integration http://code.coronalabs.com/code/dropbox
-- complex non-convex http://code.coronalabs.com/code/create-complex-non-convex-bodies
-- perspective camera http://code.coronalabs.com/code/perspective-virtual-camera-system
-- GPS dist calc http://code.coronalabs.com/code/calculate-distances-between-markers-and-sort-them-longitude-latitude-your-gps-position
-- RESTful API class http://code.coronalabs.com/code/restful-apis
-- fluid simulation http://code.coronalabs.com/code/fluid-simulation-meta-balls
-- lerg performance meter http://code.coronalabs.com/code/performance-meter-corona-sdk
-- try me (exploder) http://code.coronalabs.com/code/polygon-exploder-and-triangulator
-- saving to sqlite db http://code.coronalabs.com/code/dbconfig
-- Extract Horace Bury's math lib stuff http://code.coronalabs.com/code/arrow-drag-applied-tail-feathers
-- bitmapped font http://code.coronalabs.com/code/bitmap-font
-- Finger painting http://code.coronalabs.com/code/finger-paint-library-add-finger-painting-just-one-line-code
-- Color Picker: http://code.coronalabs.com/code/color-picker-color-picker-your-app-just-one-line-code
-- FFT - http://winter.sgv417.jp/alchemy/download/lib/fft.lua
-- http://forums.coronalabs.com/topic/46486-set-up-a-noobhub-multiplayer-server-in-5-minutes/
-- This as first step test to itersection: http://www.gamefromscratch.com/post/2012/12/12/GameDev-math-recipes-Collision-detection-using-bounding-circles.aspx
-- http://phoenixce.wordpress.com/2012/11/21/a-couple-of-velocity-snippets/
-- http://vrld.github.io/HardonCollider/reference.html
-- http://coronalabs.com/blog/2013/07/23/tutorial-non-physics-collision-detection/
-- http://quangnle.wordpress.com/2012/12/30/corona-sdk-curve-fitting-1-implementation-of-ramer-douglas-peucker-algorithm-to-reduce-points-of-a-curve/
   -- http://www.mediafire.com/download/qm35otvtm91iapr/PointReduce.zip
-- https://github.com/ProGM/CoronaSDK-win-native
-- http://developer.coronalabs.com/code/grid-manipulation-sample-code
-- http://coronalabs.com/blog/2013/02/11/using-the-ios-built-in-twitter-feature/
-- http://coronalabs.com/blog/2013/08/06/introducing-the-social-plugin-ios/
-- http://coronalabs.com/blog/2013/02/05/ios-tutorial-using-email-attachments/
-- http://coronalabs.com/blog/2013/12/17/tutorial-introducing-the-pasteboard-plugin-ios/
-- http://www.develephant.net/using-google-licensing-to-protect-your-corona-sdk-app/
-- http://forums.coronalabs.com/topic/41900-using-google-licensing-to-protect-your-corona-sdk-app-in-3-steps/
-- http://forums.coronalabs.com/topic/41618-aligning-groups-no-reference-pointno-problem/
-- (anchorChildren) http://coronalabs.com/blog/2013/10/15/tutorial-anchor-points-in-graphics-2-0/

-- Parse:
--[[
https://bitbucket.org/develephant/mod_parse/wiki/Home

http://www.ladeezfirstmedia.com/2014/02/09/parse-com-corona-sdk-integration-tutorials-updated/

http://www.ladeezfirstmedia.com/2013/06/26/tutorial-part-1-cloud-code-integrate-parse-coms-rest-api-with-your-coronasdk-app/
http://www.ladeezfirstmedia.com/2013/06/30/tutorial-part-2-parsedata-coronasdk-parsemodules-ftw/
http://www.ladeezfirstmedia.com/2013/07/08/tutorial-part-3-create-a-website-for-your-coronasdk-app-using-parse-coms-javascript-sdk/
http://www.ladeezfirstmedia.com/2013/07/28/tutorial-4-upload-a-photo-from-your-corona-sdk-app-to-parse-com/
http://www.ladeezfirstmedia.com/2013/08/01/tutorial-part-5-push-it-real-good-with-push-notifications-using-corona-sdk-and-parse-com/
http://www.ladeezfirstmedia.com/2013/10/03/tutorial-part-6-use-parse-com-as-a-cdn-for-your-corona-sdk-app/

]]
--
-- 
--[[

local function easyPositioner( self, event )
	if( event.phase == "moved" ) then 
		self.x = event.x
		self.y = event.y
	else
		print(self.x, self.y)
	end
	return true
end
_G.addEasyPositioner = function( obj )
	obj.touch = easyPositioner
	obj:addEventListener( "touch" )
end
--addEasyPositioner( launchLogo )

--]]