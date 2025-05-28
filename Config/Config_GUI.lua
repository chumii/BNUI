local M, C, L = BNUI[1], BNUI[2], BNUI[3]
local GUI = M["GUI"]

GUI.ConfigElements = {}

-- Define configuration functions for specific subcategories
GUI.ConfigElements["Chat"] = function(scrollContent)
     -- Create a new frame for the red box
     local redBox = CreateFrame("Frame", nil, scrollContent, "BackdropTemplate")
    
     -- Set the size and position
     redBox:SetHeight(5000)
     redBox:SetPoint("TOPLEFT", scrollContent.Divider, "BOTTOMLEFT", 0, -10) -- 10px spacing from divider
     redBox:SetPoint("TOPRIGHT", scrollContent.Divider, "BOTTOMRIGHT", 0, -10)
     
     -- Set the background color to red
     redBox:SetBackdrop({
         bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
         edgeFile = nil,
         tile = false,
         tileSize = 0,
         edgeSize = 0,
         insets = { left = 0, right = 0, top = 0, bottom = 0 }
     })
     redBox:SetBackdropColor(1, 1, 0, 1) -- Red color (R,G,B,A)
end

GUI.ConfigElements["BNUI"] = function(scrollContent)
    -- Create a new frame for the red box
    local redBox = CreateFrame("Frame", nil, scrollContent, "BackdropTemplate")
    
    -- Set the size and position
    redBox:SetHeight(5000)
    redBox:SetPoint("TOPLEFT", scrollContent.Divider, "BOTTOMLEFT", 0, -10) -- 10px spacing from divider
    redBox:SetPoint("TOPRIGHT", scrollContent.Divider, "BOTTOMRIGHT", 0, -10)
    
    -- Set the background color to red
    redBox:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = nil,
        tile = false,
        tileSize = 0,
        edgeSize = 0,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    redBox:SetBackdropColor(1, 0, 0, 1) -- Red color (R,G,B,A)
end

GUI.ConfigElements["Dev"] = function(scrollContent)
    -- Create a new frame for the red box
    local redBox = CreateFrame("Frame", nil, scrollContent, "BackdropTemplate")
    
    -- Set the size and position
    redBox:SetHeight(5000)
    redBox:SetPoint("TOPLEFT", scrollContent.Divider, "BOTTOMLEFT", 0, -10) -- 10px spacing from divider
    redBox:SetPoint("TOPRIGHT", scrollContent.Divider, "BOTTOMRIGHT", 0, -10)
    
    -- Set the background color to red
    redBox:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = nil,
        tile = false,
        tileSize = 0,
        edgeSize = 0,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    redBox:SetBackdropColor(1, 1, 1, 1) -- Red color (R,G,B,A)
end

GUI.ConfigElements["Player"] = function(scrollContent)
        -- Create a new frame for the red box
        local redBox = CreateFrame("Frame", nil, scrollContent, "BackdropTemplate")
    
        -- Set the size and position
        redBox:SetHeight(500)
        redBox:SetPoint("TOPLEFT", scrollContent.Divider, "BOTTOMLEFT", 0, -10) -- 10px spacing from divider
        redBox:SetPoint("TOPRIGHT", scrollContent.Divider, "BOTTOMRIGHT", 0, -10)
        
        -- Set the background color to red
        redBox:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = nil,
            tile = false,
            tileSize = 0,
            edgeSize = 0,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        redBox:SetBackdropColor(0, 0, 1, 1) -- Red color (R,G,B,A)
end

-- Main function to initialize config elements based on registered functions
function GUI:InitializeConfigElements()
    -- Iterate through all registered config functions
    for subcategoryText, configFunc in pairs(GUI.ConfigElements) do
        -- Find the corresponding subcategory button
        local subcategoryButton
        for _, category in ipairs(self.Categories) do
            for _, subcategory in ipairs(category.subcategories) do
                if subcategory.Text:GetText() == subcategoryText then
                    subcategoryButton = subcategory
                    break
                end
            end
            if subcategoryButton then break end
        end

        -- If the subcategory is found and has a content frame, call the config function
        if subcategoryButton and subcategoryButton.scrollContent then
            configFunc(subcategoryButton.scrollContent)
        end
    end
end




