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

-- local f = CreateFrame("Frame")
-- f:RegisterEvent("ADDON_LOADED")
-- f:SetScript("OnEvent", function(self, event, addon)
--     if event == "ADDON_LOADED" and addon == AddOnName then
--         -- Load core modules
--         M.Module:Get("Theme")
--         M.Module:Get("UI")
--         M.Module:Get("Chat")
        
--         M:Print(M.Version .. " loaded")
--     end
-- end)

-- Tables
local eventsFrame = CreateFrame("Frame")
local events = {}
local registeredEvents = {}

-- Event Handler
function M:RegisterEvent(event, func, unit1, unit2)
	if event == "CLEU" then
		event = "COMBAT_LOG_EVENT_UNFILTERED"
	end

	-- Check if the event is already registered with the function
	if events[event] and events[event][func] then
		return
	end

	if not events[event] then
		events[event] = {}
		if unit1 then
			eventsFrame:RegisterUnitEvent(event, unit1, unit2)
		else
			eventsFrame:RegisterEvent(event)
		end
	end

	events[event][func] = true

	if not registeredEvents[event] then
		registeredEvents[event] = {}
	end
	table.insert(registeredEvents[event], func)
end

function M:UnregisterEvent(event, func)
	if event == "CLEU" then
		event = "COMBAT_LOG_EVENT_UNFILTERED"
	end

	local funcs = events[event]
	if funcs and funcs[func] then
		funcs[func] = nil

		if not next(funcs) then
			events[event] = nil
			eventsFrame:UnregisterEvent(event)
		end
	end

	if registeredEvents[event] then
		for i, f in ipairs(registeredEvents[event]) do
			if f == func then
				table.remove(registeredEvents[event], i)
				break
			end
		end
	end
end

-- Add the event handler to the frame
eventsFrame:SetScript("OnEvent", function(self, event, ...)
	if events[event] then
		for func in pairs(events[event]) do
			func(...)
		end
	end
end)

M:RegisterEvent("PLAYER_LOGIN", function()
    -- Set CVars, UI Scale etc
    
    -- Initialize all modules in registration order
    M.Module:LoadAll()
    
    M:Print(M.Version .. " loaded")
end)

-- Expose the Engine globally
_G.BNUI = Engine
