-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- User Globals
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
--  Modify global settings here, and not in "ssk/globals.lua".
--
-- =============================================================

-- Global application name used in various places, but most importantly, used in networking
-- Make this unique for every game you produce
_G.myAppName = "SSKCorona Game Frame"

-- Date of last update and/or release
--
_G.releaseDate = "14 FEB 2013"

-- (Global) Debug messaging level (used by debugPrint): 
--
-- Warning: These values may be overwritten locally
--
-- 0  - None
-- 1  - Basic messages
-- 2  - Intermediate debug output
-- 3+ - Full debug output (may be very noisy)
_G.debugLevel = 1

-- Outline colors (if used)
_G.topLineColor      = {0,0,0,180}
_G.botLineColor      = {255,255,255,200}

--Multiplayer settings
-- multiplayerMode ==> "OFF", "2P_AUTO", "2P_EASY", "MP_MANUAL"
_G.multiplayerMode = "OFF" 
--_G.multiplayerMode = "2P_AUTO" 
--_G.multiplayerMode = "MP_MANUAL" 
--_G.multiplayerMode = "2P_EASY" -- THIS MODE NOT YET AVAILABLE

