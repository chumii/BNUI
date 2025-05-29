local M, C, L = BNUI[1], BNUI[2], BNUI[3]
local GUI = M["GUI"]

GUI.ConfigElements["Dev"] = function(scrollContent)
    -- Create a checkbox for Dev mode
    local checkbox = CreateFrame("CheckButton", nil, scrollContent, "InterfaceOptionsCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 20, -40)
    checkbox.Text:SetText("Enable Developer Mode")
    
    -- Set the initial state based on profile or default
    checkbox:SetChecked(M.Profiles:GetSetting("Dev", "SettingOne"))
    
    -- Add tooltip
    checkbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Developer Mode", 1, 1, 1)
        GameTooltip:AddLine("Enables additional developer features and debug information", 0.7, 0.7, 0.7, true)
        GameTooltip:Show()
    end)
    checkbox:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    -- Handle checkbox changes
    checkbox:SetScript("OnClick", function(self)
        M.Profiles:SetSetting("Dev", "SettingOne", self:GetChecked())
    end)
end 