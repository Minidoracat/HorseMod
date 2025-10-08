ISHorseGearAction = ISBaseTimedAction:derive("ISHorseGearAction")

function ISHorseGearAction:isValid()
    return self.horse and self.horse:isExistInTheWorld()
end

function ISHorseGearAction:start()
    self:setActionAnim("Loot")
    self.character:faceThisObject(self.horse)
end

function ISHorseGearAction:update()
    self.character:faceThisObject(self.horse)
end

function ISHorseGearAction:stop()
    if self.unlockFn then self.unlockFn() end
    ISBaseTimedAction.stop(self)
end

function ISHorseGearAction:perform()
    if self.workFn then pcall(self.workFn) end
    if self.unlockFn then self.unlockFn() end
    ISBaseTimedAction.perform(self)
end

function ISHorseGearAction:new(character, horse, workFn, maxTime, unlockFn)
    local o = ISBaseTimedAction.new(self, character)
    o.horse   = horse
    o.workFn  = workFn
    o.maxTime = maxTime or 120
    o.unlockFn = unlockFn
    o.stopOnWalk = true
    o.stopOnRun  = true
    o.stopOnAim  = true
    return o
end