choice_prop = user_prop_add_enum("Type", "Nh,Ng", "Nh", "Type of ")

engine_number = user_prop_add_integer("Engine Number", 1, 4, 1, "Number of the engine that the rpm will be used")

local MAIN_GAUGE = {

    size = 400,

    major_tick = 16,
    minor_tick = 8,

    TICK_COLOR = "white",
    background = "gray",
    gauge_bottom = "black",

    initial_angle = 0,
    end_angle = 270,
    num_ticks = 11,
    internal_ticks = 0,

    gauge_ratio = 0.98,

    tick_labels = {"0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"},

    tick_color = "white",

    arcs = {{
        color = "green",
        initial = 80,
        final = 100,
        width = 10,
        internal = true
    }},

    font = "Inconsolata.ttf",
    font_color = "white",
    font_size = 25,
    internal_text = true,

    interpolate_table = {{0, 0}, {100, 270}, {110, 290}}
}

local DECIMAL_GAUGE = {

    size = 160,

    major_tick = 3,
    minor_tick = 8,

    TICK_COLOR = "white",
    background = nil,
    gauge_bottom = "black",

    initial_angle = 0,
    end_angle = 360,
    num_ticks = 11,
    internal_ticks = 0,

    gauge_ratio = 0.7,

    tick_labels = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ""},

    tick_color = "white",

    arcs = {{
        color = "white",
        initial = 0,
        final = 10,
        width = 1,
        external = true
    }},

    font = "Inconsolata.ttf",
    font_color = "white",
    font_size = 14,
    internal_text = false,

    interpolate_table = {{0, 0}, {10, 360}},

    top_x = 35,
    top_y = 35
}

local MAIN_NEEDLE = {
    circle_ratio = 0.15,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.85,
    needle_color = "white",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5,
 --   needle_label = {"font:" .. MAIN_GAUGE.font .. "; size: 20; color: black ; halign:center; valign:center", "R"},
}

local DECIMAL_NEEDLE = {
    circle_ratio = 0.05,
    circle_color = "white",
    circle_text = "",
    size_ratio = 0.6,
    needle_color = "white",
    needle_text = "",
    needle_tickness = 6,
    max_movement_per_cycle = -1
}

MAIN_GAUGE = draw_gauge(MAIN_GAUGE)
DECIMAL_GAUGE = draw_gauge(DECIMAL_GAUGE)

torque_txt = txt_add(tostring(user_prop_get(choice_prop)),
    "font:Inconsolata-Bold.ttf; size:40; color: white; halign:center; valign:center;", 110, 190, 200, 120)
lbfr_txt = txt_add("% RPM", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", 110, 225,
    200, 120)

main_needle = add_needle(MAIN_GAUGE, MAIN_NEEDLE)
decimal_needle = add_needle(DECIMAL_GAUGE, DECIMAL_NEEDLE)


function set_value(percent)
    if percent > 100 then
        decimal_value = percent % 100
    else
        decimal_value = percent % 10
    end

    set_needle_value(MAIN_NEEDLE, MAIN_GAUGE, percent)
    set_needle_value(DECIMAL_NEEDLE, DECIMAL_GAUGE, decimal_value)

end

if tostring(user_prop_get(choice_prop)) == "Ng" then
    fs2020_variable_subscribe("TURB ENG N1:" .. tostring(user_prop_get(engine_number)), "PERCENT", set_value)
else
    fs2020_variable_subscribe("PROP MAX RPM PERCENT:" .. tostring(user_prop_get(engine_number)), "PERCENT", set_value)
end

