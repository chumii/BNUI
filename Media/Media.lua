local M, C = BNUI[1], BNUI[2]
local mediaFolder = M.MediaFolder

C["Media"] = {
	["Statusbars"] = {
		AltzUI = mediaFolder .. "Statusbars\\AltzUI.tga",
		AsphyxiaUI = mediaFolder .. "Statusbars\\AsphyxiaUI.tga",
		AzeriteUI = mediaFolder .. "Statusbars\\AzeriteUI.tga",
		Clean = mediaFolder .. "Statusbars\\Clean.tga",
		Flat = mediaFolder .. "Statusbars\\Flat.tga",
		Glamour7 = mediaFolder .. "Statusbars\\Glamour7.tga",
		GoldpawUI = mediaFolder .. "Statusbars\\GoldpawUI.tga",
		KkthnxUI = mediaFolder .. "Statusbars\\Statusbar",
		Kui = mediaFolder .. "Statusbars\\KuiStatusbar.tga",
		KuiBright = mediaFolder .. "Statusbars\\KuiStatusbarBright.tga",
		Ohi_Dragon = mediaFolder .. "Statusbars\\Ohi_Dragon.tga",
		Palooza = mediaFolder .. "Statusbars\\Palooza.tga",
		PinkGradient = mediaFolder .. "Statusbars\\PinkGradient.tga",
		Rain = mediaFolder .. "Statusbars\\Rain.tga",
		SkullFlowerUI = mediaFolder .. "Statusbars\\SkullFlowerUI.tga",
		Tukui = mediaFolder .. "Statusbars\\ElvTukUI.tga",
		WGlass = mediaFolder .. "Statusbars\\Wglass.tga",
		Water = mediaFolder .. "Statusbars\\Water.tga",
		ZorkUI = mediaFolder .. "Statusbars\\ZorkUI.tga",
	},
}

local statusbars = C["Media"].Statusbars
local defaultTexture = statusbars.KkthnxUI

function M.GetTexture(texture)
	-- Check if the texture exists in your custom media
	if statusbars[texture] then
		return statusbars[texture]
	end

	-- Check if LibSharedMedia is loaded and has the texture
	if M.LibSharedMedia then
		local libTexture = M.LibSharedMedia:Fetch("statusbar", texture)
		if libTexture then
			return libTexture
		end
	end

	-- Fallback to the default texture if neither are found
	return defaultTexture
end

-- Register your custom media with LibSharedMedia if it's loaded
if M.LibSharedMedia then
	for mediaType, mediaTable in pairs(C["Media"]) do
		for name, path in pairs(mediaTable) do
			M.LibSharedMedia:Register(mediaType, name, path)
		end
	end
end