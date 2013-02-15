-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
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
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

-- ==
-- TheSSKCorona super object; Most libraries will be attached to this.
-- ==
local ssk = {}
_G.ssk = ssk 

-- ==
--    Early Loads: This stuff is used by subsequently loaded content and must be loaded FIRST.
-- ==
require( "ssk.libs.global" )		-- Various global functions
require( "ssk.libs.debugPrint" )	-- Level based debug printer
require( "ssk.libs.advanced" )		-- Advanced stuff (dig at your own peril; comments and criticisms welcomed)

-- ==
--    Extensions (To existing Lua Classes)
-- ==
require( "ssk.libs.extensions.io")
require( "ssk.libs.extensions.math")
require( "ssk.libs.extensions.string")
require( "ssk.libs.extensions.table")

-- ==
--    Core (i.e. Used a lot and often by other SSK Classes)
-- ==
require( "ssk.libs.core.math2d" )				-- 2D (vector) Math 
--require( "ssk.libs.core.math2d_intersects" )	-- 2D (vector) Math (Intersect Tests ++)

require( "ssk.libs.core.collisionCalculator" )	-- Collision Calculator 
require( "ssk.libs.core.debug" )  				-- Debugging Tools & Utilities
require( "ssk.libs.core.gem")					-- Game Event Manager
require( "ssk.libs.core.imageSheets" )			-- Image Sheets Manager
require( "ssk.libs.core.networking" )			-- Easy networking (layered on top of M.Y. Developer AutoLan)
require( "ssk.libs.core.points" )				-- Simple Points 
require( "ssk.libs.core.sounds" )				-- Sounds Manager

-- ==
--    Actions
-- ==
require( "ssk.libs.actions.aiming" )			-- Aims (and auto-aims) objects.
require( "ssk.libs.actions.facing" )			-- Facing using angles-per-second (not time).
require( "ssk.libs.actions.moving" )			-- Moving using pixels-per-second (not time).
--require( "ssk.libs.actions.pathing" )			-- Path following (offline)
require( "ssk.libs.actions.seeking" )			-- Target seeking (movement and aiming combined).

-- ==
--    Components
-- ==
require( "ssk.libs.components.addDrag" )		-- Adds basic or physics-based dragging in one step.
require( "ssk.libs.components.hasForce" )		-- Adds a single continuous (and controllable) force to an object.
require( "ssk.libs.components.hasForces" )		-- Adds multiple continuous (and controllable) forces to an object.
require( "ssk.libs.components.movesForward" )	-- Adds a single continuous (and controllable) forward force to an object.
												-- (A forward force always pushes in the direction the object is facing.)

-- ==
--    Display Objects
-- ==
require( "ssk.libs.display.extended" )			-- 'Extended' versions of display.newCircle, .newImageRect, and .newRect

require( "ssk.libs.display.layers" )			-- (Quick) Layering System
require( "ssk.libs.display.quitButton" )		-- Simple Quit Button (Used in many SSKCorona demos; Eventually I'll move this or phase this out.)
require( "ssk.libs.display.backImage" )			-- Easy Background Image Maker (Used in many SSKCorona demos; Eventually I'll move this or phase this out.)

require( "ssk.libs.display.arcs_ellipses" )		-- Arcs and Ellipses
require( "ssk.libs.display.lines" )				-- Various line builders
require( "ssk.libs.display.arrows" )			-- Various arrow builders


-- ==
--    External Libraries (Stuff Made By Others)
-- ==
ssk.ascii85     = require( "ssk.libs.external.SatheeshJM.ascii85" ) -- ASCI85 Encoding Utility
--ssk.cbe			= require( "ssk.libs.CBEffects.Library" )				-- CBEffects Particle System
ssk.ggchart		= require( "ssk.libs.external.GlitchGames.GGChart" )	-- Glitch Games Charts
ssk.ggcolor		= require( "ssk.libs.external.GlitchGames.GGColour" ):new()	-- Glitch Games Colour Codes

-- ==
--    Interface Building Stuff (Buttons, Labels, ... )
-- ==
require( "ssk.libs.interface.buttons" )					-- Buttons & Sliders
require( "ssk.libs.interface.huds" )					-- HUDs 
require( "ssk.libs.interface.labels" )					-- Labels
require( "ssk.libs.interface.standardButtonCallbacks" )	-- Standard Button & Slider Callbacks

-- ==
--    (Virtual) Input 'Devices'
-- ==
require( "ssk.libs.inputs.joystick" )		-- Joysticks/DPads
require( "ssk.libs.inputs.horizSnap" )		-- Horizontal Snap Slider (WARNING: IMPROVEMENTS ARE BEING MADE)
require( "ssk.libs.inputs.vertSnap" )		-- Vertical Snap Slider   (WARNING: IMPROVEMENTS ARE BEING MADE)

--require( "ssk.libs.inputs.inputs" )			-- Joysticks and Self-Centering Sliders 

-- ==
--    Miscellaneous
-- ==
require( "ssk.libs.dbmgr" )					-- (Rudimentary) DB Manager 
require( "ssk.libs.gamePiece")				-- Game Piece 
require( "ssk.libs.miscellaneous" )			-- Miscellaneous Utilities
require( "ssk.libs.sequencer" )				-- Movement++ Sequencer


-- ==
--    Configuration Work (REQUIRED)
-- ==

-- ==
--    Slated for removal.... so don't use this stuff
-- ==
ssk.behaviors = require( "ssk.libs.behaviors" )				-- Image Sheets Manager


