local fuel_pressure_gauge = Gauge:new({

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
            initial_angle = 280,
            end_angle = 620,
            num_ticks = 10,
            internal_ticks = 4,
            ticks_labels = {"0", "", "10", "", "20", "", "30", "", "40", ""},
            value = 0
        },
        top_of_scale = {45, 620}
    },

    arcs = {{
        color = "green",
        initial = 12,
        final = 45,
        width = 10,
        internal = true
    }}

})

local left_fuel_pressure_needle = Needle:new({
    circle_ratio = 0.20,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.70,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5,
    needle_label = {"font:" .. fuel_pressure_gauge.font .. "; size: 20; color: black ; halign:center; valign:center",
                    "L"}
}, fuel_pressure_gauge)

local right_fuel_pressure_needle = Needle:new({
    circle_ratio = 0.20,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.70,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5,
    needle_label = {"font:" .. fuel_pressure_gauge.font .. "; size: 20; color: black ; halign:center; valign:center",
                    "R"}
}, fuel_pressure_gauge)

fuel_pressure_gauge:draw()

x_diff = 70
y1 = 45

sy = 30

x = (256 / 2) - x_diff
sx = ((256 / 2) - x) * 2

y2 = 256 / 2 + y1

txt_add("FUEL", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", x, y1, sx, sy)

txt_add("PSI", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", x, y2, sx, sy)

left_fuel_pressure_needle:draw()
right_fuel_pressure_needle:draw()

fs2020_variable_subscribe("GENERAL ENG FUEL PRESSURE:1", "PSI", "GENERAL ENG FUEL PRESSURE:2", "PSI",
    function(left_fuel_pressure, right_fuel_pressure)
        left_fuel_pressure_needle:set_value(left_fuel_pressure)
        right_fuel_pressure_needle:set_value(right_fuel_pressure)
    end)
