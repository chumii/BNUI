local M, C = BNUI[1], BNUI[2]
local Fonts = C["Media"]["Fonts"]

local UIParent = UIParent
local CreateFrame = CreateFrame

-- Font Configuration
local DefaultFont = Fonts.Expressway
local DefaultFontSize = 14
local DefaltFontSizeSmall = 12
local DefaultFontStyle = ""

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
    button.Text = button:CreateFontString(nil, "OVERLAY")
    button.Text:SetFont(DefaultFont, DefaultFontSize, DefaultFontStyle)
    button.Text:SetTextColor(unpack(M.TextColorYellow))
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
    button.Text = button:CreateFontString(nil, "OVERLAY")
    button.Text:SetFont(DefaultFont, DefaltFontSizeSmall, DefaultFontStyle)
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
    local mainFrame = self -- Store reference to the main GUI frame
    local contentFrame = CreateFrame("ScrollFrame", nil, mainFrame.SettingsArea, "ScrollFrameTemplate") -- Use the template
    contentFrame:SetPoint("TOPLEFT", mainFrame.SettingsArea, "TOPLEFT", 0, -20)
    contentFrame:SetPoint("BOTTOMRIGHT", mainFrame.SettingsArea, "BOTTOMRIGHT", 0, 20) -- Add 10 pixel padding at bottom
    contentFrame:Hide() -- Initially hide the scroll frame

    -- Create the inner frame that will hold the actual scrollable content
    local scrollContent = CreateFrame("Frame", nil, contentFrame) -- Parented to the ScrollFrame
    scrollContent:SetPoint("TOPLEFT", 0, 0)
    scrollContent:SetSize(mainFrame.SettingsArea:GetWidth(), 10) -- Minimum height, will be updated by config funcs

    -- Set the inner frame as the scroll child of the ScrollFrame
    contentFrame:SetScrollChild(scrollContent)

    -- Add the subcategory title to the INNER content frame for testing
    local titleText = scrollContent:CreateFontString(nil, "OVERLAY")
    titleText:SetFont(DefaultFont, DefaultFontSize, DefaultFontStyle)
    titleText:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 20, 0)
    titleText:SetText(text)
    titleText:SetTextColor(1, 1, 1, 1)

    -- Add Divider under Title
    self:CreateDivider(scrollContent, 15, 30, 1)   

    -- Store references on the button
    button.scrollContent = scrollContent -- Inner frame for content
    button.contentFrame = contentFrame -- The ScrollFrame itself
    
    -- Store position and height for AddCategory calculation
    button.yPosition = yPosition
    button.height = SubcategoryHeight

    -- OnClick script
    button:SetScript("OnClick", function(self)
        local mainFrame = self:GetParent():GetParent():GetParent() -- Get back to the main GUI frame

        -- Hide the currently active content frame and its parent ScrollFrame, if any
        if mainFrame.activeContentFrame then
            -- Check if GetParent exists before calling Hide on the parent
            if mainFrame.activeContentFrame.GetParent and mainFrame.activeContentFrame:GetParent() then 
                 mainFrame.activeContentFrame:GetParent():Hide()
            end
            mainFrame.activeContentFrame:Hide()
        end

        -- Show the ScrollFrame and the inner scroll content frame for the clicked subcategory
        self.contentFrame:Show() -- Show the parent ScrollFrame
        self.scrollContent:Show()

        -- Update the active content frame reference (pointing to the inner scrollContent)
        mainFrame.activeContentFrame = self.scrollContent

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
    local category = self:CreateCategory(self.CategoryListContent, name, categoryYPosition)
    category.subcategories = {}
    category.yPosition = categoryYPosition -- Store the calculated absolute Y position
    category.height = CategoryHeight -- Height of category button

    local subcategoryYPosition = categoryYPosition + category.height -- Starting Y position for the first subcategory, padding after category

    if subcategories then
        for i, subname in ipairs(subcategories) do
            -- Create and position each subcategory button
            local subcategoryButton = self:CreateSubCategory(self.CategoryListContent, subname, subcategoryYPosition)
            
            -- Store the created subcategory button
            category.subcategories[i] = subcategoryButton

            -- subcategoryButton.yPosition is already set in CreateSubCategory
            -- subcategoryButton.height is already set in CreateSubCategory
            subcategoryYPosition = subcategoryButton.yPosition + subcategoryButton.height -- Update position for the next subcategory
        end
    end

    -- Store the category object
    self.Categories[#self.Categories + 1] = category

    -- Update the content frame height based on the last element's position
    local totalHeight = subcategoryYPosition + 10 -- Add some padding at the bottom
    self.CategoryListContent:SetHeight(totalHeight)

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
    
    checkbox.Text:SetFont(DefaultFont, DefaultFontSize, DefaultFontStyle)
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

-- Helper function to create FontString
function GUI:CreateFontString(parent, text, font, size)
    local fs = parent:CreateFontString(nil,"OVERLAY")
    fs:SetFont(font or DefaultFont, size or DefaultFontSize, DefaultFontStyle)
    fs:SetText(text)
    return fs
end

-- Helper function to create a labeled dropdown menu
function GUI:CreateLabeledDropdown(parent, anchor, labelText, x, y, width, options, default, onChange)
    local label = self:CreateFontString(parent, labelText, DefaultFont, DefaultFontSize)
    
    -- Set position based on anchor if provided, otherwise use parent
    if anchor then
        label:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", x, y)
    else
        label:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    end
    
    local dropdown = CreateFrame("Frame", nil, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint("LEFT", label, "LEFT", width, 0)
    dropdown:SetWidth(width)
    
    -- Create the dropdown menu
    local function DropDown_OnClick(self, arg1, arg2, checked)
        UIDropDownMenu_SetText(dropdown, self.value)
        if onChange then
            onChange(self.value)
        end
    end
    
    local function DropDown_Initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for _, option in ipairs(options) do
            info.text = option.text
            info.value = option.value
            info.func = DropDown_OnClick
            info.arg1 = option.value
            info.checked = (option.value == default)
            UIDropDownMenu_AddButton(info, level)
        end
    end
    
    UIDropDownMenu_Initialize(dropdown, DropDown_Initialize)
    UIDropDownMenu_SetText(dropdown, default)
    UIDropDownMenu_SetWidth(dropdown, width)
    
    return label, dropdown
end

-- Helper function to create a labeled editbox
function GUI:CreateLabeledEditBox(parent, anchor, labelText, x, y, width, height, defaultText, onEnter)
    local label = self:CreateFontString(parent, labelText, DefaultFont, DefaultFontSize)
    
    -- Set position based on anchor if provided, otherwise use parent
    if anchor then
        label:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", x, y)
    else
        label:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    end
    
    local editbox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    editbox:SetPoint("LEFT", label, "LEFT", width+23, 0)
    editbox:SetSize(width, height)
    editbox:SetAutoFocus(false)
    editbox:SetText(defaultText or "")
    
    if onEnter then
        editbox:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()
            onEnter(self:GetText())
        end)
    end
    
    return label, editbox
end

-- Helper function to create a labeled checkbox
function GUI:CreateLabeledCheckbox(parent, anchor, labelText, x, y, category, key, tooltip)
    local checkbox = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
    
    -- Set position based on anchor if provided, otherwise use parent
    if anchor then
        checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -5)
    else
        checkbox:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    end
    
    checkbox.Text:SetFont(DefaultFont, DefaultFontSize, DefaultFontStyle)
    checkbox.Text:SetText(labelText)
    
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

-- Helper function to create a button
function GUI:CreateButton(parent, anchor, text, x, y, width, height, onClick)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    
    -- Set position based on anchor if provided, otherwise use parent
    if anchor then
        button:SetPoint("TOPLEFT", anchor, "TOPRIGHT", x, y)
    else
        button:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    end
    
    button:SetSize(width, height)
    button:SetText(text)
    
    if onClick then
        button:SetScript("OnClick", onClick)
    end
    
    return button
end

-- Helper function to create an editbox
function GUI:CreateEditBox(parent, anchor, x, y, width, height, defaultText, onEnter)
    local editbox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    
    -- Set position based on anchor if provided, otherwise use parent
    if anchor then
        editbox:SetPoint("TOPLEFT", anchor, "TOPLEFT", x, y)
    else
        editbox:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    end
    
    editbox:SetSize(width, height)
    editbox:SetAutoFocus(false)
    editbox:SetText(defaultText or "")
    
    if onEnter then
        editbox:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()
            onEnter(self:GetText())
        end)
    end
    
    return editbox
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
    self.TitleText:SetFont(DefaultFont, DefaultFontSize, DefaultFontStyle)
    self.TitleText:SetPoint("CENTER", self.TitleContainer, "CENTER", 0, 0)
    self.TitleText:SetText("BNUI - Config")
    self.TitleText:SetTextColor(1, 0.8, 0, 1)

    -- Close Button
    self.CloseButton = CreateFrame("Button", nil, self, "UIPanelCloseButtonDefaultAnchors")
    self.CloseButton:SetScript("OnClick", function() self:Hide() end)

    -- CategoryList / Left Column (Now a ScrollFrame)
    self.CategoryList = CreateFrame("ScrollFrame", nil, self, "ScrollFrameTemplate")
    self.CategoryList:SetPoint("TOPLEFT", self, "TOPLEFT", Spacing, -Spacing*1.5)
    self.CategoryList:SetSize(GuiWidth*0.2, GuiHeight-(Spacing*2))
    
    -- Hide the scrollbar
    self.CategoryList.ScrollBar:Hide()
    self.CategoryList.ScrollBar.Show = function() end -- Prevent the scrollbar from showing
    
    -- Create the content frame for the ScrollFrame
    self.CategoryListContent = CreateFrame("Frame", nil, self.CategoryList, "BackdropTemplate")
    self.CategoryListContent:SetSize(GuiWidth*0.2, 10) -- Initial height, will be updated as categories are added
    self.CategoryList:SetScrollChild(self.CategoryListContent)
    
    -- Set up the backdrop for the content frame
    self.CategoryListContent:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    self.CategoryListContent:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    self.CategoryListContent:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.8)

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
    self:AddCategory("General", {"Profiles", "Settings"})
    self:AddCategory("Unitframes", {"Player", "Target", "Focus", "Pet"})
    self:AddCategory("Test", {"Test 1", "Test 2", "Test 3", "Test 4"})
    self:AddCategory("Test 5", {"Test 6", "Test 7", "Test 8", "Test 9"})
    self:AddCategory("Test 10", {"Test 11", "Test 12", "Test 13", "Test 14", "Test xx", "Test yy"})
    self:AddCategory("Test 15", {"Test 16", "Test 17", "Test 18", "Test 19"})
    self:AddCategory("Test 20", {"Test 21", "Test 22", "Test 23", "Test 24"})

    -- Configure GUI elements from external file
    self:InitializeConfigElements()

    -- Set default subcategory to show
    if self.Categories[2] and self.Categories[2].subcategories[1] then
        local defaultButton = self.Categories[2].subcategories[1]
        defaultButton.contentFrame:Show()
        defaultButton.scrollContent:Show()
        self.activeContentFrame = defaultButton.scrollContent
    end

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