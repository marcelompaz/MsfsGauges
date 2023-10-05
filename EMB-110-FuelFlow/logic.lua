local fuel_flow_gauge = Gauge:new({

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
            num_ticks = 6,
            internal_ticks = 8,
            ticks_labels = {"0", "100", "200", "300", "400", "500"},
            value = 0
        },
        top_of_scale = {500, 495}
    }
})

local fuel_flow_needle = Needle:new({
    circle_ratio = 0.15,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.85,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 10,
    max_movement_per_cycle = 1.5
}, fuel_flow_gauge)

fuel_flow_gauge:draw()

engine_number = user_prop_add_integer("Engine Number", 1, 4, 1, "Number of the engine that the rpm will be used")

top_txt = txt_add("FUEL FLOW", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", 72,
    14, 120, 120)

btn_txt = txt_add("Lbs/Hr", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", 70, 150,
    120, 120)

fuel_flow_needle:draw()

fs2020_variable_subscribe("TURB ENG FUEL FLOW PPH:" .. tostring(user_prop_get(engine_number)), "Pounds per hour", function(flow)
    fuel_flow_needle:set_value(flow)
end)
