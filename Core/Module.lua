local M = BNUI[1]

local Module = {
    modules = {},
    loaded = {},
    dependencies = {},
    registrationQueue = {} -- New table to store modules in registration order
}

-- Register a new module
function Module:Register(name, moduleTable)
    if self.modules[name] then
        M:Print("Module " .. name .. " is already registered!")
        return
    end
    
    self.modules[name] = moduleTable
    self.dependencies[name] = moduleTable.dependencies or {}
    
    -- Add to registration queue
    table.insert(self.registrationQueue, name)
end

-- Load a module and its dependencies
function Module:Load(name)
    if self.loaded[name] then
        return self.modules[name]
    end
    
    local module = self.modules[name]
    if not module then
        M:Print("Module " .. name .. " not found!")
        return nil
    end
    
    -- Load dependencies first
    if module.dependencies then
        for _, dep in ipairs(module.dependencies) do
            self:Load(dep)
        end
    end
    
    -- Initialize the module if it has an Initialize function
    if module.Initialize and not module.initialized then
        module:Initialize()
        module.initialized = true
    end
    
    self.loaded[name] = true
    return module
end

-- Get a module (loads it if not already loaded)
function Module:Get(name)
    if not self.modules[name] then
        M:Print("Module " .. name .. " not found!")
        return nil
    end
    return self.modules[name]
end

-- Check if a module is loaded
function Module:IsLoaded(name)
    return self.loaded[name] == true
end

-- New function to load all registered modules in registration order
function Module:LoadAll()
    for _, name in ipairs(self.registrationQueue) do
        self:Load(name)
    end
end

M.Module = Module
