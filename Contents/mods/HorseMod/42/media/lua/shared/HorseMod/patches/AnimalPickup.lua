---@namespace HorseMod

---REQUIREMENTS
local HorseUtils = require("HorseMod/Utils")
local HorseManager = require("HorseMod/HorseManager")

local AnimalPickup = {}

AnimalPickup._originalComplete = ISPickupAnimal.complete
function ISPickupAnimal:complete()
    local animal = self.animal
    if animal and HorseUtils.isHorse(animal) then
        HorseManager.makeOrphan(animal)
        HorseManager.removeFromHorses(animal)
    end

    return AnimalPickup._originalComplete(self)
end

return AnimalPickup