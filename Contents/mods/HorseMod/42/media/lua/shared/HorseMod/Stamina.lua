-- media/lua/shared/Stamina.lua
local Stamina = {}
local HorseRiding = require("HorseMod/Riding")

-- Tunables (percent points per second)
Stamina.MAX            = 100
Stamina.DRAIN_RUN      = 6      -- while galloping
Stamina.REGEN_TROT     = 1.5     -- moving w/ HorseTrot true
Stamina.REGEN_WALK     = 3.0     -- moving but not running/trotting
Stamina.REGEN_IDLE     = 6.0     -- standing still
Stamina.REGEN_NEARBY   = 3.0     -- generic regen for untracked nearby horses

local function clamp(x, a, b) return (x < a) and a or ((x > b) and b or x) end

function Stamina.get(horse)
    if not (horse and horse.getModData) then return Stamina.MAX end
    local md = horse:getModData()
    if md.hm_stam == nil then
        md.hm_stam = Stamina.MAX
        if horse.transmitModData then horse:transmitModData() end
    end
    return md.hm_stam
end

function Stamina.set(horse, v, transmit)
    if not (horse and horse.getModData) then return end
    local md = horse:getModData()
    local nv = clamp(v, 0, Stamina.MAX)
    if md.hm_stam ~= nv then
        md.hm_stam = nv
        if transmit and horse.transmitModData then horse:transmitModData() end
    end
    return nv
end

function Stamina.modify(horse, dv, transmit)
    return Stamina.set(horse, Stamina.get(horse) + dv, transmit)
end

function Stamina.runSpeedFactor(horse)
    local s = Stamina.get(horse) / Stamina.MAX
    if s >= 0.5 then return 1.0 end
    local t = s / 0.5
    return t * t
end

function Stamina.canRun(horse)
    return Stamina.get(horse) > 10.0
end

local accum = 0.0
local SCAN_RADIUS = 7

local function isHorse(an)
    if not (an and an.getAnimalType) then return false end
    local t = an:getAnimalType()
    return t == "stallion" or t == "mare" or t == "filly"
end

local function eachNearbyHorses(player, r, fn)
    if not player then return end
    local z = player:getZ()
    local px, py = math.floor(player:getX()), math.floor(player:getY())
    for x = px - r, px + r do
        for y = py - r, py + r do
            local sq = getCell():getGridSquare(x, y, z)
            if sq then
                local animals = sq:getAnimals()
                if animals then
                    for i = 0, animals:size()-1 do
                        local a = animals:get(i)
                        if instanceof(a, "IsoAnimal") and isHorse(a) then
                            fn(a)
                        end
                    end
                end
            end
        end
    end
end

local function tickPassive(dt)
    accum = accum + dt
    if accum < 0.30 then return end
    accum = 0.0

    local num = getNumActivePlayers and getNumActivePlayers() or 1
    for p = 0, num-1 do
        local player = getSpecificPlayer(p)
        local mounted = nil
        local lastHorse = nil
        if player then
            if HorseRiding and HorseRiding.playerMounts and HorseRiding.lastMounted then
                mounted   = HorseRiding.playerMounts[p]
                lastHorse = HorseRiding.lastMounted[p]

                if lastHorse and lastHorse ~= mounted then
                    Stamina.modify(lastHorse, Stamina.REGEN_IDLE * 0.30, true)
                end
            end

            eachNearbyHorses(player, SCAN_RADIUS, function(h)
                if h ~= mounted and h ~= lastHorse then
                    Stamina.get(h)
                    Stamina.modify(h, Stamina.REGEN_NEARBY * 0.30, true)
                end
            end)
        end
    end
end

Events.OnTick.Add(function()
    local dt = GameTime.getInstance():getTimeDelta()
    tickPassive(dt)
end)

return Stamina
