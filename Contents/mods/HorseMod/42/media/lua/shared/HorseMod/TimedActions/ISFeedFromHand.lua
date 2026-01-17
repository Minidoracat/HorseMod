local HorseUtils = require("HorseMod/Utils")
local AnimationVariables = require("HorseMod/AnimationVariables")

local _originalFeedFromHandStart = ISFeedAnimalFromHand.start

function ISFeedAnimalFromHand:start()
    if HorseUtils.isHorse(self.animal) then
        if self.character:getVariableBoolean(AnimationVariables.RIDING_HORSE) then
            self:setActionAnim("Bob_Horse_EatHandMounted")
        else
            self:setActionAnim("Bob_Horse_EatHand")
        end
        self.animal:setVariable(AnimationVariables.EATING_HAND, true)
        self.animal:setVariable("eatingAnim", "eat1")
    end
    _originalFeedFromHandStart(self)
end

local _originalFeedFromHandUpdate = ISFeedAnimalFromHand.update

function ISFeedAnimalFromHand:update()
    if HorseUtils.isHorse(self.animal) then
        self.character:faceThisObject(self.animal)
        self.animal:faceThisObject(self.character)
    end
    _originalFeedFromHandUpdate(self)
end

local _originalFeedFromHandStop = ISFeedAnimalFromHand.stop

function ISFeedAnimalFromHand:stop()
    if HorseUtils.isHorse(self.animal) then
        self.animal:setVariable(AnimationVariables.EATING_HAND, false)
        self.animal:clearVariable("eatingAnim")
    end
    _originalFeedFromHandStop(self)
end

local _originalFeedFromHandPerform = ISFeedAnimalFromHand.perform

function ISFeedAnimalFromHand:perform()
    if HorseUtils.isHorse(self.animal) then
        self.animal:setVariable(AnimationVariables.EATING_HAND, false)
        self.animal:clearVariable("eatingAnim")
    end
    _originalFeedFromHandPerform(self)
end

local _originalFeedFromHandForceStop = ISFeedAnimalFromHand.forceStop

function ISFeedAnimalFromHand:forceStop()
    if HorseUtils.isHorse(self.animal) then
        self.animal:setVariable(AnimationVariables.EATING_HAND, false)
        self.animal:clearVariable("eatingAnim")
    end
    _originalFeedFromHandForceStop(self)
end

local _originalFeedFromHandGetDuration = ISFeedAnimalFromHand.getDuration

function ISFeedAnimalFromHand:getDuration()
	if HorseUtils.isHorse(self.animal) then
        return 240
    end
    return _originalFeedFromHandGetDuration(self)
end

local _originalFeedFromHandWaitToStart = ISFeedAnimalFromHand.waitToStart

function ISFeedAnimalFromHand:waitToStart()
    if HorseUtils.isHorse(self.animal) then
        self.character:faceThisObject(self.animal)
        self.animal:faceThisObject(self.character)
        return self.character:shouldBeTurning()
    end
    if _originalFeedFromHandWaitToStart then
        return _originalFeedFromHandWaitToStart(self)
    end
    return false
end
