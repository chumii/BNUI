local M, C, L = BNUI[1], BNUI[2], BNUI[3]
local GUI = M["GUI"]
local Fonts = C["Media"]["Fonts"]
local Textures = C["Media"]["Textures"]

-- Initialize the DEV category if it doesn't exist
GUI.ConfigElements["DEV"] = GUI.ConfigElements["DEV"] or {}

GUI.ConfigElements["DEV"]["Dev"] = function(scrollContent)
    -- Create a checkbox for Dev mode with tooltip
    local firstCheckbox = GUI:CreateCheckbox(scrollContent, nil, "Enable Developer Mode", 20, -40, "Dev", "SettingOne", {
        title = "Developer Mode",
        text = "Enables additional developer features and debug information"
    })
    
    -- Create a checkbox without tooltip, anchored to the first checkbox
    local secondCheckbox = GUI:CreateCheckbox(scrollContent, firstCheckbox, "Another Setting", 0, 0, "Dev", "SettingTwo", nil)

    -- Create a new frame for the red box
    local redBox = CreateFrame("Frame", nil, scrollContent, "BackdropTemplate")

    -- Set the size and position
    redBox:SetHeight(50)
    redBox:SetWidth(250)
    redBox:SetPoint("TOPLEFT", secondCheckbox, "BOTTOMLEFT", 0, -10) 
    
    -- Set the background color to red
    redBox:SetBackdrop({
        bgFile = M.GetTexture("WGlass"),
        -- edgeFile = nil,
        -- tile = false,
        -- tileSize = 0,
        -- edgeSize = 0,
        -- insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    redBox:SetBackdropColor(1, 0, 0, 1) -- Red color (R,G,B,A)

    local testText = GUI:CreateFontString(scrollContent, "Roboto Slab Bold 14", Fonts.RobotoSlab_Bold, 14)
    testText:SetPoint("TOPLEFT", redBox, "BOTTOMLEFT", 0, -20)

    local testTextTwo = GUI:CreateFontString(scrollContent, "Passion One 18", Fonts.PassionOne, 18)
    testTextTwo:SetPoint("TOPLEFT", testText, "BOTTOMLEFT", 0, -10)

    local testTextThree = GUI:CreateFontString(scrollContent, "Expressway 14", Fonts.Expressway, 14)
    testTextThree:SetPoint("TOPLEFT", testTextTwo, "BOTTOMLEFT", 0, -10)

    local borderTestFrame = CreateFrame("Frame", nil, scrollContent, "BackdropTemplate")
    borderTestFrame:SetSize(200, 50)
    borderTestFrame:SetPoint("TOPLEFT", testTextThree, "BOTTOMLEFT", 0, -20)
    borderTestFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = Textures.BNUI_Border,
        edgeSize = 16,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    borderTestFrame:SetBackdropBorderColor(0.8, 0.8, 0.8, 1)
    borderTestFrame:SetBackdropColor(0, 0, 0, 0.8)

    
end 

