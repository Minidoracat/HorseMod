---@namespace HorseMod

---REQUIREMENTS
local HorseUtils = require("HorseMod/Utils")
local AttachmentData = require("HorseMod/attachments/AttachmentData")
local HorseManager = require("HorseMod/HorseManager")

---@class ContainerInformation
---@field x number
---@field y number
---@field z number
---@field fullType string
---@field worldID number
---@field worldItem IsoWorldInventoryObject?

---@alias AnimalContainers table<AttachmentSlot, ContainerInformation?>

---Holds all the utility functions to manage containers on horses.
local ContainerManager = {
    ---Cache for the horse containers references.
    ---@type table<IsoAnimal, AnimalContainers>
    HORSE_CONTAINERS = {},

    ---Containers
    ---@type table<number, IsoAnimal>
    FIND_CONTAINERS = {},
}
local HORSE_CONTAINERS = ContainerManager.HORSE_CONTAINERS
local FIND_CONTAINERS = ContainerManager.FIND_CONTAINERS

local function refreshInventories(player)
    local pdata = getPlayerData(player:getPlayerNum())
    ---@diagnostic disable-next-line
    pdata.playerInventory:refreshBackpacks()
    ---@diagnostic disable-next-line
    pdata.lootInventory:refreshBackpacks()
    triggerEvent("OnContainerUpdate")
end

---Transfert every items from the `srcContainer` to the `destContainer`.
---@param player IsoPlayer
---@param srcContainer ItemContainer
---@param destContainer ItemContainer
ContainerManager.transferAll = function(player, srcContainer, destContainer)
    local items = srcContainer:getItems()
    if not items then return end
    for i = items:size() - 1, 0, -1 do
        local item = items:get(i)
        ISTransferAction:transferItem(player, item, srcContainer, destContainer, nil)    
    end
end

---@param horse IsoAnimal
---@param slot AttachmentSlot
---@param worldItem IsoWorldInventoryObject?
ContainerManager.registerContainerInformation = function(horse, slot, worldItem)
    local modData = HorseUtils.getModData(horse)
    local containers = modData.containers

    -- remove info
    if not worldItem then
        -- clear cached and saved info        
        containers[slot] = nil
    else
        local item = worldItem:getItem()

        -- init container info table
        ---@type ContainerInformation
        local containerInfo = {
            x = worldItem:getX(),
            y = worldItem:getY(),
            z = worldItem:getZ(),
            fullType = item:getFullType(),
            worldID = item:getID(),
            worldItem = worldItem,
            horseID = horse:getAnimalID(),
        }

        -- store in mod data
        containers[slot] = containerInfo
        
        -- cache
        -- HORSE_CONTAINERS[horse][slot] = containerInfo
    end
end

---@param player IsoPlayer
---@param horse IsoAnimal
---@param attachmentDef AttachmentDefinition
---@param accessory InventoryContainer
ContainerManager.initContainer = function(player, horse, attachmentDef, accessory)
    print("Init container")
    -- retrieve the container of the accessory
    local srcContainer = accessory:getItemContainer()
    DebugLog.log(tostring(srcContainer))
    assert(srcContainer ~= nil, "Accessory has container behavior but isn't a container.")

    -- retrieve the square the horse is on
    local square = horse:getSquare()
    assert(square ~= nil, "Horse isn't on a square.")

    -- create the invisible container
    local containerBehavior = attachmentDef.containerBehavior --[[@as ContainerBehavior]]
    local containerItem = square:AddWorldInventoryItem(containerBehavior.worldItem, 0,0,0)
    assert(containerItem:IsInventoryContainer(), "Invisible container ("..containerBehavior.worldItem..") used for "..accessory:getFullType().." isn't a container.")
    ---@cast containerItem InventoryContainer

    local worldItem = containerItem:getWorldItem()
    local destContainer = containerItem:getItemContainer()

    DebugLog.log(tostring(worldItem))
    DebugLog.log(tostring(destContainer))

    -- transfer everything to the invisible container
    ContainerManager.transferAll(player, srcContainer, destContainer)
    refreshInventories(player)

    -- register in the data of the horse the container being attached
    ContainerManager.registerContainerInformation(horse, attachmentDef.slot, worldItem)
end

---@param player IsoPlayer
---@param horse IsoAnimal
---@param slot AttachmentSlot
---@param accessory InventoryContainer
ContainerManager.removeContainer = function(player, horse, slot, accessory)
    -- retrieve the world container
    local worldItem = ContainerManager.getContainer(horse, slot)
    assert(worldItem ~= nil, "worldItem container not found.")
    
    -- retrieve the inventory container
    local container = accessory:getItemContainer()
    assert(container ~= nil, "Accessory doesn't have an ItemContainer. ("..tostring(accessory)..")")

    -- retrieve the InventoryItem of worldItem
    local containerItem = worldItem:getItem() --[[@as InventoryContainer]]
    assert(containerItem:IsInventoryContainer(), "worldItem isn't an InventoryContainer. ("..tostring(containerItem)..")")

    -- transfer items from world to inventory container
    ContainerManager.transferAll(player, containerItem:getItemContainer(), container)
    
    -- delete world item
    local square = horse:getSquare()
    assert(square ~= nil, "Horse isn't on a square.")

    square:transmitRemoveItemFromSquare(worldItem)
    worldItem:removeFromWorld()
    worldItem:removeFromSquare()
    ---@diagnostic disable-next-line
    worldItem:setSquare(nil)

    refreshInventories(player)

    -- sync cached and saved informations
    ContainerManager.registerContainerInformation(horse, slot, nil)
end

---@param horse IsoAnimal
---@param containerInfo ContainerInformation
---@return IsoWorldInventoryObject?
ContainerManager.findContainer = function(horse, containerInfo)
    ---@TODO to implement

    -- ContainerManager.registerContainerInformation(horse, attachmentDef, worldItem)
end

---@param horse IsoAnimal
---@param slot AttachmentSlot
---@return IsoWorldInventoryObject?
ContainerManager.getContainer = function(horse, slot)
    --  verify horse should have a container there
    local modData = HorseUtils.getModData(horse)
    local containers = modData.containers
    local containerInfo = containers[slot]
    if not containerInfo then return end

    -- if container not cached, find it
    local worldItem = containerInfo.worldItem
    if not worldItem then
        worldItem = ContainerManager.findContainer(horse, containerInfo)

        -- cache container or nil
        containerInfo.worldItem = worldItem
    end

    return worldItem
end


---@param horses IsoAnimal[]
ContainerManager.track = function(horses)
    for i = 1, #horses do repeat
        local horse = horses[i]
        local squareHorse = horse:getSquare()
        if not squareHorse then break end -- horse is flying ?

        -- get containers linked to the horse
        local modData = HorseUtils.getModData(horse)
        local containers = modData.containers

        -- for each container, retrieve its worldItem
        for slot, containerInfo in pairs(containers) do repeat
            local worldItem = containerInfo.worldItem

            -- try to find the container
            if not worldItem then
                worldItem = ContainerManager.findContainer(horse, containerInfo)
            end

            -- 
            if worldItem then
                -- update its position if the square is different
                local square = worldItem:getRenderSquare()
                if square and square ~= squareHorse then
                    -- remove the item from its square
                    local item = worldItem:getItem()
                    worldItem:removeFromSquare()
                    worldItem:removeFromWorld()

                    -- move it to the new square
                    local worldItem = squareHorse:AddWorldInventoryItem(item, 0, 0, 0):getWorldItem()
                    ContainerManager.registerContainerInformation(horse, slot, worldItem)
                end
            end
        until true end
    until true end    
end




-- ---@param horse IsoAnimal
-- HorseManager.onHorseAdded:add(function(horse)
--     HORSE_CONTAINERS[horse] = {}

--     -- get containers linked to the horse
--     local modData = HorseUtils.getModData(horse)
--     local containers = modData.containers

--     local toFind = {
--         horse = horse,
--     }
--     table.insert(FIND_CONTAINERS, {})
-- end)

-- ---Reset cache for horse container data and stop searching for its containers if needed.
-- ---@param horse IsoAnimal
-- HorseManager.onHorseRemoved:add(function(horse)
--     ---reset cache
--     HORSE_CONTAINERS[horse] = nil
-- end)


return ContainerManager
