---@namespace HorseMod

---Defines an attachment item with its associated slots and extra data if needed.
---@class AttachmentDefinition
---@field slot string

---Maps items' fulltype to their associated attachment definition.
---@alias AttachmentsItemsMap table<string, AttachmentDefinition>

---Stores the various attachment data which are required to work with attachments for horses.
---@class Attachments
---@field items AttachmentsItemsMap
local Attachments = {
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
    },
}

---Checks if the given item full type is an attachment, and optionally if it has a slot `_slot`.
---@param fullType string
---@param _slot string?
---@return boolean
Attachments.isAttachment = function(fullType, _slot)
    local attachmentDef = Attachments.items[fullType]
    if _slot then
        return attachmentDef and attachmentDef.slot == _slot or false
    end
    return attachmentDef ~= nil
end

---Retrieves the given item full type associated
---@param fullType string
---@return AttachmentDefinition
Attachments.getAttachment = function(fullType)
    return Attachments.items[fullType]
end

return Attachments
