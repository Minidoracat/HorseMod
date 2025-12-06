local AttachmentData = require("HorseMod/attachments/AttachmentData")
local AttachmentsCheck = {}
local scriptManager = getScriptManager()

for fullType, attachmentDef in pairs(AttachmentData) do
    local item = scriptManager:getItem(fullType)

    -- verify container behavior is compatible for this specific item
    if attachmentDef.containerBehavior then
        local type = item:getType()
        if type ~= Item.Type.Container then
            error("Horse accessory ("..fullType..") cannot have a container behavior because it isn't of type 'Container'.")
        end
    end
end

return AttachmentsCheck