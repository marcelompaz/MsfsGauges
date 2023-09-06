in_transit = switch_add("prog_off.png", "prog_on.png", 0, 0, 291, 123, callback)
left_gear = switch_add("left_up.png", "left_down.png", 0, 123, 120, 250, callback)
center_gear = switch_add("center_up.png", "center_down.png", 120, 123, 50, 250, callback)
right_gear = switch_add("right_up.png", "right_down.png", 170, 123, 121, 250, callback)
gear_lever = switch_add("lever_up.png", "lever_down.png", 291, 0, 150, 570, function(state, direction)

    fs2020_event(fif(state == 0, "GEAR_DOWN", "GEAR_UP"))

end)
emergency = switch_add("emer_on.png", "emer_off.png", 441, 0, 160, 570, function(state, direction)

    fs2020_event("GEAR_EMERGENCY_HANDLE_TOGGLE")

end)

background = canvas_add(0, 123 + 250, 291, 570 - 250 - 123, function()
    _rect(0, 0, 291, 570 - 250 - 123)
    _fill("#606B77")
end)

parking_break_top = txt_add("PARK",
    "font:white-rabbit.regular.ttf; size:60; color: yellow; halign:center; valign: center", 0, 123 + 250, 291,
    (570 - 250 - 123) / 2)
parking_break_bottom = txt_add("BREAK",
    "font:white-rabbit.regular.ttf; size:60; color: yellow; halign:center; valign: center", 0,
    123 + 250 + (570 - 250 - 123) / 2, 291, (570 - 250 - 123) / 2)

fs2020_variable_subscribe("GEAR CENTER POSITION", "Percent", "GEAR LEFT POSITION", "Percent", "GEAR RIGHT POSITION",
    "Percent", "GEAR HANDLE POSITION", "Bool", "GEAR EMERGENCY HANDLE POSITION", "Bool", "BRAKE PARKING POSITION",
    "Bool", "ELECTRICAL MAIN BUS VOLTAGE", "Volts",
    function(center, left, right, handle_pos, emergency_pos, prk_brake, volts)
        center_on = center > 99
        right_on = right > 99
        left_on = left > 99
        transit = (center < 99 and center > 1) or (right < 99 and right > 1) or (left < 99 and left > 1)

        switch_set_position(in_transit, transit)
        switch_set_position(center_gear, center_on)
        switch_set_position(right_gear, right_on)
        switch_set_position(left_gear, left_on)
        switch_set_position(gear_lever, handle_pos)
        switch_set_position(emergency, emergency_pos)
        visible(parking_break_top, prk_brake)
        visible(parking_break_bottom, prk_brake)

    end)
