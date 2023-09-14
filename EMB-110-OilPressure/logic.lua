local OIL_PRESSURE_GAUGE = {

    size = 256,

    major_tick = 16,
    minor_tick = 6,

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
            initial_angle = 125,
            end_angle = 415,
            num_ticks = 15,
            internal_ticks = 1,
            ticks_labels = {"0", "", "20", "", "40", "", "60", "", "80", "", "100", "", "120" , "", "140"},
            value = 0
        },
        top_of_scale = {140, 415}
    },

    arcs = {{
        color = "red",
        initial = 40,
        final = 90,
        width = 10,
        internal = true
    },{
        color = "red",
        initial = 39.5,
        final = 40.5,
        width = 16,
        internal = true
    }
    , {
        color = "green",
        initial = 90,
        final = 110,
        width = 10,
        internal = true
    }}

}

local LEFT_NEEDLE = {
    circle_ratio = 0.20,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.70,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5,
    needle_label = {"font:" .. OIL_PRESSURE_GAUGE.font .. "; size: 20; color: black ; halign:center; valign:center", "L"}
}

local RIGHT_NEEDLE = {
    circle_ratio = 0.20,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.70,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5,
    needle_label = {"font:" .. OIL_PRESSURE_GAUGE.font .. "; size: 20; color: black ; halign:center; valign:center", "R"}
}

OIL_PRESSURE_GAUGE = draw_gauge(OIL_PRESSURE_GAUGE)

-- engine_number = user_prop_add_integer("Engine Number", 1, 4, 1, "Number of the engine that the rpm will be used")

x_diff = 70
y1 = 45

sy = 30

x = (256 / 2) -x_diff
sx = ((256 / 2) -x) * 2


y2 = 256/2 + y1


txt_add("OIL", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", x,
    y1, sx, sy)

txt_add("PSI", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", x, y2,
    sx, sy)

main_needle = add_needle(OIL_PRESSURE_GAUGE, LEFT_NEEDLE)
main_needle = add_needle(OIL_PRESSURE_GAUGE, RIGHT_NEEDLE)

fs2020_variable_subscribe("GENERAL ENG OIL PRESSURE:1", "PSI", "GENERAL ENG OIL PRESSURE:2", "PSI",
    function(left_oil, right_oil)
        set_needle_value(LEFT_NEEDLE, OIL_PRESSURE_GAUGE, left_oil)
        set_needle_value(RIGHT_NEEDLE, OIL_PRESSURE_GAUGE, right_oil)
    end)
