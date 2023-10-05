local oil_temp_gauge = Gauge:new({

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
            initial_angle = 90,
            end_angle = 360,
            num_ticks = 7,
            internal_ticks = 4,
            ticks_labels = {"0", "25", "50", "75", "100", "125", "150"},
            value = 0
        },
        top_of_scale = {150, 360}
    },

    arcs = {{
        color = "yellow",
        initial = 0,
        final = 15,
        width = 10,
        internal = true
    }, {
        color = "green",
        initial = 15,
        final = 100,
        width = 10,
        internal = true
    }, {
        color = "red",
        initial = 100,
        final = 150,
        width = 10,
        internal = true
    }}

})

local oil_temp_needle = Needle:new({
    circle_ratio = 0.20,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.15,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5
    --   needle_label = {"font:" .. MAIN_GAUGE.font .. "; size: 20; color: black ; halign:center; valign:center", "R"},
}, oil_temp_gauge)

oil_temp_gauge:draw()

engine_number = user_prop_add_integer("Engine Number", 1, 4, 1, "Number of the engine that the rpm will be used")

txt_add("OIL", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", 150,
    23, 120, 120)

txt_add("TEMP", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", 150, 43,
    120, 120)

oil_temp_needle:draw()

fs2020_variable_subscribe("GENERAL ENG OIL TEMPERATURE:" .. tostring(user_prop_get(engine_number)), "Celsius",
    function(flow)
        oil_temp_needle:set_value(flow)
    end)
