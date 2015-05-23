-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Sound Presets
-- =============================================================
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================

--
-- soundsInit.lua - Initialize Game Sounds
--
local mgr = ssk.sounds

local soundsPath = "data/rg_standardSounds/sounds/"

mgr:addEffect("good", soundsPath .. "good.wav")
mgr:addEffect("bad", soundsPath .. "bad.wav")
mgr:addMusic("Soundtrack", soundsPath .. "bouncing.mp3", nil, 1500)
