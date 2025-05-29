local M, C = BNUI[1], BNUI[2]

local Profiles = {
    initialized = false
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
    
    -- Initialize realm table if it doesn't exist
    if not BNUIDB[M.Realm] then
        BNUIDB[M.Realm] = {}
    end
    
    -- Initialize character table if it doesn't exist
    if not BNUIDB[M.Realm][M.Name] then
        BNUIDB[M.Realm][M.Name] = {
            profile = self:CreateProfileName(M.Name), -- Default profile includes realm
            settings = {} -- Character-specific settings
        }
    end
    
    -- Store the current profile reference
    M.CurrentProfile = BNUIDB[M.Realm][M.Name]
    
    self.initialized = true
end

-- Function to change profile
function Profiles:ChangeProfile(profileName)
    -- Add realm to profile name if it's not already included
    local fullProfileName = profileName:find("-" .. M.Realm) and profileName or self:CreateProfileName(profileName)
    
    -- Update character's profile reference
    M.CurrentProfile.profile = fullProfileName
end

-- Function to get all available profiles for current realm
function Profiles:GetAvailableProfiles()
    local profiles = {}
    for name, data in pairs(BNUIDB[M.Realm]) do
        if type(data) == "table" then
            table.insert(profiles, name)
        end
    end
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
    -- Initialize the category table if it doesn't exist
    if not M.CurrentProfile.settings[category] then
        M.CurrentProfile.settings[category] = {}
    end
    
    -- Set the value
    M.CurrentProfile.settings[category][key] = value
end

-- Expose the Profiles module
M.Profiles = Profiles