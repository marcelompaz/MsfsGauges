flaps_switch = switch_add("flaps_0.png", "flaps_25.png", "flaps_50.png", "flaps_75.png", "flaps_100.png", 0, 0, 486,
    990, function(position, direction)

        print(direction)
        fs2020_event(fif(direction == 1, "FLAPS_INCR", "FLAPS_DECR"))

    end)



local FLAPS_GAUGE = {

    size = 486,

    major_tick = 16,
    minor_tick = 8,

    top_x = 0,
    top_y = 990,

    TICK_COLOR = "white",
    background = "gray",
    gauge_bottom = "black",

    gauge_ratio = 0.98,

    tick_color = "white",

    font = "Inconsolata.ttf",
    font_color = "white",
    font_size = 25,
    internal_text = true,

    ticks_table = {
        {
            initial_angle = 350,
            end_angle = 550,
            num_ticks = 11,
            internal_ticks = 0,
            ticks_labels = {"UP", "", "20", "", "40", "", "60", "", "80", "", "DOWN"},
            value = 0
        },
        top_of_scale = {100, 550}
    }
}

local MAIN_NEEDLE = {
    circle_ratio = 0.15,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.85,
    needle_color = "white",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5
    --   needle_label = {"font:" .. MAIN_GAUGE.font .. "; size: 20; color: black ; halign:center; valign:center", "R"},
}

FLAPS_GAUGE = draw_gauge(FLAPS_GAUGE)

txt_add("FLAPS", "font:Inconsolata-Bold.ttf; size:50; color: white; halign:center; valign:center;", 72,
    1050, 120, 120)

txt_add("PERCENT", "font:Inconsolata-Bold.ttf; size:30; color: white; halign:center; valign:center;", 20, 1245,
    180, 120)

txt_add("EXTENDED", "font:Inconsolata-Bold.ttf; size:30; color: white; halign:center; valign:center;", 20, 1275,
    180, 120)


MAIN_NEEDLE = add_needle(FLAPS_GAUGE, MAIN_NEEDLE)




function new_data_fs(flaps, flaps_handle)
    interpolate_table = {{0, 0}, {25, 1}, {50, 2}, {75, 3}, {100, 4}}
    switch_value = interpolate_linear(interpolate_table, flaps_handle)
    switch_set_position(flaps_switch, switch_value)

    set_needle_value(MAIN_NEEDLE, FLAPS_GAUGE, flaps)

end

fs2020_variable_subscribe("TRAILING EDGE FLAPS LEFT PERCENT", "Percent", "FLAPS HANDLE PERCENT", "Percent", new_data_fs)