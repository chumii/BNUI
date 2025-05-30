local M, C = BNUI[1], BNUI[2]
local Textures = C["Media"]["Textures"]

local Module = M.Module

local CreateFrame = CreateFrame

local UnitFramesModule = Module:Get("UnitFrames")

local oUF = M.oUF

function UnitFramesModule:CreatePlayeFrameStyle()
    if not self then
        return
    end
    
    self.myStyle = "player"

    local playerContainer = CreateFrame("Frame", nil, self)
    playerContainer:SetFrameStrata(self:GetFrameStrata())
    playerContainer:SetFrameLevel(5)
    playerContainer:SetAllPoints()
    playerContainer:SetSize(250, 50)


    local playerContainerBackground = CreateFrame("Frame", nil, playerContainer, "BackdropTemplate")
    playerContainerBackground:SetFrameStrata(self:GetFrameStrata())
    playerContainerBackground:SetFrameLevel(3)
    playerContainerBackground:SetAllPoints()
    playerContainerBackground:SetBackdrop({
        bgFile = M.GetTexture("WGlass"),
        --insets = { left = 4, right = 4, top = 4, bottom = 4 }
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })

    playerContainerBackground:SetBackdropColor(0.1, 0.1, 0.1, 0.8)

    local playerContainerBorder = CreateFrame("Frame", nil, playerContainer, "BackdropTemplate")
    playerContainerBorder:SetFrameStrata(self:GetFrameStrata())
    playerContainerBorder:SetFrameLevel(5)
    playerContainerBorder:SetAllPoints()
    playerContainerBorder:SetBackdrop({
        --edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeFile = Textures.BNUI_Border,
        edgeSize = 16,
    })

    playerContainerBorder:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)


    local Health = CreateFrame("StatusBar", nil, playerContainer)
    
    Health:SetPoint("TOPLEFT", playerContainer, "TOPLEFT", 2, -2)
    Health:SetPoint("TOPRIGHT", playerContainer, "TOPRIGHT", -2, -2)
    Health:SetHeight(50*0.9)
    Health:SetStatusBarTexture(M.GetTexture("WGlass"))
    Health:SetFrameLevel(4)

    Health.frequentUpdates = true
    Health.colorClass = true
    Health.colorSmooth = true

    self.Overlay = playerContainer
    self.Health = Health
end


function UnitFramesModule:CreatePlayerFrame()
    M:Print("Creating Player Frame")

    oUF:RegisterStyle("BNUI_Player", self.CreatePlayeFrameStyle)
    oUF:SetActiveStyle("BNUI_Player")

    local player = oUF:Spawn("player", "BNUI_Player")
    player:SetPoint("BOTTOM", UIParent, "BOTTOM", -260, 320)
    player:SetSize(250, 50)

    self.frames["player"] = player
end