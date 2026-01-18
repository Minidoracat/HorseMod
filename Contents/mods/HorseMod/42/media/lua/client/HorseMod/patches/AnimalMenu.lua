local HorseRiding = require("HorseMod/Riding")
local HorseUtils = require("HorseMod/Utils")
local AnimalMenu = {}

AnimalMenu._originalOnPetAnimal = AnimalContextMenu.onPetAnimal
AnimalContextMenu.onPetAnimal = function(animal, chr)
    if HorseUtils.isHorse(animal) then
        print("petting horse mounted ")
        local mountedHorse = HorseRiding.getMount(chr)
        if mountedHorse then
            print("adding to mounted queue")
            ISTimedActionQueue.add(ISPetAnimal:new(chr, animal))
            return
        end
    end

    AnimalMenu._originalOnPetAnimal(animal, chr)
end

AnimalMenu._originalOnFeedAnimalFood = AnimalContextMenu.onFeedAnimalFood
AnimalContextMenu.onFeedAnimalFood = function(player, animal, food)
    if HorseUtils.isHorse(animal) then
        ISTimedActionQueue.add(ISFeedAnimalFromHand:new(player, animal, food))
        return
    end
    AnimalMenu._originalOnFeedAnimalFood(player, animal, food)
end

return AnimalMenu