local FUEL_GAUGE = {

    size = 256,

    major_tick = 16,
    minor_tick = 8,

    TICK_COLOR = "white",
    background = "#505761",
    gauge_bottom = "#12111e",

    gauge_ratio = 0.98,

    tick_color = "white",


    font = "Inconsolata.ttf",
    font_color = "white",
    font_size = 25,
    internal_text = true,

    ticks_table = {
        {
            initial_angle = 225,
            end_angle = 495,
            num_ticks = 17,
            internal_ticks = 1,
            ticks_labels = {"0", "", "", "", "", "5", "", "", "", "", "10", "", "", "", "", "15", "", ""},
            value = 0
        },
        top_of_scale = {1600, 495}
    }
}

local MAIN_NEEDLE = {
    circle_ratio = 0.24,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.85,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5
    --   needle_label = {"font:" .. MAIN_GAUGE.font .. "; size: 20; color: black ; halign:center; valign:center", "R"},
}

MAIN_GAUGE = draw_gauge(FUEL_GAUGE)

choice_prop = user_prop_add_enum("Type", "LEFT,RIGHT", "LEFT", "Duh")


main_needle = add_needle(FUEL_GAUGE, MAIN_NEEDLE)

top_txt = txt_add("FUEL", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", 99, 99,
    60, 60)   

btn_txt = txt_add("Lbs*100", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", 70, 150,
120, 120)



fs2020_variable_subscribe("FUEL " .. tostring(user_prop_get(choice_prop)) .. " QUANTITY", "Gallons", function(fuel)
   
    set_needle_value(MAIN_NEEDLE, MAIN_GAUGE, fuel * 6.7)

end)
