local M = BNUI[1]
local Module = M.Module

local ThemeModule = {
    name = "Theme",
    colors = {
        primary = {0.2, 0.2, 0.2, 0.8},
        secondary = {0.15, 0.15, 0.15, 0},
        highlight = {0.25, 0.25, 0.25, 0.8},
        border = {0.6, 0.6, 0.6, 0.8}
    },
    fonts = {
        normal = "Fonts\\FRIZQT__.TTF",
        size = {
            normal = 12,
            small = 10,
            large = 14
        }
    },
    initialized = false
}

function ThemeModule:Initialize()
    if self.initialized then return end
    
    -- Initialize theme
    self:SetupTheme()
    
    self.initialized = true
    M:Print("Theme module initialized")
end

function ThemeModule:GetColor(name)
    return unpack(self.colors[name] or self.colors.primary)
end

function ThemeModule:GetFont(size)
    return self.fonts.normal, self.fonts.size[size] or self.fonts.size.normal
end

function ThemeModule:SetupTheme()
    -- Implementation of theme setup
end

-- Register the module
Module:Register("Theme", ThemeModule)