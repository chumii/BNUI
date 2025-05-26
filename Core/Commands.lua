local M, C, L = BNUI[1], BNUI[2], BNUI[3]

-- Open Command Window with /kkhelp
local function OpenConfigGUI()
	M.GUI:Toggle()
end

-- Command Mapping Table
local commandMap = {	
	cfg = OpenConfigGUI,
	-- Add more commands as needed...
}

-- Slash Command Handler
SlashCmdList["BNUI"] = function(input)
	local command, args = strsplit(" ", input, 2)
	command = string.lower(command)

	if commandMap[command] then
		commandMap[command](args)
	else
		M:Print("Unknown command: " .. command)
	end
end
_G.SLASH_BNUI1 = "/bn"