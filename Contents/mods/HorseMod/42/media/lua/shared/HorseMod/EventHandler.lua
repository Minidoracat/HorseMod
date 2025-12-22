---@namespace HorseMod

---REQUIREMENTS
local Event = require("HorseMod/Event")

local EventHandler = {}

---Triggers when a horse gets loaded in.
EventHandler.onHorseAdded = Event.new() ---@as Event<IsoAnimal>

---Triggers when a horse gets unloaded.
EventHandler.onHorseRemoved = Event.new() ---@as Event<IsoAnimal>

return EventHandler