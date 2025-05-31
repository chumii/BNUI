local M, C = BNUI[1], BNUI[2]

local Profiles = {
    initialized = false,
    DefaultProfileName = "Default"
}

-- Helper function to create a full profile name
function Profiles:CreateProfileName(name)
    return name .. "-" .. M.Realm
end

-- Helper function to get the base name from a full profile name
function Profiles:GetBaseProfileName(fullName)
    return fullName:match("(.+)-" .. M.Realm)
end

-- Initialize the profile system
function Profiles:Initialize()
    if self.initialized then return end
    
    -- Initialize the main DB if it doesn't exist
    if not BNUIDB then
        BNUIDB = {}
    end
    
    -- Initialize the profiles and characters tables if they don't exist
    if not BNUIDB.profiles then
        BNUIDB.profiles = {}
    end
    
    if not BNUIDB.characters then
        BNUIDB.characters = {}
    end
    
    -- Initialize realm table if it doesn't exist
    if not BNUIDB.characters[M.Realm] then
        BNUIDB.characters[M.Realm] = {}
    end
    
    -- Create default profile if it doesn't exist
    if not BNUIDB.profiles[self.DefaultProfileName] then
        BNUIDB.profiles[self.DefaultProfileName] = {
            name = self.DefaultProfileName,
            settings = {}
        }
    end
    
    -- Initialize character table if it doesn't exist
    if not BNUIDB.characters[M.Realm][M.Name] then
        local defaultProfile = self:CreateProfileName(M.Name)
        BNUIDB.characters[M.Realm][M.Name] = {
            profile = defaultProfile
        }
        
        -- Create the character's default profile if it doesn't exist
        if not BNUIDB.profiles[defaultProfile] then
            BNUIDB.profiles[defaultProfile] = {
                name = defaultProfile,
                settings = {}
            }
        end
    end
    
    -- Store the current profile reference
    M.CurrentProfile = BNUIDB.profiles[BNUIDB.characters[M.Realm][M.Name].profile]
    
    self.initialized = true
end

-- Function to change profile
function Profiles:ChangeProfile(profileName)
    if not BNUIDB.profiles[profileName] then
        self:ShowError("Profile not found: " .. profileName)
        return false
    end
    
    -- Update character's profile reference
    BNUIDB.characters[M.Realm][M.Name].profile = profileName
    M.CurrentProfile = BNUIDB.profiles[profileName]
    
    self:ShowReloadPrompt()
    return true
end

-- Function to create a new profile
function Profiles:CreateProfile(profileName)
    if BNUIDB.profiles[profileName] then
        self:ShowError("Profile already exists: " .. profileName)
        return false
    end
    
    -- Create new profile
    BNUIDB.profiles[profileName] = {
        name = profileName,
        settings = {}
    }
    
    -- Set as active profile
    return self:ChangeProfile(profileName)
end

-- Function to delete a profile
function Profiles:DeleteProfile(profileName)
    if not BNUIDB.profiles[profileName] then
        self:ShowError("Profile not found: " .. profileName)
        return false
    end
    
    -- Don't allow deletion of the default profile
    if profileName == self.DefaultProfileName then
        self:ShowError("Cannot delete the default profile")
        return false
    end
    
    -- If deleting active profile, switch to default profile first
    if profileName == M.CurrentProfile.name then
        self:ChangeProfile(self.DefaultProfileName)
    end
    
    -- Check if any characters are using this profile
    for realm, characters in pairs(BNUIDB.characters) do
        for char, data in pairs(characters) do
            if data.profile == profileName then
                -- Switch character to default profile
                data.profile = self.DefaultProfileName
            end
        end
    end
    
    -- Delete the profile
    BNUIDB.profiles[profileName] = nil
    
    return true
end

-- Function to copy settings from another profile
function Profiles:CopyProfile(sourceProfileName)
    if not BNUIDB.profiles[sourceProfileName] then
        self:ShowError("Source profile not found: " .. sourceProfileName)
        return false
    end
    
    -- Copy all settings from source profile
    M.CurrentProfile.settings = {}
    for category, settings in pairs(BNUIDB.profiles[sourceProfileName].settings) do
        M.CurrentProfile.settings[category] = {}
        for key, value in pairs(settings) do
            M.CurrentProfile.settings[category][key] = value
        end
    end
    
    self:ShowReloadPrompt()
    return true
end

-- Function to get all available profiles
function Profiles:GetAvailableProfiles()
    local profiles = {}
    for name, _ in pairs(BNUIDB.profiles) do
        table.insert(profiles, name)
    end
    table.sort(profiles) -- Sort profiles alphabetically
    return profiles
end

-- Function to get a setting value, using profile if available, otherwise using default
function Profiles:GetSetting(category, key)
    -- First check if we have a profile setting
    if M.CurrentProfile.settings[category] and M.CurrentProfile.settings[category][key] ~= nil then
        return M.CurrentProfile.settings[category][key]
    end
    
    -- If no profile setting, return the default from C
    return C[category][key]
end

-- Function to set a setting value in the profile
function Profiles:SetSetting(category, key, value)
    -- Only save if the value is different from default
    if value == C[category][key] then
        -- If the value matches default, remove it from saved settings
        if M.CurrentProfile.settings[category] then
            M.CurrentProfile.settings[category][key] = nil
            -- Clean up empty category
            if next(M.CurrentProfile.settings[category]) == nil then
                M.CurrentProfile.settings[category] = nil
            end
        end
        return
    end
    
    -- Initialize the category table if it doesn't exist
    if not M.CurrentProfile.settings[category] then
        M.CurrentProfile.settings[category] = {}
    end
    
    -- Set the value
    M.CurrentProfile.settings[category][key] = value
end

-- Helper function to show error popup
function Profiles:ShowError(message)
    StaticPopupDialogs["BNUI_ERROR"] = {
        text = message,
        button1 = OKAY,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }
    StaticPopup_Show("BNUI_ERROR")
end

-- Helper function to show reload prompt
function Profiles:ShowReloadPrompt()
    -- Hide any existing popups
    StaticPopup_Hide("BNUI_DELETE_PROFILE")
    StaticPopup_Hide("BNUI_ERROR")
    
    StaticPopupDialogs["BNUI_RELOAD"] = {
        text = "UI needs to be reloaded for changes to take effect.",
        button1 = RELOADUI,
        button2 = CANCEL,
        OnAccept = function()
            ReloadUI()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }
    StaticPopup_Show("BNUI_RELOAD")
end

-- Expose the Profiles module
M.Profiles = Profiles