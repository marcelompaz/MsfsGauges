local MAIN_GAUGE = {

    size = 400,

    major_tick = 16,
    minor_tick = 8,

    TICK_COLOR = "white",
    background = "#505761",
    gauge_bottom = "#12111e",

    initial_angle = 0,
    end_angle = 270,
    num_ticks = 11,
    internal_ticks = 0,

    gauge_ratio = 0.98,

    tick_labels = {"0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"},

    tick_color = "white",

    arcs = {{
        color = "green",
        initial = 400,
        final = 740,
        width = 10,
        internal = true
    }, {
        color = "yellow",
        initial = 740,
        final = 780,
        width = 10,
        internal = true
    }},

    font = "Inconsolata.ttf",
    font_color = "white",
    font_size = 25,
    internal_text = true,

    ticks_table = {
        {
            initial_angle = 160,
            end_angle = 185,
            num_ticks = 4,
            internal_ticks = 0,
            ticks_labels = {"1", "", "3", ""},
            value = 100
        },
        {
            initial_angle = 185,
            end_angle = 230,
            num_ticks = 3,
            internal_ticks = 0,
            ticks_labels = {"", "5", "6"},
            value = 400
        },
        {
            initial_angle = 230,
            end_angle = 315,
            num_ticks = 5,
            internal_ticks = 4,
            ticks_labels = {"", "", "7", "", "8"},
            value = 600
        },
        {
            initial_angle = 315,
            end_angle = 325,
            num_ticks = 2,
            internal_ticks = 4,
            ticks_labels = {"", ""},
            value = 800
        },
        {
            initial_angle = 325,
            end_angle = 340,
            num_ticks = 1,
            internal_ticks = 0,
            ticks_labels = {"", ""},
            value = 900
        },
        {
            initial_angle = 340,
            end_angle = 360,
            num_ticks = 2,
            internal_ticks = 0,
            ticks_labels = {"", "10"},
            value = 950
        },
        {
            initial_angle = 360,
            end_angle = 370,
            num_ticks = 2,
            internal_ticks = 1,
            ticks_labels = {"", "12"},
            value = 1000
        },
        top_of_scale = {1200, 370}
    }
}

local MAIN_NEEDLE = {
    circle_ratio = 0.15,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.85,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5
    --   needle_label = {"font:" .. MAIN_GAUGE.font .. "; size: 20; color: black ; halign:center; valign:center", "R"},
}

MAIN_GAUGE = draw_gauge(MAIN_GAUGE)

engine_number = user_prop_add_integer("Engine Number", 1, 4, 1, "Number of the engine that the rpm will be used")

top_txt = txt_add("°C", "font:Inconsolata-Bold.ttf; size:50; color: white; halign:center; valign:center;", 100, 50,
    200, 120)   

t5_txt = txt_add("x100", "font:Inconsolata-Bold.ttf; size:50; color: white; halign:center; valign:center;", 100, 240,
200, 120)

main_needle = add_needle(MAIN_GAUGE, MAIN_NEEDLE)



lbfr_txt = txt_add("T5", "font:Inconsolata-Bold.ttf; size:40; color: white; halign:center; valign:center;", 180, 180,
    40, 40)
 

function set_value(celcius)
    set_needle_value(MAIN_NEEDLE, MAIN_GAUGE, celcius)
end

fs2020_variable_subscribe("TURB ENG ITT:" .. tostring(user_prop_get(engine_number)), "CELSIUS", set_value)


