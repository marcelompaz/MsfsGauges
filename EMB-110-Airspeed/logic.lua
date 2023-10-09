local airspeed_gauge = Gauge:new({

    size = 256,

    major_tick = 20,
    minor_tick = 12,
    mini_tick = 5,

    TICK_COLOR = "white",
    background = "#505761",
    gauge_bottom = "#12111e",

    gauge_ratio = 0.95,

    tick_color = "white",

    font = "Inconsolata.ttf",
    font_color = "white",
    font_size = 18,
    internal_text = true,

    ticks_table = {
        {
            initial_angle = 195,
            end_angle = 525,
            num_ticks = 14,
            internal_ticks = 3,
            ticks_labels = {"4", "6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "30"},
            value = 40
        },
        top_of_scale = {300, 525}
    },

    extra_ticks = {{
        color = "red",
        size = 16,
        value = 85
    }, {
        color = "red",
        size = 16,
        value = 230
    }},

    arcs = {{
        color = "white",
        initial = 70,
        final = 148,
        width = 5,
        internal = false
    }, {
        color = "green",
        initial = 90,
        final = 230,
        width = 6,
        internal = true
    }}

})

local airspeed_needle = Needle:new({
    circle_ratio = 0.15,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.85,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 6,
    max_movement_per_cycle = 1.5
}, airspeed_gauge)

airspeed_gauge:draw()

torque_txt = txt_add("AIR SPEED", "font:Inconsolata-Bold.ttf; size:20; color: white; halign:center; valign:center;", 85,
    32, 87, 77)
lbfr_txt = txt_add("TENS OF", "font:Inconsolata-Bold.ttf; size:12; color: white; halign:center; valign:center;",
    62, 130, 128, 77)
lbfr_txt = txt_add("KNOTS", "font:Inconsolata-Bold.ttf; size:20; color: white; halign:center; valign:center;",
    62, 145, 128, 77)

airspeed_needle:draw()

fs2020_variable_subscribe("AIRSPEED INDICATED", "knots", function(airspeed)
    airspeed_needle:set_value(airspeed)
end)