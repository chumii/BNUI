local AddOnName, Engine = ...

local C_AddOns_GetAddOnMetadata = C_AddOns.GetAddOnMetadata

-- Engine Tables
Engine[1] = {} -- M Main
Engine[2] = {} -- C Config
Engine[3] = {} -- L Localization

local M, C, L = Engine[1], Engine[2], Engine[3]

-- Addon Info
M.Name = AddOnName
M.Title = C_AddOns_GetAddOnMetadata(AddOnName, "Title")
M.Version = C_AddOns_GetAddOnMetadata(AddOnName, "Version")
M.AddonColor = "14B8A6"

-- Player Info
M.Name = UnitName("player")
M.Class = select(2, UnitClass("player"))
M.Race = UnitRace("player")
M.Faction = UnitFactionGroup("player")
M.Level = UnitLevel("player")
M.Client = GetLocale()
M.Realm = GetRealmName()
M.Sex = UnitSex("player")
M.GUID = UnitGUID("player")

-- Initialize modules
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if event == "ADDON_LOADED" and addon == AddOnName then
        -- Load core modules
        M.Module:Get("Theme")
        M.Module:Get("UI")
        M.Module:Get("Chat")
        
        M:Print(M.Version .. " loaded")
    end
end)

-- Expose the Engine globally
_G.BNUI = Engine
