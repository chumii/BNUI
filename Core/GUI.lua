local M, C = BNUI[1], BNUI[2]

local CreateFrame = CreateFrame
local UIParent = UIParent

local GuiWidth = 1100
local GuiHeight = 700 -- for testing
local Spacing = 30
local HeaderHeight = 50

local GUI = CreateFrame("Frame", "BNUI_GUI", UIParent,"DefaultPanelTemplate")
GUI.Windows = {}
GUI.Buttons = {}
GUI.Widgets = {}

-- Helper function to create columns
function GUI.CreateColumn(parent, width, height, point, relativeFrame, relativePoint, xOffset, yOffset, options)
    local column = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    column:SetSize(width, height)
    column:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
    
    options = options or {}
    if options.showBackdrop ~= false then
        column:SetBackdrop({
            bgFile = options.bgFile or "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = options.showBorder ~= false and (options.edgeFile or "Interface\\Tooltips\\UI-Tooltip-Border") or nil,
            edgeSize = options.edgeSize or 8,
            insets = options.insets or { left = 2, right = 2, top = 2, bottom = 2 }
        })
        if options.showBorder ~= false then
            column:SetBackdropBorderColor(options.borderColorR or 0.6, options.borderColorG or 0.6, options.borderColorB or 0.6)
        end
        column:SetBackdropColor(options.bgColorR or 0.1, options.bgColorG or 0.1, options.bgColorB or 0.1, options.bgColorA or 0.9)
    end
    return column
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

    -- Close Button
    self.CloseButton = CreateFrame("Button", nil, self, "UIPanelCloseButtonDefaultAnchors")
    self.CloseButton:SetScript("OnClick", function() self:Hide() end)

    -- Columns
    self.LeftColumn = self:CreateColumn(GuiWidth*0.2, GuiHeight-(Spacing*2), "TOPLEFT", self, "TOPLEFT", Spacing, -Spacing*1.5)
    self.RightColumn = self:CreateColumn((GuiWidth-((GuiWidth*0.2)+(Spacing*2.5))), GuiHeight-(Spacing*2), "TOPLEFT", self.LeftColumn, "TOPRIGHT", Spacing/2, 0)

    -- calculate Height
    self:SetHeight(GuiHeight)
    self.Created = true
    M:Print("GUI Enabled")
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