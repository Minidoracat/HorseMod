local HorseUtils = require("HorseMod/Utils")

-- we wait a tick to process animals because their type isn't set when the event triggers

---@type IsoAnimal[]
local animalsToProcess = table.newarray()

local function processHorses()
    for i = #animalsToProcess, 1, -1  do
        local animal = animalsToProcess[i]
        if HorseUtils.isHorse(animal) then
            animal:setVariable("isHorse", true)
            local speed = animal:getUsedGene("speed"):getCurrentValue()
            local strength = animal:getUsedGene("strength"):getCurrentValue()
            local stamina = animal:getUsedGene("stamina"):getCurrentValue()
            local carry = animal:getUsedGene("carryWeight"):getCurrentValue()
            animal:setVariable("geneSpeed", speed)
            animal:setVariable("geneStrength", strength)
            animal:setVariable("geneStamina", stamina)
            animal:setVariable("geneCarryWeight", carry)
        end
        animalsToProcess[i] = nil
    end
    Events.OnTick.Remove(processHorses)
end

Events.OnCreateLivingCharacter.Add(function(character, desc)
    if character:isAnimal() then
        table.insert(animalsToProcess, character)
        ---@cast character IsoAnimal
    end
    Events.OnTick.Add(processHorses)
end)
