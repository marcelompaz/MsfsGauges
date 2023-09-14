--C:\Users\marce\AppData\Roaming\Microsoft Flight Simulator\Packages\Official\Steam\nextgensim-aircraft-bandeirante\html_ui\Pages\VCockpit\Instruments

-- Backgroud Image before anything else
img_add_fullscreen("background.png")

-- SOUNDS
snd_click = sound_add("click.wav")

local function button(pressed_btn, coord, size, cb)
    button_add(nil, pressed_btn, coord.x, coord.y, size.x, size.y, cb)
end

local function txt_enabled(btn, txt, size)
    t = txt_add(txt, "font:Inconsolata.ttf; size:9; color: Green; halign:center;", btn.x, btn.y - 14, size.x, 12)
    visible(t, false)
    return t
end

BTN_size = {
    x = 30,
    y = 20
}
UP_DN_SIZE = {
    x = 30,
    y = 30
}

-- first row
local HDG_btn = {
    x = 72,
    y = 20
}

local NAV_btn = {
    x = 108,
    y = 20
}

local APR_btn = {
    x = 144,
    y = 20
}

local YD_btn = {
    x = 217,
    y = 20
}

local AP_btn = {
    x = 251,
    y = 20
}

-- second row

local ALT_btn = {
    x = 72,
    y = 68
}

local IAS_btn = {
    x = 108,
    y = 68
}

local FD_btn = {
    x = 144,
    y = 68
}

local SOFTRIDE_btn = {
    x = 179,
    y = 68
}

local HALFBANK_btn = {
    x = 217,
    y = 68
}

local TEST_btn = {
    x = 251,
    y = 68
}

-- UP and DOWN
local DN_btn = {
    x = 36,
    y = 20
}
local UP_btn = {
    x = 36,
    y = 58
}

button(nil, DN_btn, UP_DN_SIZE, function()
    fs2020_event("AP_SPD_VAR_INC")
    sound_play(snd_click)
end)

button(nil, UP_btn, UP_DN_SIZE, function()
    fs2020_event("AP_SPD_VAR_DEC")
    sound_play(snd_click)
end)

-- HDG_btn
hdg_enabled = txt_enabled(HDG_btn, "HDG", BTN_size)

fs2020_variable_subscribe("AUTOPILOT HEADING LOCK", "Bool", function(val)
    visible(hdg_enabled, val)
end)

button(nil, HDG_btn, BTN_size, function()
    --    fs2020_event("AP_HDG_HOLD")
    fs2020_event("H:PMS50_APGA_AP_HDG")
    sound_play(snd_click)
end)

-- NAV_btn

nav_enabled = txt_enabled(NAV_btn, "NAV ARM", BTN_size)

-- todo check if is locked
fs2020_variable_subscribe("AUTOPILOT NAV1 LOCK", "Bool", function (nav)
    visible(nav_enabled, nav)
end)

button(nil, NAV_btn, BTN_size, function()
    --  fs2020_event("AP_NAV1_HOLD")
    fs2020_event("H:PMS50_APGA_AP_NAV")
    sound_play(snd_click)
end)

-- APR_btn
apr_enabled = txt_enabled(APR_btn, "APR ARM", BTN_size)

-- AUTOPILOT APPROACH ACTIVE
-- AUTOPILOT APPROACH CAPTURED
-- AUTOPILOT APPROACH HOLD

fs2020_variable_subscribe("AUTOPILOT APPROACH HOLD", "Bool", function(val)
    visible(apr_enabled, val)
end)

button(nil, APR_btn, BTN_size, function()
    -- fs2020_event("AP_APR_HOLD")
    fs2020_event("H:PMS50_APGA_AP_APR")
    sound_play(snd_click)
end)

-- YD_btn
yd_enabled = txt_enabled(YD_btn, "YD", BTN_size)

fs2020_variable_subscribe("AUTOPILOT YAW DAMPER", "Bool", function(val)
    yd_state = val
    visible(yd_enabled, yd_state)
end)

button(nil, YD_btn, BTN_size, function()
    --    if yd_state == false then
    --        fs2020_event("YAW_DAMPER_ON")
    --    else
    --        fs2020_event("YAW_DAMPER_OFF")
    --    end
    fs2020_event("H:PMS50_APGA_AP_YD")
    sound_play(snd_click)
end)

-- AP_btn
ap_enabled = txt_enabled(AP_btn, "AP", BTN_size)

fs2020_variable_subscribe("AUTOPILOT MASTER", "Bool", function(val)
    visible(ap_enabled, val)
end)

button(nil, AP_btn, BTN_size, function()
    -- fs2020_event("AP_MASTER")
    fs2020_event("H:PMS50_APGA_AP_AP")
    sound_play(snd_click)
end)

-- ALT btn
alt_enabled = txt_enabled(ALT_btn, "ALT", BTN_size)

fs2020_variable_subscribe("L:PMS50_APGA_ACTIVE_VERTICAL_MODE", "INT", function(val)
    if val == 3 then
        visible(alt_enabled, true)
    else
        visible(alt_enabled, false)
    end
end)

button(nil, ALT_btn, BTN_size, function()
    -- fs2020_event("AP_PANEL_ALTITUDE_HOLD")
    fs2020_event("H:PMS50_APGA_AP_ALT")
    sound_play(snd_click)
end)

-- IAS btn
ias_enabled = txt_enabled(IAS_btn, "IAS", BTN_size)

fs2020_variable_subscribe("L:PMS50_APGA_ACTIVE_VERTICAL_MODE", "INT", function(val)
    if val == 6 then
        visible(ias_enabled, true)
    else
        visible(ias_enabled, false)
    end
end)

button(nil, IAS_btn, BTN_size, function()
    fs2020_event("FLIGHT_LEVEL_CHANGE")
    sound_play(snd_click)
end)

-- FD btn
fd_enabled = txt_enabled(FD_btn, "FD", BTN_size)

fs2020_variable_subscribe("AUTOPILOT FLIGHT DIRECTOR ACTIVE", "BOOL", function(val)
    visible(fd_enabled, val)
end)

button(nil, FD_btn, BTN_size, function()    
    fs2020_event("TOGGLE_FLIGHT_DIRECTOR")    
    sound_play(snd_click)
end)


-- SOFT RIDE BTN (using for prop sync)

prop_enabled = txt_enabled(SOFTRIDE_btn, "P-SYNC", BTN_size)

fs2020_variable_subscribe("PROP SYNC ACTIVE:1", "BOOL", function(val)
     visible(prop_enabled, val)
end)

button(nil, SOFTRIDE_btn, BTN_size, function()
 
      fs2020_event("TOGGLE_PROPELLER_SYNC") 
      
      sound_play(snd_click)
end)

-- HALF BANK BTN (used for auto feeather)

autofeather_enabled = txt_enabled(HALFBANK_btn, "FEATHER", BTN_size)


button(nil, HALFBANK_btn, BTN_size, function()
     fs2020_event("TOGGLE_AUTOFEATHER_ARM")
     sound_play(snd_click)
end)

fs2020_variable_subscribe("PANEL AUTO FEATHER SWITCH:1", "BOOL", function(val)
    visible(autofeather_enabled, val)
end)


-- TEST BTN

button(nil, TEST_btn, BTN_size, function()
    sound_play(snd_click)
end)

