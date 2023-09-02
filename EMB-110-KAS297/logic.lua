-- Backgroud Image before anything else
img_add_fullscreen("background.png")

-- SOUNDS
snd_click = sound_add("click.wav")
snd_dial = sound_add("dial.wav")

local function button(pressed_btn, coord, size, cb)
    button_add(nil, pressed_btn, coord.x, coord.y, size.x, size.y, cb)
end

BTN_size = {
    x = 34,
    y = 17
}

local ENG_btn = {
    x = 18,
    y = 56
}

local ARM_btn = {
    x = 18,
    y = 96
}

button(nil, ENG_btn, BTN_size, function()
    fs2020_event("H:PMS50_APGA_AP_VS")
    sound_play(snd_dial)
end)

button(nil, ARM_btn, BTN_size, function()
    fs2020_event("H:PMS50_APGA_AP_ARM")
    
    sound_play(snd_dial)
end)

dial_outer = dial_add(nil, 245, 57, 57, 57, function(direction)
    if direction == 1 then
        fs2020_event("H:PMS50_APGA_SEL_ALT_LARGE_INC")
        sound_play(snd_dial)
    elseif direction == -1 then
        fs2020_event("H:PMS50_APGA_SEL_ALT_LARGE_DEC")
        sound_play(snd_dial)
    end
end)

dial_inner = dial_add(nil, 265, 70, 30, 30, function(direction)
    if direction == 1 then
        fs2020_event("H:PMS50_APGA_SEL_ALT_SMALL_INC")
        sound_play(snd_dial)
    elseif direction == -1 then
        fs2020_event("H:PMS50_APGA_SEL_ALT_SMALL_DEC")
        sound_play(snd_dial)
    end
end)
