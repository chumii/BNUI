local M, C, L = BNUI[1], BNUI[2], BNUI[3]
local GUI = M["GUI"]

GUI.ConfigElements = {}

-- Main function to initialize config elements based on registered functions
function GUI:InitializeConfigElements()
    -- Iterate through all registered config functions
    for categoryName, categoryData in pairs(GUI.ConfigElements) do
        -- Find the corresponding category
        local categoryButton
        for _, category in ipairs(self.Categories) do
            if category.key == categoryName then
                categoryButton = category
                break
            end
        end

        -- If category is found, process its subcategories
        if categoryButton then
            for subcategoryText, configFunc in pairs(categoryData) do
                -- Find the corresponding subcategory button
                local subcategoryButton
                for _, subcategory in ipairs(categoryButton.subcategories) do
                    if subcategory.key == subcategoryText then
                        subcategoryButton = subcategory
                        break
                    end
                end

                -- If the subcategory is found and has a content frame, call the config function
                if subcategoryButton and subcategoryButton.scrollContent then
                    configFunc(subcategoryButton.scrollContent)
                end
            end
        end
    end
end