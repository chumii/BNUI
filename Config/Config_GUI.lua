local M, C, L = BNUI[1], BNUI[2], BNUI[3]
local GUI = M["GUI"]

GUI.ConfigElements = {}

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