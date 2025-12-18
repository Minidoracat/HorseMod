---@namespace HorseMod


---@class ModDataKind<T: table>
---@field package name string Mod data subtable name.
---@field package initialiser fun(horse:IsoAnimal,modData:table):nil Called when accessing the mod data to ensure it is initialised.


---@type table<string, true?>
local takenNames = {}


local HorseModData = {}


---Registers a new kind of mod data.
---@generic T
---@param name string Unique name of the mod data kind. This must be globally unique.
---@param initialiser fun(horse:IsoAnimal,modData:Partial<T>):nil Function to initialise the mod data kind. This will be called every time the mod data is accessed.
---@return ModDataKind<T> kind
function HorseModData.register(name, initialiser)
    if takenNames[name] then
        if isDebugEnabled() then
            -- we only warn in debug mode because this may be caused by a file reload
            print("[HorseMod] WARN: adding ModDataKind with already seen name " .. name)
        else
            error("tried to register two ModDataKinds with same name " .. name)
        end
    end
    takenNames[name] = true

    return {
        name = name,
        initialiser = initialiser
    }
end

---Returns mod data of a specific kind.
---@generic T
---@param horse IsoAnimal
---@param kind ModDataKind<T>
---@return T modData
function HorseModData.get(horse, kind)
    local modData = horse:getModData()

    modData.horseModData = modData.horseModData or {}
    local ourModData = modData.horseModData

    ourModData[kind.name] = ourModData[kind.name] or {}
    local kindModData = ourModData[kind.name] ---@as table god knows why this is resolving as nil
    
    kind.initialiser(horse, kindModData)
    return kindModData
end


return HorseModData