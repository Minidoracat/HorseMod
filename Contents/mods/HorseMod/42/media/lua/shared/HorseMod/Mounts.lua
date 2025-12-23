local mountcommands = require("HorseMod/networking/mountcommands")
local commands = require("HorseMod/networking/commands")
local Event = require("HorseMod/Event")

local IS_CLIENT = isClient()
local IS_SERVER = isServer()


---@type table<IsoPlayer, IsoAnimal>
local playerMountMap = {}

---@type table<IsoAnimal, IsoPlayer>
local mountPlayerMap = {}

local Mounts = {}

---Triggered when a player's mount changes.
Mounts.onMountChanged = Event.new--[[@<IsoPlayer, IsoAnimal?>]]()

---@param player IsoPlayer
---@param animal IsoAnimal
function Mounts.addMount(player, animal)
    Mounts.playerMountMap[player] = animal
    Mounts.mountPlayerMap[animal] = player

    if IS_SERVER then
        mountcommands.Mount:send(
            nil,
            {
                animal = commands.getAnimalId(animal),
                character = commands.getPlayerId(player),
            }
        )
    end

    Mounts.onMountChanged:trigger(player, animal)
end

---@param player IsoPlayer
function Mounts.removeMount(player)
    assert(Mounts.hasMount(player), "")
    local mount = playerMountMap[player]
    playerMountMap[player] = nil
    mountPlayerMap[mount] = nil
    
    if IS_SERVER then
        mountcommands.Dismount:send(
            nil,
            {
                character = commands.getPlayerId(player)
            }
        )
    end

    Mounts.onMountChanged:trigger(player, nil)
end

---@param player IsoPlayer
---@return boolean
---@nodiscard
function Mounts.hasMount(player)
    return playerMountMap[player] ~= nil
end

---@param player IsoPlayer
---@return IsoAnimal?
---@nodiscard
function Mounts.getMount(player)
    return playerMountMap[player]
end

---@param animal IsoAnimal
---@return boolean
---@nodiscard
function Mounts.hasRider(animal)
    return mountPlayerMap[animal] ~= nil
end

---@param animal IsoAnimal
---@return IsoPlayer?
---@nodiscard
function Mounts.getRider(animal)
    return mountPlayerMap[animal]
end


if IS_CLIENT then
    -- need to delay this require :(
    Events.OnInitGlobalModData.Add(function()
        local client = require("HorseMod/networking/client")

        client.registerCommandHandler(mountcommands.Mount, function(args)
            local player = commands.getPlayer(args.character)
            if player then
                local animal = commands.getAnimal(args.animal)
                assert(animal ~= nil, "could not find mounted animal sent by server")
                Mounts.addMount(player, animal)
            else
                print("[HorseMod] received Mount command for unknown player")
            end
        end)

        client.registerCommandHandler(mountcommands.Dismount, function(args)
            local player = commands.getPlayer(args.character)
            if player then
                Mounts.removeMount(player)
            else
                print("[HorseMod] received Dismount command for unknown player")
            end
        end)
    end)
end


return Mounts