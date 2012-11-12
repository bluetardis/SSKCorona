-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- SSKCorona Loader 
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
-- Load this module in main.lua to load all of the SSKCorona library with just one call.
-- ================================================================================

-- ==
-- TheSSKCorona super object; Most libraries will be attached to this.
-- ==
local ssk = {}
_G.ssk = ssk 

-- ==
--    Early Loads: This stuff is used by subsequently loaded content and must be loaded FIRST.
-- ==
ssk.debugprinter	= require("ssk.libs.debugPrint")				-- Level based debug printer
ssk.advanced		= require( "ssk.libs.advanced" )				-- Advanced stuff (dig at your own peril; comments and criticisms welcomed)

-- ==
--    Addons - Add extra functionality to existing libs, module, and global space.
--             This stuff is also often used in other libraries, so gets loaded 
--             before the bulk of the libraries
-- ==
require( "ssk.libs.global")
require( "ssk.libs.io")
require( "ssk.libs.math")
require( "ssk.libs.string")
require( "ssk.libs.table")

-- ==
--    Libraries
-- ==
ssk.behaviors	= require( "ssk.libs.behaviors" )				-- Behaviors Manager
ssk.bench		= require( "ssk.libs.benchmarking" )			-- Benchmarking Utilities
ssk.buttons		= require( "ssk.libs.buttons" )					-- Buttons & Sliders Factory
ssk.ccmgr		= require( "ssk.libs.collisionCalculator" )		-- Collision Calculator (EFM actually a factory now)
ssk.component	= require( "ssk.libs.components" )				-- Misc Game Components (Mechanics, etc.)
ssk.dbmgr		= require( "ssk.libs.dbmgr" )					-- (Rudimentary) DB Manager Factory
ssk.display		= require( "ssk.libs.display" )  				-- Prototyping Game Objects Factory
ssk.gem			= require( "ssk.libs.gem")						-- Game Event Manager
ssk.huds		= require( "ssk.libs.huds" )					-- HUDs Factory
ssk.inputs		= require( "ssk.libs.inputs" )					-- Joysticks and Self-Centering Sliders Factory
ssk.labels		= require( "ssk.libs.labels" )					-- Labels Factory
ssk.math2d		= require( "ssk.libs.math2d" )					-- 2D (vector) Math 
ssk.misc		= require( "ssk.libs.miscellaneous" )			-- Miscellaneous Utilities
ssk.networking	= require( "ssk.libs.networking" )              -- Easy networking utilities (layered on top of M.Y. Developer AutoLan)
ssk.pnglib		= require( "ssk.libs.external.pngLib.pngLib" )				-- Utility lib for extracting PNG image metrics
ssk.points		= require( "ssk.libs.points" )					-- Simple Points Factory (table of points)
ssk.sbc			= require( "ssk.libs.standardButtonCallbacks" )	-- Standard Button & Slider Callbacks
ssk.sheetmgr	= require( "ssk.libs.imageSheets" )				-- Image Sheets Manager
ssk.sounds		= require( "ssk.libs.sounds" )					-- Sounds Manager


-- ==
--    Configuration Work (REQUIRED)
-- ==
ssk.networking:registerCallbacks()

