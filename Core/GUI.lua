local M, C = BNUI[1], BNUI[2]

local UIParent = UIParent
local CreateFrame = CreateFrame

local GuiWidth = 1100
local GuiHeight = 700 -- for testing
local Spacing = 30
local CategoryHeight = 30
local SubcategoryHeight = 25

local GUI = CreateFrame("Frame", "BNUI_GUI", UIParent, "DefaultPanelTemplate")
GUI.Windows = {}
GUI.Buttons = {}
GUI.Widgets = {}
GUI.Categories = {}

-- Helper function to create a category button
function GUI:CreateCategory(parent, text, yPosition)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(parent:GetWidth(), CategoryHeight)
    -- Position using the calculated absolute Y position from AddCategory
    button:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -yPosition)
    
    -- Button background
    button:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    button:SetBackdropColor(0.2, 0.2, 0.2, 0.8)
    button:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.8)
    
    -- Button text
    button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    button.Text:SetFont("Fonts\\FRIZQT__.TTF", 12)
    button.Text:SetPoint("CENTER", 0, 0)
    button.Text:SetText(text)
    
    return button
end

-- Helper function to create a subcategory button
function GUI:CreateSubCategory(parent, text, yPosition)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(parent:GetWidth(), SubcategoryHeight)
    -- Position using the calculated absolute Y position from AddCategory
    button:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -yPosition)
    
    -- Button background
    button:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    button:SetBackdropColor(0.15, 0.15, 0.15, 0)
    button:SetBackdropBorderColor(0.5, 0.5, 0.5, 0)
    
    -- Button text
    button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    button.Text:SetFont("Fonts\\FRIZQT__.TTF", 12)
    button.Text:SetPoint("LEFT", 10, 0)
    button.Text:SetText(text)
    
    -- Button highlight
    button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    
    -- Button state
    button:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.25, 0.25, 0.25, 0.8)
    end)
    button:SetScript("OnLeave", function(self)
        if not self.selected then
            self:SetBackdropColor(0.15, 0.15, 0.15, 0)
        end
    end)

    -- Create the content frame for this subcategory (ScrollFrame)
    local guiFrame = parent:GetParent() -- Get back to the main GUI frame
    local contentFrame = CreateFrame("ScrollFrame", nil, guiFrame.SettingsArea, "ScrollFrameTemplate") -- Use the template
    contentFrame:SetPoint("TOPLEFT", guiFrame.SettingsArea, "TOPLEFT", 0, -20)
    contentFrame:SetPoint("BOTTOMRIGHT", guiFrame.SettingsArea, "BOTTOMRIGHT", 0, 20) -- Add 10 pixel padding at bottom
    contentFrame:Hide() -- Initially hide the scroll frame

    -- Create the inner frame that will hold the actual scrollable content
    local scrollContent = CreateFrame("Frame", nil, contentFrame) -- Parented to the ScrollFrame
    scrollContent:SetPoint("TOPLEFT", 0, 0)
    scrollContent:SetSize(guiFrame.SettingsArea:GetWidth(), 10) -- Minimum height, will be updated by config funcs

    -- Set the inner frame as the scroll child of the ScrollFrame
    contentFrame:SetScrollChild(scrollContent)

    -- The ScrollFrameTemplate includes a scrollbar, so we don't need to create and attach it manually here.
    -- The scrollbar will be accessible as contentFrame.ScrollBar

    -- Add the subcategory title to the INNER content frame for testing
    local titleText = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleText:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 20, 0)
    titleText:SetText(text)
    titleText:SetTextColor(1, 1, 1, 1)

    -- Add Divider under Title
    GUI:CreateDivider(scrollContent, 15, 30, 1)   

    -- Store references on the button
    button.scrollContent = scrollContent -- Inner frame for content
    button.contentFrame = contentFrame -- The ScrollFrame itself
    
    -- Store position and height for AddCategory calculation
    button.yPosition = yPosition
    button.height = SubcategoryHeight

    -- OnClick script
    button:SetScript("OnClick", function(self)
        local guiFrame = self:GetParent():GetParent() -- Get back to the main GUI frame

        -- Hide the currently active content frame and its parent ScrollFrame, if any
        if guiFrame.activeContentFrame then
            -- Check if GetParent exists before calling Hide on the parent
            if guiFrame.activeContentFrame.GetParent and guiFrame.activeContentFrame:GetParent() then 
                 guiFrame.activeContentFrame:GetParent():Hide()
            end
            guiFrame.activeContentFrame:Hide()
        end

        -- Show the ScrollFrame and the inner scroll content frame for the clicked subcategory
        self.contentFrame:Show() -- Show the parent ScrollFrame
        self.scrollContent:Show()

        -- Update the active content frame reference (pointing to the inner scrollContent)
        guiFrame.activeContentFrame = self.scrollContent

        -- Optional: Add visual feedback for the selected button
        -- You would need to add a 'selected' flag and update button colors/textures
    end)

    return button
end

-- Function to add a category with subcategories
function GUI:AddCategory(name, subcategories)
    local previousBottomY = 0 -- Tracks the bottom Y position of the last element added across all category groups

    -- Find the bottom Y position of the last element in the last category group, if any
    if #self.Categories > 0 then
        local lastCategory = self.Categories[#self.Categories]
        if #lastCategory.subcategories > 0 then
            local lastSubcategory = lastCategory.subcategories[#lastCategory.subcategories]
            previousBottomY = lastSubcategory.yPosition + lastSubcategory.height
        else
            previousBottomY = lastCategory.yPosition + lastCategory.height
        end
    end

    -- Calculate the starting Y position for the new category
    local categoryYPosition = (#self.Categories == 0) and 0 or (previousBottomY) -- Padding between category groups

    -- Create and position the category button
    local category = self:CreateCategory(self.CategoryList, name, categoryYPosition)
    category.subcategories = {}
    category.yPosition = categoryYPosition -- Store the calculated absolute Y position
    category.height = CategoryHeight -- Height of category button

    local subcategoryYPosition = categoryYPosition + category.height -- Starting Y position for the first subcategory, padding after category

    if subcategories then
        for i, subname in ipairs(subcategories) do
            -- Create and position each subcategory button
            local subcategoryButton = self:CreateSubCategory(self.CategoryList, subname, subcategoryYPosition) -- Renamed variable
            
            -- Store the created subcategory button
            category.subcategories[i] = subcategoryButton

            -- subcategoryButton.yPosition is already set in CreateSubCategory
            -- subcategoryButton.height is already set in CreateSubCategory
            subcategoryYPosition = subcategoryButton.yPosition + subcategoryButton.height -- Update position for the next subcategory
        end
    end

    -- Store the category object
    self.Categories[#self.Categories + 1] = category
    return category
end

-- Helper function to create a horizontal divider
function GUI:CreateDivider(parent, xOffset, yOffset, height)
    local dividerName = "BNUI_Divider_" .. xOffset .. "_" .. yOffset
    local divider = CreateFrame("Frame", dividerName, parent, "BackdropTemplate")
    divider:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, -yOffset)
    divider:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -xOffset, -yOffset)
    divider:SetHeight(height)
    divider:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = nil,
        tile = false,
        tileSize = 0,
        edgeSize = 0,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    divider:SetBackdropColor(0.6, 0.6, 0.6, 0.8)
    
    -- Store the divider as a property of the parent frame
    parent.Divider = divider
    
    return divider
end

-- Helper function to create a checkbox
function GUI:CreateCheckbox(parent, anchor, text, x, y, category, key, tooltip)
    local checkbox = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
    
    -- Set position based on anchor if provided, otherwise use parent
    if anchor then
        checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", x, y)
    else
        checkbox:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    end
    
    checkbox.Text:SetText(text)
    
    -- Set the initial state based on profile or default
    checkbox:SetChecked(M.Profiles:GetSetting(category, key))
    
    -- Add tooltip if provided
    if tooltip then
        checkbox:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(tooltip.title, 1, 1, 1)
            if tooltip.text then
                GameTooltip:AddLine(tooltip.text, 0.7, 0.7, 0.7, true)
            end
            GameTooltip:Show()
        end)
        checkbox:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
    end
    
    -- Handle checkbox changes
    checkbox:SetScript("OnClick", function(self)
        M.Profiles:SetSetting(category, key, self:GetChecked())
    end)
    
    return checkbox
end

function GUI.Enable(self)
    if self.Created then
        return
    end

    -- Main Window
    self:SetFrameStrata("DIALOG")
    self:SetWidth(GuiWidth)
    self:SetPoint("CENTER", UIParent, 0, 0)
    self:Hide()
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)

    -- Title Text
    self.TitleText = self.TitleContainer:CreateFontString(nil, "OVERLAY")
    self.TitleText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    self.TitleText:SetPoint("CENTER", self.TitleContainer, "CENTER", 0, 0)
    self.TitleText:SetText("BNUI - Config")
    self.TitleText:SetTextColor(1, 0.8, 0, 1)

    -- Close Button
    self.CloseButton = CreateFrame("Button", nil, self, "UIPanelCloseButtonDefaultAnchors")
    self.CloseButton:SetScript("OnClick", function() self:Hide() end)

    -- CategoryList / Left Column
    self.CategoryList = CreateFrame("Frame", nil, self, "BackdropTemplate")
    self.CategoryList:SetPoint("TOPLEFT", self, "TOPLEFT", Spacing, -Spacing*1.5)
    self.CategoryList:SetSize(GuiWidth*0.2, GuiHeight-(Spacing*2))
    self.CategoryList:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    self.CategoryList:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    self.CategoryList:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.8)

    -- SettingsArea / Right Column
    self.SettingsArea = CreateFrame("Frame", nil, self, "BackdropTemplate")
    self.SettingsArea:SetPoint("TOPLEFT", self.CategoryList, "TOPRIGHT", Spacing/2, 0)
    self.SettingsArea:SetSize((GuiWidth-((GuiWidth*0.2)+(Spacing*2.5))), GuiHeight-(Spacing*2))
    self.SettingsArea:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    self.SettingsArea:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    self.SettingsArea:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.8)

    -- calculate Height
    self:SetHeight(GuiHeight)
    self.Created = true

    -- Add Categories
    if M.isDeveloper then
        self:AddCategory("DEV", {"Dev"})
    end
    self:AddCategory("General", {"BNUI Settings"})
    self:AddCategory("Unitframes", {"Player", "Target", "Focus", "Pet"})

    -- Configure GUI elements from external file
    self:InitializeConfigElements()

    M:PrintDev("GUI Enabled")

end

GUI.Toggle = function(self)
	if InCombatLockdown() then
		return
	end

	if self:IsShown() then
		self:Hide()
	else
		self:Show()
	end
end

M.GUI = GUI