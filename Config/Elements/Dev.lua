local M, C, L = BNUI[1], BNUI[2], BNUI[3]
local GUI = M["GUI"]

GUI.ConfigElements["Dev"] = function(scrollContent)
    -- Create a checkbox for Dev mode with tooltip
    local firstCheckbox = GUI:CreateCheckbox(scrollContent, nil, "Enable Developer Mode", 20, -40, "Dev", "SettingOne", {
        title = "Developer Mode",
        text = "Enables additional developer features and debug information"
    })
    
    -- Create a checkbox without tooltip, anchored to the first checkbox
    GUI:CreateCheckbox(scrollContent, firstCheckbox, "Another Setting", 0, 0, "Dev", "SettingTwo", nil)
end 