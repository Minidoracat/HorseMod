local HorseUtils = require("HorseMod/Utils")
local AnimationVariables = require("HorseMod/AnimationVariables")

local _originalPetAnimalStart = ISPetAnimal.start

function ISPetAnimal:start()
    if HorseUtils.isHorse(self.animal) then
        if not HorseUtils.isAdult(self.animal) then
            self:setActionAnim("Bob_Horse_Pet_Filly")
        elseif self.character:getVariableBoolean(AnimationVariables.RIDING_HORSE) then
            self:setActionAnim("Bob_Horse_Pet_Mounted")
        end
    end
    _originalPetAnimalStart(self)
end
