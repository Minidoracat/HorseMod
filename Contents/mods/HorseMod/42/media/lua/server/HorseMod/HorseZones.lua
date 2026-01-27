---@namespace horse


---Horse spawn region.
---@class HorseZone
---
---Coordinate X number 1.
---@field x1 integer
---
---Coordinate Y number 2.
---@field y1 integer
---
---Coordinates X number 2.
---@field x2 integer
---
---Coordinates Y number 2.
---@field y2 integer
---
---World Z level of the zone.
---@field z integer?
---
---Name of the `RanchZoneDefinitions` type to use.
---@field name string?

RanchZoneDefinitions.type["horse"] = {
    type = "horse",
    globalName = "horse",
    chance = 100,
    femaleType = "mare",
    maleType = "stallion",
    minFemaleNb = 1,
    maxFemaleNb = 2,
    minMaleNb = 1,
    maxMaleNb = 2,
    chanceForBaby = 5,
    maleChance = 50
}
RanchZoneDefinitions.type["horseSmall"] = {
    type = "horseSmall",
    globalName = "horse",
    chance = 100,
    femaleType = "mare",
    maleType = "stallion",
    minFemaleNb = 0,
    maxFemaleNb = 1,
    minMaleNb = 0,
    maxMaleNb = 1,
    chanceForBaby = 5,
    maleChance = 50
}
RanchZoneDefinitions.type["horseMedium"] = {
    type = "horseMedium",
    globalName = "horse",
    chance = 100,
    femaleType = "mare",
    maleType = "stallion",
    minFemaleNb = 1,
    maxFemaleNb = 2,
    minMaleNb = 1,
    maxMaleNb = 2,
    chanceForBaby = 5,
    maleChance = 50
}
RanchZoneDefinitions.type["horseLarge"] = {
    type = "horseLarge",
    globalName = "horse",
    chance = 100,
    femaleType = "mare",
    maleType = "stallion",
    minFemaleNb = 2,
    maxFemaleNb = 4,
    minMaleNb = 2,
    maxMaleNb = 4,
    chanceForBaby = 5,
    maleChance = 50
}

local DEFAULT_HORSE_ZONE = "horseMedium"

---Creates and manages horse spawn zones e.g. stables.
local HorseZones = {}


---Horse zones to be created.
---@type HorseZone[]
HorseZones.zones = {
-- riverside country club
    { x1 = 5554, y1 = 6593, x2 = 5625, y2 = 6585, name="horseLarge" }, --bottom stables
    { x1 = 5546, y1 = 6513, x2 = 5617, y2 = 6505, name="horseLarge" }, --top stables

-- horse fields
    { x1 = 2206, y1 = 12222, x2 = 2519, y2 = 12522, name="horseLarge" }, -- middle of Echo Creek, Ekron and Irvington

    { x1 = 1515, y1 = 12141, x2 = 1600, y2 = 12054, name="horseMedium" }, -- middle of Echo Creek, Ekron and Irvington
    { x1 = 1601, y1 = 12023, x2 = 1609, y2 = 12017, name="horseSmall" },

    { x1 = 2956, y1 = 13323, x2 = 3075, y2 = 13232, name="horseLarge" }, -- near Irvington
    { x1 = 2965, y1 = 14337, x2 = 3036, y2 = 14250, name="horseMedium" }, -- near Irvington
    { x1 = 3606, y1 = 14921, x2 = 3810, y2 = 14777, name="horseLarge" }, -- near Irvington
    { x1 = 633, y1 = 11732, x2 = 458, y2 = 11550, name="horseLarge" }, -- near Ekron
    { x1 = 1080, y1 = 10910, x2 = 842, y2 = 11330, name="horseLarge" }, -- near Ekron
    { x1 = 1516, y1 = 11095, x2 = 1590, y2 = 10978, name="horseMedium" }, -- near Ekron
    { x1 = 700, y1 = 10792, x2 = 816, y2 = 9915, name="horseLarge" }, -- near Ekron
    { x1 = 1874, y1 = 9782, x2 = 1781, y2 = 9885, name="horseLarge" }, -- near Ekron
    { x1 = 1206, y1 = 9172, x2 = 1326, y2 = 9006, name="horseLarge" }, -- near Ekron
    { x1 = 3775, y1 = 11080, x2 = 3878, y2 = 10933, name="horseMedium" }, -- near Echo Creek
    
-- stables
    -- near Ekron
    { x1 = 241, y1 = 9839, x2 = 244, y2 = 9822, name="horseSmall" },
    { x1 = 249, y1 = 9839, x2 = 252, y2 = 9822, name="horseSmall" },
    { x1 = 1606, y1 = 9037, x2 = 1589, y2 = 9040, name="horseSmall" },
    { x1 = 1589, y1 = 9048, x2 = 1606, y2 = 9045, name="horseSmall" },
    { x1 = 1589, y1 = 9060, x2 = 1606, y2 = 9063, name="horseSmall" },
    { x1 = 1606, y1 = 9068, x2 = 1589, y2 = 9071, name="horseSmall" },
    { x1 = 1405, y1 = 10290, x2 = 1398, y2 = 10288, name="horseSmall" },
    { x1 = 1740, y1 = 10279, x2 = 1747, y2 = 10280, name="horseSmall" },

    -- near Brandenburg
    { x1 = 3547, y1 = 8202, x2 = 3554, y2 = 8204, name="horseSmall" },
    { x1 = 3554, y1 = 8207, x2 = 3547, y2 = 8210, name="horseSmall" },
    { x1 = 3561, y1 = 8202, x2 = 3568, y2 = 8204, name="horseSmall" },
    { x1 = 3561, y1 = 8208, x2 = 3598, y2 = 8210, name="horseSmall" },
    { x1 = 1261, y1 = 7314, x2 = 1273, y2 = 7317, name="horseSmall" }, -- rich manor
    { x1 = 2416, y1 = 5923, x2 = 2418, y2 = 5916, name="horseSmall" },

    -- central park stables
    { x1 = 13035, y1 = 2813, x2 = 13048, y2 = 2816, name="horseSmall" },
    { x1 = 13029, y1 = 2819, x2 = 13032, y2 = 2834, name="horseSmall" },
    { x1 = 13035, y1 = 2837, x2 = 13050, y2 = 2840, name="horseSmall" },

    { x1 = 13611, y1 = 4722, x2 = 13618, y2 = 4723, name="horseSmall" }, -- near Valley Station

    -- near Fallas Lake
    { x1 = 7130, y1 = 9560, x2 = 7137, y2 = 9562, name="horseSmall" },
    { x1 = 7142, y1 = 9560, x2 = 7149, y2 = 9561, name="horseSmall" },
    { x1 = 7132, y1 = 9578, x2 = 7130, y2 = 9573, name="horseSmall" },
    { x1 = 8553, y1 = 8523, x2 = 8551, y2 = 8518, name="horseSmall" },

-- farmer's market
    { x1 = 13707, y1 = 3634, x2 = 13722, y2 = 3623, name="horseSmall" },


-- LV horsetracks stables
    { x1 = 12334, y1 = 2793, x2 = 12338, y2 = 2775, name="horseSmall" },
    { x1 = 12334, y1 = 2760, x2 = 12338, y2 = 2752, name="horseSmall" },
    { x1 = 12334, y1 = 2750, x2 = 12338, y2 = 2742, name="horseSmall" },
    { x1 = 12356, y1 = 2754, x2 = 12364, y2 = 2757, name="horseSmall" },
    { x1 = 12356, y1 = 2766, x2 = 12364, y2 = 2769, name="horseSmall" },
    { x1 = 12356, y1 = 2775, x2 = 12364, y2 = 2778, name="horseSmall" },
    { x1 = 12356, y1 = 2787, x2 = 12364, y2 = 2790, name="horseSmall" },
}


local function addHorseZones()
    DebugLog.log("HorseMod: creating horse zones")

    local world = getWorld()

    local zonesFailed = 0
    for i = 1, #HorseZones.zones do
        local zoneDef = HorseZones.zones[i]

        -- the top corner (-X,-Y) is the main coordinate point
        -- so we identify it easily from any two given corners
        local x1, y1 = zoneDef.x1, zoneDef.y1
        local x2, y2 = zoneDef.x2, zoneDef.y2
        local main_x = x1 < x2 and x1 or x2
        local main_y = y1 < y2 and y1 or y2

        -- calculate width (+X) and height (+Y)
        local width = math.abs(x2 - x1) + 1
        local height = math.abs(y2 - y1) + 1

        local z = zoneDef.z or 0
        local name = zoneDef.name or DEFAULT_HORSE_ZONE

        local zone = world:registerZone(
            name, "Ranch",
            main_x, main_y, z,
            width, height
        )
        if zone == nil then
            DebugLog.log(
                string.format(
                    "HorseMod: failed to create horse zone at %d,%d,%d",
                    main_x, main_y, z
                )
            )
            zonesFailed = zonesFailed + 1
        end
    end

    if getDebug() and zonesFailed > 0 then
        error(
            string.format("Failed to create %d horse zones", zonesFailed)
        )
    end
end

Events.OnLoadMapZones.Add(addHorseZones)


return HorseZones