local config = {
    horseSoundVolume = nil,
    horseWalkSpeed = nil,
    horseTrotSpeed = nil,
    horseGallopSpeed = nil,
    horseJumpButton = nil
}


-- TODO: use translation strings for this
local function HorseConfig()
    local options = PZAPI.ModOptions:create("HorseMod", "Horse")

    options:addDescription("Change the volume of Horse sounds.")
    config.horseSoundVolume = options:addSlider("HorseSoundVolume", "Horse Sound Volume (Default 0.40)", 0.01, 1, 0.01, 0.40, "Set sound volume of horse sounds.")

    options:addDescription("Horse keybinds.")
    config.horseJumpButton = options:addKeyBind("HorseJumpButton", "Horse Jump Button", Keyboard.KEY_SPACE, "Change the keybind for horse jumping.")
end

HorseConfig()
