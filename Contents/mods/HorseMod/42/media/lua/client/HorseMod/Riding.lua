---REQUIREMENTS
local Mount = require("HorseMod/mount/Mount")
local HorseUtils = require("HorseMod/Utils")
local ModOptions = require("HorseMod/ModOptions")
local AnimationVariables = require("HorseMod/AnimationVariables")
local Mounts = require("HorseMod/Mounts")

local client = require("HorseMod/networking/client")
local mountcommands = require("HorseMod/networking/mountcommands")
local commands = require("HorseMod/networking/commands")
local MountPair = require("HorseMod/MountPair")

---@namespace HorseMod

---Holds horse riding utility and keybind handling.
local HorseRiding = {
    ---Holds the mount of a given player ID.
    ---@type {[integer]: Mount | nil}
    playerMounts = {},
}

---@deprecated
---@param animal IsoAnimal
---@return boolean
---@nodiscard
function HorseRiding.isMountableHorse(animal)
    return HorseUtils.isAdult(animal)
end

---@deprecated Use Mounts.getMount instead.
---Retrieve the mount of the player.
---@param player IsoPlayer
---@return IsoAnimal | nil
---@nodiscard
function HorseRiding.getMountedHorse(player)
    return Mounts.getMount(player)
end

---@deprecated Use Mounts.hasMount instead.
---Check if the player is currently mounting a horse.
---@param player IsoPlayer
---@return boolean
---@nodiscard
function HorseRiding.isMountingHorse(player)
    return Mounts.hasMount(player)
end

---Retrieve the player mount
---@param rider IsoPlayer
---@return Mount | nil
---@nodiscard
function HorseRiding.getMount(rider)
    return HorseRiding.playerMounts[rider:getPlayerNum()]
end

---Create a new mount from a pair.
---@param pair MountPair
---@return Mount
function HorseRiding.createMountFromPair(pair)
    assert(
        HorseRiding.getMount(pair.rider) == nil,
        "tried to create mount for a player that is already mounted"
    )

    local mount = Mount.new(pair)
    HorseRiding.playerMounts[pair.rider:getPlayerNum()] = mount

    local modData = pair.rider:getModData()
    modData.ShouldRemount = true
    pair.rider:transmitModData()

    return mount
end

---Remove the mount from a player.
---@param player IsoPlayer
function HorseRiding.removeMount(player)
    local mount = HorseRiding.getMount(player)
    assert(
        mount ~= nil,
        "tried to remove mount from a player that is not mounted"
    )

    mount:cleanup()

    UpdateHorseAudio(mount.pair.rider)

    HorseRiding.playerMounts[mount.pair.rider:getPlayerNum()] = nil

    local modData = mount.pair.rider:getModData()
    modData.ShouldRemount = false
    mount.pair.rider:transmitModData()
end

---@param player IsoPlayer
---@param animal IsoAnimal?
Mounts.onMountChanged:add(function(player, animal)
    if not player:isLocalPlayer() then
        return
    end

    if HorseRiding.getMount(player) then
        HorseRiding.removeMount(player)
    end

    if animal then
        HorseRiding.createMountFromPair(
            MountPair.new(
                player,
                animal
            )
        )
    end
end)

---Update the horse riding for every mounts.
local function updateMounts()
    for i = 0, getNumActivePlayers() do
        local player = getSpecificPlayer(i)
        if player then
            local mount = HorseRiding.getMount(player)
            if mount then
                mount:update()
            end
        end
    end
end

Events.OnTick.Add(updateMounts)

---Handle keybind pressing to switch horse riding states.
---@param key integer
HorseRiding.onKeyPressed = function(key)
    local player = getPlayer()
    if not player then
        return
    end

    local mount = HorseRiding.getMount(player)
    if mount then
        mount:keyPressed(key)
    end
end

Events.OnKeyPressed.Add(HorseRiding.onKeyPressed)


-- TODO: this function needs to be split between client and server
HorseRiding.dismountOnHorseDeath = function(character)
    if not character:isAnimal() then
        return
    end

    for _, mount in pairs(HorseRiding.playerMounts) do
        if mount and mount.pair.mount == character then
            local rider = mount.pair.rider
            Mounts.removeMount(rider)
            HorseUtils.runAfter(4.1, function()
                    rider:setBlockMovement(false)
                    rider:setIgnoreMovement(false)
                    rider:setIgnoreInputsForDirection(false)
                    rider:setVariable(AnimationVariables.DYING, false)
                end)
            return
        end
    end
end

Events.OnCharacterDeath.Add(HorseRiding.dismountOnHorseDeath)


---@param player IsoPlayer
local function initHorseMod(_, player)
    player:setVariable(AnimationVariables.RIDING_HORSE, false)
    player:setVariable(AnimationVariables.MOUNTING_HORSE, false)
    player:setVariable(AnimationVariables.DISMOUNT_FINISHED, false)
    player:setVariable(AnimationVariables.MOUNT_FINISHED, false)
end

Events.OnCreatePlayer.Add(initHorseMod)


return HorseRiding