-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- WIP
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
local kernel = {}
kernel.name = "tickShader"
kernel.language = "glsl"
kernel.category = "filter"

kernel.graph =
{
   nodes = {
      horizontal = { effect="filter.blurHorizontal", input1="paint1" },
      vertical = { effect="filter.blurVertical", input1="horizontal" },
   },
   output = "vertical",
}


return kernel