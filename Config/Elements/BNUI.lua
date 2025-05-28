local M, C, L = BNUI[1], BNUI[2], BNUI[3]
local GUI = M["GUI"]

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