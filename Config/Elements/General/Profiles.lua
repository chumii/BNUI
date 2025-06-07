local M, C, L = BNUI[1], BNUI[2], BNUI[3]
local GUI = M["GUI"]
local Fonts = C["Media"]["Fonts"]

GUI.ConfigElements["General"] = GUI.ConfigElements["General"] or {}

GUI.ConfigElements["General"]["Profiles"] = function(scrollContent)
    local spacing = 10
    local elementWidth = 150
    local elementHeight = 25
    -- local labelWidth = 150
    
    -- Create dropdown for current profile
    local function UpdateProfileDropdown()
        local profiles = M.Profiles:GetAvailableProfiles()
        local options = {}
        for _, profile in ipairs(profiles) do
            table.insert(options, {
                text = profile,
                value = profile
            })
        end
        return options
    end
    
    -- Current Profile Section
    local currentProfileLabel, profileDropdown = GUI:CreateLabeledDropdown(scrollContent, nil, "Current Profile", 20, -50, elementWidth,
        UpdateProfileDropdown(), M.CurrentProfile.name,
        function(value)
            M.Profiles:ChangeProfile(value)
        end
    )
    
    -- Create New Profile Section
    local newProfileLabel, newProfileEditBox = GUI:CreateLabeledEditBox(scrollContent, currentProfileLabel, "Create New Profile", 0, -spacing*3, elementWidth, elementHeight, "", nil)
    
    -- Add create button next to the editbox
    local createButton = GUI:CreateButton(scrollContent, newProfileEditBox, "Create Profile Button", 5, 0, 80, elementHeight,
        function()
            local text = newProfileEditBox:GetText()
            if text and text ~= "" then
                M.Profiles:CreateProfile(text)
                newProfileEditBox:SetText("")
                -- Update the dropdown after creating new profile
                profileDropdown:GetScript("OnShow")(profileDropdown)
            end
        end
    )
    
    -- Copy Profile Section
    local copyProfileLabel, copyProfileDropdown = GUI:CreateLabeledDropdown(scrollContent, newProfileLabel, "Copy Settings From", 0, -spacing*3, elementWidth,
        UpdateProfileDropdown(), "",
        function(value)
            if value and value ~= "" then
                M.Profiles:CopyProfile(value)
            end
        end
    )
    
    -- Delete Profile Section
    local deleteProfileLabel, deleteProfileDropdown = GUI:CreateLabeledDropdown(scrollContent, copyProfileLabel, "Delete Profile", 0, -spacing*3, elementWidth,
        UpdateProfileDropdown(), "",
        function(value)
            if value and value ~= "" then
                -- Show confirmation dialog
                StaticPopupDialogs["BNUI_DELETE_PROFILE"] = {
                    text = "Are you sure you want to delete the profile '" .. value .. "'?\nIf this is your active profile, you will be switched to the Default profile.",
                    button1 = YES,
                    button2 = NO,
                    OnAccept = function()
                        M.Profiles:DeleteProfile(value)
                        -- Update the dropdowns after deleting profile
                        profileDropdown:GetScript("OnShow")(profileDropdown)
                        copyProfileDropdown:GetScript("OnShow")(copyProfileDropdown)
                        deleteProfileDropdown:GetScript("OnShow")(deleteProfileDropdown)
                    end,
                    timeout = 0,
                    whileDead = true,
                    hideOnEscape = true,
                }
                StaticPopup_Show("BNUI_DELETE_PROFILE")
            end
        end
    )
end