local M, C = BNUI[1], BNUI[2]
local BNUI_AddonLoader = CreateFrame("Frame")

local function BNUI_OnEvent(_, event, addonName)
    if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" and addonName == BNUI then        
	    M.Profiles:Initialize()
        M.GUI:Enable()
    end
end

BNUI_AddonLoader:RegisterEvent("ADDON_LOADED")
BNUI_AddonLoader:RegisterEvent("ADDON_LOADED")
BNUI_AddonLoader:SetScript("OnEvent", BNUI_OnEvent)