CrossGambling = LibStub("AceAddon-3.0"):NewAddon("CrossGambling", "AceConsole-3.0", "AceEvent-3.0")

-- GLOBALS
local gameStates = {
    "IDLE",
    "START",
    "ROLL"
}

local gameModes = {
    "Game Mode",
    "501",
    "BigTwo"
}

local chatMethods = {
    "PARTY",
    "RAID",
    "GUILD"
}

-- Defaults for the DB
local defaults = {
    global = {
        minimap = {
            hide = false,
        },
		 gamble = {
            chatMethod = chatMethods[1],
        },
    }
}

local options = {
    name = "CrossGambling",
    handler = CrossGambling,
    type = 'group',
    args = {
        show = {
            name = "Show UI",
            desc = "Show Game",
            type = "execute",
            func = "showUi"
        },
        hide = {
            name = "Hide UI",
            desc = "Hide Game",
            type = "execute",
            func = "hideUi"
        }
       
    }
}

-- Initialization --
function CrossGambling:OnInitialize()
    -- Sets up the DB and slash command options when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("CrossGambling", defaults, true)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("CrossGambling", options, {"CrossGambling", "cg"})

    -- Sets up the minimap icon
    local minimapIcon = LibStub("LibDBIcon-1.0")
    local minimapLDB = LibStub("LibDataBroker-1.1"):NewDataObject("MinimapIcon", {
        type = "data source",
        text = "CrossGambling",
        icon = "Interface\\AddOns\\CrossGambling\\media\\icon",
        OnClick = function() self:toggleUi() end,
        OnTooltipShow = function(tooltip)
		    tooltip:AddLine("CrossGambling", 1, 1, 1)
            tooltip:AddLine(" ", 1, 1, 1)
            tooltip:AddLine("Toggle CrossGambling.", 1, 229 / 255, 153 / 255)
		    tooltip:Show()
		end,
    })

    minimapIcon:Register("MinimapIcon", minimapLDB, self.db.global.minimap)
	self:drawUi()
end

--ChatMethods
function CrossGambling:chatMethod(direction)
    local channelIndex

    for i = 1, #chatMethods do
        if (self.db.global.gamble.chatMethod == chatMethods[i]) then
            channelIndex = i
        end
    end

    if (channelIndex ~= nil) then
        if (direction == "next") then
            if (channelIndex == #chatMethods) then
                self.db.global.gamble.chatMethod = chatMethods[1]
            else
                self.db.global.gamble.chatMethod = chatMethods[channelIndex + 1]
            end
        end
    else
        self.db.global.gamble.chatMethod = chatMethods[1]
    end
end
