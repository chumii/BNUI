local M, C = BNUI[1], BNUI[2]

M.Devs = {
    ["Perdautz-Aegwynn"] = true,
    ["Racnar-Blackrock"] = true
}

local function isDeveloper()
    return M.Devs[M.Name .. "-" .. M.Realm]
end

M.isDeveloper = isDeveloper()

function M:Print(msg)
    print(M.Title .. ": " .. msg)
end

function M:PrintDev(msg)
    if M.isDeveloper then
        print(M.Title .. "DEV: " .. msg)
    end
end