---@namespace HorseMod

---REQUIREMENTS
local HorseUtils = require("HorseMod/Utils")
local AttachmentData = require("HorseMod/AttachmentData")

local Attachments = {}

---Checks if the given item full type is an attachment, and optionally if it has a slot `_slot`.
---@param fullType string
---@param _slot string?
---@return boolean
---@nodiscard
Attachments.isAttachment = function(fullType, _slot)
    local attachmentDef = Attachments.items[fullType]
    if _slot then
        return attachmentDef and attachmentDef.slot == _slot or false
    end
    return attachmentDef ~= nil
end

---@param fullType string
---@return AttachmentSlot?
---@nodiscard
Attachments.getSlot = function(fullType)
    local def = Attachments.items[fullType]
    return def and def.slot
end

---Retrieves the attachments associated to the given item full type.
---@param fullType string
---@return AttachmentDefinition
---@nodiscard
Attachments.getAttachmentDefinition = function(fullType)
    return Attachments.items[fullType]
end

---Retrieve the attached item on the specified `slot` of `animal`.
---@param animal IsoAnimal
---@param slot AttachmentSlot
---@return InventoryItem?
---@nodiscard
Attachments.getAttachedItem = function(animal, slot)
    local ai = animal:getAttachedItems()
    return ai and ai:getItem(slot)
    -- return animal:getAttachedItem(slot)
end

---@param animal IsoAnimal
---@return InventoryItem[]
---@nodiscard
Attachments.getAttachedItems = function(animal)
    local attached = {}
    local slots = AttachmentData.SLOTS
    local mane_slots_set = AttachmentData.MANE_SLOTS_SET
    for i = 1, #slots do
        local slot = slots[i]
        if not mane_slots_set[slot] then
            local attachment = Attachments.getAttachedItem(animal, slot)
            if attachment then
                table.insert(attached, attachment)
            end
        end
    end
    return attached
end

---Attach an `item` or `nil` to a specific `slot` on the `animal`.
---@param animal IsoAnimal
---@param slot AttachmentSlot
---@param item InventoryItem?
Attachments.setAttachedItem = function(animal, slot, item)
    ---@diagnostic disable-next-line
    animal:setAttachedItem(slot, item)
    local modData = HorseUtils.getModData(animal)
    modData.bySlot[slot] = item and item:getFullType()
end

---@param animal IsoAnimal
---@param item InventoryItem
Attachments.removeAttachedItem = function(animal, item)
    local ai = animal:getAttachedItems() --[[@as AttachedItems?]]
    if ai then
        local slot = ai:getLocation(item) --[[@as AttachmentSlot]]
        ai:remove(item)
        local modData = HorseUtils.getModData(animal)
        modData.bySlot[slot] = nil
    end
end

---@param player IsoPlayer
---@return ArrayList
---@nodiscard
Attachments.getAvailableGear = function(player)
    local playerInventory = player:getInventory()
    local accessories = playerInventory:getAllTag("HorseAccessory", ArrayList.new())
    return accessories
end

return Attachments