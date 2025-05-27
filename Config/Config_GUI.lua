local M, C, L = BNUI[1], BNUI[2], BNUI[3]
local GUI = M["GUI"]

GUI.ConfigElements = {}

-- Define configuration functions for specific subcategories
GUI.ConfigElements["Chat"] = function(scrollContent)
    -- Assuming the title text is already in scrollContent at -10 from top
    local currentYOffset = -40 -- Starting Y position below the title text
    local spacing = 25 -- Vertical space between checkboxes
    local checkboxHeight = 26
    local numColumns = 4
    local checkboxesPerBlock = 5
    local totalCheckboxes = 20
    local blocksPerColumn = totalCheckboxes / (numColumns * checkboxesPerBlock)
    local columnWidth = scrollContent:GetWidth() / numColumns
    local scrollContentWidth = scrollContent:GetWidth()

    for i = 1, totalCheckboxes do
        -- Calculate which column and block this checkbox belongs to
        local column = math.floor((i - 1) / (checkboxesPerBlock * blocksPerColumn)) + 1
        local blockInColumn = math.floor(((i - 1) % (checkboxesPerBlock * blocksPerColumn)) / checkboxesPerBlock)
        local positionInBlock = ((i - 1) % checkboxesPerBlock) + 1
        
        -- Add a checkbox to the Chat scroll content frame
        local myCheckbox = CreateFrame("CheckButton", nil, scrollContent, "UICheckButtonTemplate")
        local xOffset = (column - 1) * columnWidth
        local yOffset = currentYOffset - (blockInColumn * (checkboxesPerBlock * spacing)) - ((positionInBlock - 1) * spacing)
        myCheckbox:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 20 + xOffset, yOffset)
        myCheckbox:SetSize(checkboxHeight, checkboxHeight)
        myCheckbox:SetScript("OnClick", function(self)
            print("Chat checkbox " .. i .. " clicked! Checked: " .. tostring(self:GetChecked()))
        end)

        -- Add text label for the checkbox
        myCheckbox.Text:SetFont("Fonts\\FRIZQT__.TTF", 12)
        myCheckbox.Text:SetText("Enable Chat Feature " .. i)
    end
        
    -- -- Add a divider under the title
    -- GUI:CreateDivider(scrollContent, 15, 30, 1)    
    local test = (5*checkboxHeight)+40
    GUI:CreateDivider(scrollContent, 15, test, 1)
    
    -- Calculate the total height needed for the scrollContent frame
    local totalContentHeight = math.abs(currentYOffset) + (5 * checkboxHeight) -- Height for 5 rows
    scrollContent:SetHeight(totalContentHeight)
end

GUI.ConfigElements["BNUI"] = function(scrollContent)
    -- Add a checkbox to the BNUI scroll content frame
    -- Assuming the title text is already in scrollContent at -10 from top
    local myCheckbox = CreateFrame("CheckButton", nil, scrollContent, "UICheckButtonTemplate")
    myCheckbox:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 20, -40) -- Position it below the title
    myCheckbox:SetSize(26, 26) -- Standard checkbox size
    myCheckbox:SetScript("OnClick", function(self)
        print("BNUI checkbox clicked! Checked: " .. tostring(self:GetChecked()))
    end)

    -- Add text label for the checkbox
    myCheckbox.Text:SetFont("Fonts\\FRIZQT__.TTF", 12)
    myCheckbox.Text:SetText("Enable BNUI Features")

    -- Set the height of the scrollContent frame (adjust as needed based on content)
    scrollContent:SetHeight(100) -- Example height, adjust based on actual content
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


