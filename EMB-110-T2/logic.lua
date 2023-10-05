local t2_gauge = Gauge:new({

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
            initial_angle = 190,
            end_angle = 350,
            num_ticks = 11,
            internal_ticks = 1,
            ticks_labels = {"", "40-", "", "20", "", "0", "", "20", "", "40+", ""},
            value = -50
        },
        top_of_scale = {50, 350}
    },
})

local t2_needle = Needle:new({
    circle_ratio = 0.20,
    circle_color = "gray",
    circle_text = "T2",
    size_ratio = 0.70,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5,
 --   needle_label = {"font:" .. T2_GAUGE.font .. "; size: 20; color: black ; halign:center; valign:center", "L"}
}, t2_gauge)



t2_gauge:draw()
t2_needle:draw()

txt_add("T2", "font:Inconsolata-Bold.ttf; size:30; color: white; halign:center; valign:center;", 128*0.8, 128*0.8,
128*0.4, 128*0.4)

fs2020_variable_subscribe("AMBIENT TEMPERATURE", "CELSIUS",
    function(temperature)
        t2_needle:set_value(temperature)
    end)
