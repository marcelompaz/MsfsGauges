light_left = switch_add("off_left.png", "on_left.png", 0, 0, 247, 142, callback)

x_offset = -60

light_right = switch_add("off_right.png", "on_right.png", 494+x_offset, 0, 174, 142, callback)

autofeather_btn = switch_add("btn_off.png", "btn_on.png", 247, 0, 247, 142, function(position, direction)
    fs2020_event("TOGGLE_AUTOFEATHER_ARM")

end)

fs2020_variable_subscribe("PANEL AUTO FEATHER SWITCH:1", "BOOL", function(val)
    switch_set_position(light_left, val)
    switch_set_position(autofeather_btn, val)
    switch_set_position(light_right, val)
end)