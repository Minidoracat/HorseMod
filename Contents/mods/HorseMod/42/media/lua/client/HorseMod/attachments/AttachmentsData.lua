---@class AttachmentDefinition
---@field slot string

---@alias AttachmentsItemsMap table<string, AttachmentDefinition|string>

---@class AttachmentsData
---@field items AttachmentsItemsMap
local HorseAttachments = {
    items = {
        -- saddles
            -- vanilla animals
        ["HorseMod.HorseSaddle_Crude"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_Black"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_CowHolstein"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_CowSimmental"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_White"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_Landrace"] = { slot = "Saddle" },
            -- horses
        ["HorseMod.HorseSaddle_AP"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_APHO"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_AQHBR"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_AQHP"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_FBG"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_GDA"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_LPA"] = { slot = "Saddle" },
        ["HorseMod.HorseSaddle_T"] = { slot = "Saddle" },

        -- saddlebags
            -- vanilla animals
        ["HorseMod.HorseSaddlebags_Crude"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_Black"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_CowHolstein"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_CowSimmental"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_White"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_Landrace"] = { slot = "Saddlebags" },
            -- horses
        ["HorseMod.HorseSaddlebags_AP"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_APHO"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_AQHBR"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_AQHP"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_FBG"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_GDA"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_LPA"] = { slot = "Saddlebags" },
        ["HorseMod.HorseSaddlebags_T"] = { slot = "Saddlebags" },

        -- reins
        ["HorseMod.HorseReins_Crude"] = { slot = "Reins" },
        ["HorseMod.HorseReins_Black"] = { slot = "Reins" },
        ["HorseMod.HorseReins_Brown"] = { slot = "Reins" },
        ["HorseMod.HorseReins_White"] = { slot = "Reins" },

        -- manes
        ["HorseMod.HorseManeStart"] = { slot = "ManeStart" },
        ["HorseMod.HorseManeMid"]   = { slot = "ManeMid1" },
        ["HorseMod.HorseManeEnd"]   = { slot = "ManeEnd" },
    }
}

return HorseAttachments
