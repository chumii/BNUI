local M, C = BNUI[1], BNUI[2]

local CreateFrame = CreateFrame
local UIParent = UIParent

local GUI = CreateFrame("Frame", "BNUI_GUI", UIParent)
GUI.Windows = {}
GUI.Buttons = {}
GUI.Widgets = {}

-- Create test frame
local TestFrame = CreateFrame("Frame", "BNUI_TestFrame", UIParent, "PortraitFrameTemplate")
TestFrame:SetPoint("CENTER")
TestFrame:SetSize(300, 400)
GUI.Windows.TestFrame = TestFrame

M.GUI = GUI