-- Backgroud Image before anything else
img_add_fullscreen("background.png")

-- SOUNDS
snd_click = sound_add("click.wav")
snd_dial = sound_add("dial.wav")
snd_alarm = sound_add("alarm.wav")
snd_alarm2 = sound_add("alarm2.wav")

function round(fl_value)
    return math.floor(fl_value + 0.5)
end

Display = {}

function Display:new(x_top, y_top, x_size, y_size)
    local obj = {}
     function txt(txt, font, y_ratio, x_ratio_begin, x_ratio_end, line_ratio)
        return txt_add(txt, font, x_top + (x_size * x_ratio_begin), y_top + (y_size * y_ratio),
            (x_size * (x_ratio_end - x_ratio_begin)), y_size * line_ratio)
    end

    minor_font = y_size * 0.22
    major_font = y_size * 0.53
    minor_line_ratio = 0.2
    major_line_ratio = 0.6

    obj.vs_enabled = txt("VS", "font:DS-DIGI.TTF; size:" .. minor_font .. "; color: red; halign:left; valign:center", 0,
        0.02, 0.2, minor_line_ratio)
    obj.arm = txt("ARM", "font:DS-DIGI.TTF; size:" .. minor_font .. "; color: red; halign:left; valign:center", 0.8,
        0.02, 0.2, minor_line_ratio)
    obj.capt = txt("CAPT", "font:DS-DIGI.TTF; size:" .. minor_font .. "; color: red; halign:left; valign:center", 0.8,
        0.3, 0.65, minor_line_ratio)
    obj.unit = txt("FT/MIN", "font:DS-DIGI.TTF; size:" .. minor_font .. "; color: red; halign:left; valign:center", 0.8,
        0.65, 1.0, minor_line_ratio)

    obj.alarm = txt("ALARM", "font:DS-DIGI.TTF; size:" .. minor_font .. "; color: red; halign:left; valign:center", 0,
        0.7, 1.0, minor_line_ratio)

    obj.value = txt("20,000", "font:DS-DIGI.TTF; size:" .. major_font .. "; color: red; halign:right; valign:center",
        0.2, 0.23, 1.0, major_line_ratio)
    obj.up = txt("^", "font:DS-DIGI.TTF; size:" .. major_font .. "; color: red; halign:center; valign:center", 0.3, 0.0,
        0.2, major_line_ratio / 2)
    obj.down = txt("^", "font:DS-DIGI.TTF; size:" .. major_font .. "; color: red; halign:center; valign:center", 0.35,
        0.0, 0.2, major_line_ratio / 2)
    obj.selected_altitude = 10000
    obj.selected_vs = -1000
    obj.is_vs = false
    obj.state_value = 0

    rotate(obj.down, 180)

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Display:set_vs(is_vs)
    self.is_vs = is_vs
    self:update_values()
end

function Display:vs_button(vs_enabled)
    visible(self.vs_enabled, vs_enabled)
end

function Display:update_values()
    function formatNumberWithCommas(number)
        local formatted = tostring(math.abs(number))
        local sep = ","
        local pos = string.len(formatted) - 3

        while pos > 0 do
            formatted = string.sub(formatted, 1, pos) .. sep .. string.sub(formatted, pos + 1)
            pos = pos - 3
        end

        return formatted
    end

    if self.is_vs then
        txt_set(self.unit, "FT/MIN")
        txt_set(self.value, formatNumberWithCommas(self.selected_vs))
        visible(self.up, self.selected_vs > 0)
        visible(self.down, self.selected_vs < 0)
    else
        txt_set(self.unit, "FT")
        txt_set(self.value, formatNumberWithCommas(self.selected_altitude))
        visible(self.up, false)
        visible(self.down, false)

    end

end

display = Display:new(69, 35, 173, 99)
-- visible(display.vs_indicator, true)

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

dial_outer = dial_add(nil, 235, 47, 80, 80, function(direction)
    if direction == 1 then
        if display.is_vs then
            fs2020_event("H:PMS50_APGA_SEL_VS_LARGE_INC")
        else
            fs2020_event("H:PMS50_APGA_SEL_ALT_LARGE_INC")
        end
        sound_play(snd_dial)
    elseif direction == -1 then
        if display.is_vs then
            fs2020_event("H:PMS50_APGA_SEL_VS_LARGE_DEC")
        else
            fs2020_event("H:PMS50_APGA_SEL_ALT_LARGE_DEC")
        end
        sound_play(snd_dial)
    end
end)

dial_inner = dial_add(nil, 260, 65, 45, 45, function(direction)
    if direction == 1 then
        if display.is_vs then
            fs2020_event("H:PMS50_APGA_SEL_VS_SMALL_INC")
        else
            fs2020_event("H:PMS50_APGA_SEL_ALT_SMALL_INC")
        end        
        sound_play(snd_dial)
    elseif direction == -1 then
        if display.is_vs then
            fs2020_event("H:PMS50_APGA_SEL_VS_SMALL_DEC")
        else
            fs2020_event("H:PMS50_APGA_SEL_ALT_SMALL_DEC")
        end       
        sound_play(snd_dial)
    end
end)

mouse_setting(dial_inner, "CURSOR_LEFT", "ctr_cursor_ccw.png")
mouse_setting(dial_inner, "CURSOR_RIGHT", "ctr_cursor_cw.png")

fs2020_variable_subscribe("L:XMLVAR_KAS297C_VSSelectionMode", "Double", function(val)
    vs_enabled = round(val)
    if vs_enabled == 1 then
        is_vs_mode = true
    else
        is_vs_mode = false
    end
    display:set_vs(is_vs_mode)
end)

fs2020_variable_subscribe("L:PMS50_APGA_ARM_BUTTON_STATE", "Double", function(val)
    arm_enabled = round(val)
    if arm_enabled == 1 then
        bool_val = true
    else
        bool_val = false
    end
    visible(display.arm, arm_enabled)

end)

fs2020_variable_subscribe("L:PMS50_APGA_SELECTED_ALTITUDE_PHASE", "Double", function(val)
    phase = round(val)
    
    if display.state_value ~= 4 and val == 4 then
        sound_play(snd_alarm)
    end

    if display.state_value ~= 2 and val == 2 then
        sound_play(snd_alarm2)
    end        
             
    display.state_value = val           
    
    visible(display.capt, val == 4)
    visible(display.alarm, val == 2)
end)

fs2020_variable_subscribe("L:PMS50_APGA_VS_BUTTON_STATE", "Double", function(val)
    state = round(val)
    display:vs_button(state == 1)
end)

fs2020_variable_subscribe("L:PMS50_APGA_SELECTED_VS", "Double", function(vs)
    int_vs = round(vs)

    display.selected_vs = int_vs
    display:update_values()
end)

fs2020_variable_subscribe("L:PMS50_APGA_SELECTED_ALTITUDE", "Double", function(alt)
    int_alt = round(alt)
    display.selected_altitude = int_alt
    display:update_values()
end)

button_pcr = button_add(nil, nil, 277, 81, 17, 17, function()
    is_vs_mode = not is_vs_mode
    display:set_vs(is_vs_mode)
end)

