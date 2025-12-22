---REQUIREMENTS
local EventHandler = require("HorseMod/EventHandler")

---@namespace HorseMod

---Used to access a kind of mod data defined for a horse such as containers, attachments and manes.
---@class ModDataKind<T: table>
---@field package name string Mod data subtable name.
---@field package initialiser? fun(horse:IsoAnimal,modData:table):nil Called when a horse loads in to ensure it's mod data are initialised.

local HorseModData = {
    ---@type table<string, ModDataKind<any>>
    modDataKinds = {},
}


---Registers a new kind of mod data.
---@generic T
---@param name string Unique name of the mod data kind. This must be globally unique.
---@param initialiser (fun(horse:IsoAnimal,modData:Partial<T>):nil)? Function to initialise the mod data kind. This will be called every time the mod data is accessed.
---@return ModDataKind<T> kind
function HorseModData.register(name, initialiser)
    if HorseModData.modDataKinds[name] then
        if isDebugEnabled() then
            -- we only warn in debug mode because this may be caused by a file reload
            print("[HorseMod] WARN: adding ModDataKind with already seen name " .. name)
        else
            error("tried to register two ModDataKinds with same name " .. name)
        end
    end
    local kind = {
        name = name,
        initialiser = initialiser,
    }
    HorseModData.modDataKinds[name] = kind
    return kind
end

---Initialises all mod data kinds for the given horse.
---@param horse IsoAnimal
function HorseModData.initialize(horse)
    local horseModData = HorseModData.getAll(horse)
    for name, kind in pairs(HorseModData.modDataKinds) do
        horseModData[name] = horseModData[name] or {}
        local kindModData = horseModData[name] --[[@as table goes crazy without it]]
        if kind.initialiser then
            kind.initialiser(horse, kindModData)
        end
    end
end

EventHandler.onHorseAdded:add(HorseModData.initialize)


---Returns mod data of a specific kind.
---@generic T
---@param horse IsoAnimal
---@param kind ModDataKind<T>
---@return T modData
function HorseModData.get(horse, kind)
    -- get the kind mod data
    local horseModData = HorseModData.getAll(horse)
    local kindModData = horseModData[kind.name]
    
    return kindModData
end

---Sets the global horse mod data.
---@generic T
---@param horse IsoAnimal
---@param data table<string, T>
function HorseModData.setAll(horse, data)
    local modData = horse:getModData()
    modData.horseModData = data
end

---Retrieve all horse mod data.
---@generic T
---@param horse IsoAnimal
---@return table<string, T>
function HorseModData.getAll(horse)
    local modData = horse:getModData()
    modData.horseModData = modData.horseModData or {}
    return modData.horseModData
end

function HorseModData.getGlobal()
    local md = ModData.getOrCreate("HorseMod")
    md.orphanedHorses = md.orphanedHorses or {}
    return md
end


return HorseModData