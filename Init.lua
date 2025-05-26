local AddOnName, Engine = ...

local C_AddOns_GetAddOnMetadata = C_AddOns.GetAddOnMetadata

-- Engine Tables
Engine[1] = {} -- M Main
Engine[2] = {} -- C Config
Engine[3] = {} -- L Localization

local M, C, L = Engine[1], Engine[2], Engine[3]

M.Name = AddOnName
M.Title = C_AddOns_GetAddOnMetadata(AddOnName, "Title")
M.Version = C_AddOns_GetAddOnMetadata(AddOnName, "Version")
M.AddonColor = "14B8A6"

-- Test
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if event == "ADDON_LOADED" and addon == AddOnName then
        M:Print(M.Title .. " " .. M.Version)
        M.GUI:Enable()
    end
end)



-- Expose the Engine globally
_G.BNUI = Engine
