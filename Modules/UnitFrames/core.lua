local M, C = BNUI[1], BNUI[2]

local Module = M.Module

local profile = M.Profiles

assert(M.oUF, "oUF is not loaded")

local oUF = M.oUF

local UnitFramesModule = {
    name = "UnitFrames",
    -- dependencies = {"Theme"},
    frames = {},
    initialized = false
}

function UnitFramesModule:CreateUnitFrames()
    -- Start with a simple player frame

    -- if profile:GetSetting("UnitFrames", "EnablePlayerFrame") then
    self:CreatePlayerFrame()
    -- end
end

function UnitFramesModule:Initialize()
    if self.initialized then return end

    self:CreateUnitFrames()

    self.initialized = true

    M:PrintDev("UnitFrames Module initialized")
end



-- Register the module
Module:Register("UnitFrames", UnitFramesModule)