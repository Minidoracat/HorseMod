local HorseUtils = require("HorseMod/Utils")
local AnimationVariable = require("HorseMod/AnimationVariable")


local _originalPetAnimalStart = ISPetAnimal.start

function ISPetAnimal:start()
    print("pet start")
    if HorseUtils.isHorse(self.animal) then
        if not HorseUtils.isAdult(self.animal) then
            self.character:setVariable("pettingFilly", true)
        end
        if self.character:getVariableBoolean(AnimationVariable.RIDING_HORSE) then
            print("pet mounted start")
            self.character:setVariable("pettingMounted", true)
        end
    end
    _originalPetAnimalStart(self)
end


local _originalPetAnimalisValid = ISPetAnimal.isValid

function ISPetAnimal:isValid()
    print("isvalid pet")
    if HorseUtils.isHorse(self.animal) then
        if not HorseUtils.isAdult(self.animal) then
            self.character:setVariable("pettingFilly", true)
        end
        if self.character:getVariableBoolean(AnimationVariable.RIDING_HORSE) then
            print("pet mounted isvalid")
            self.character:setVariable("pettingMounted", true)
            return true
        end
    end
    _originalPetAnimalisValid(self)
end


local _originalPetAnimalwaitToStart = ISPetAnimal.waitToStart

function ISPetAnimal:waitToStart()
    print("waitToStart pet")
    if HorseUtils.isHorse(self.animal) then
        if not HorseUtils.isAdult(self.animal) then
            self.character:setVariable("pettingFilly", true)
        end
        if self.character:getVariableBoolean(AnimationVariable.RIDING_HORSE) then
            print("pet mounted waitToStart")
            self.character:setVariable("pettingMounted", true)
            return false
        end
    end
    _originalPetAnimalwaitToStart(self)
end


local _originalPetAnimalUpdate = ISPetAnimal.update

function ISPetAnimal:update()
    if HorseUtils.isHorse(self.animal) then
        if self.character:getVariableBoolean(AnimationVariable.RIDING_HORSE) then
            print("pet mounted update")
            self.character:setVariable("pettingMounted", true)
            return
        end
    end

	_originalPetAnimalUpdate(self)
end