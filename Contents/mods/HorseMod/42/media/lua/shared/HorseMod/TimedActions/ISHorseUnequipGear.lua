---@namespace HorseMod

---REQUIREMENTS
local Attachments = require("HorseMod/attachments/Attachments")
local ISHorseEquipGear = require("HorseMod/TimedActions/ISHorseEquipGear")
local ContainerManager = require("HorseMod/attachments/ContainerManager")

---@class ISHorseUnequipGear : ISHorseEquipGear
local ISHorseUnequipGear = ISHorseEquipGear:derive("HorseMod_ISHorseUnequipGear")

function ISHorseUnequipGear:complete()
    -- remove old accessory from slot and give to player or drop
    Attachments.setAttachedItem(self.horse, self.slot, nil)

    Attachments.giveBackToPlayerOrDrop(self.character, self.horse, self.accessory)
    
    -- remove container
    local containerBehavior = self.attachmentDef.containerBehavior
    if containerBehavior then
        ContainerManager.removeContainer(self.character, self.horse, self.slot, self.accessory)
    end

    return true
end


function ISHorseUnequipGear:getDuration()
    if self.character:isTimedActionInstant() then
        return 1
    end

    local unequipBehaviour = self.attachmentDef.unequipBehavior
    if not unequipBehaviour or not unequipBehaviour.time then
        return 120
    end

    return unequipBehaviour.time
end


function ISHorseUnequipGear:new(character, horse, accessory, slot, side, unlockPerform, unlockStop)
    local o = ISHorseEquipGear.new(self, character, horse, accessory, slot, side, unlockPerform, unlockStop) --[[@as ISHorseUnequipGear]]

    o.maxTime = o:getDuration()
    o.equipBehavior = o.attachmentDef.unequipBehavior or {}

    return o
end


_G[ISHorseUnequipGear.Type] = ISHorseUnequipGear


return ISHorseUnequipGear