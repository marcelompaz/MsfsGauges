local TORQUE_GAUGE_CFG = {

    size = 400,

    major_tick = 16,
    minor_tick = 8,

    TICK_COLOR = "white",
    background = "#505761",
    gauge_bottom = "#12111e",

    initial_angle = 120,
    end_angle = 400,
    num_ticks = 23,
    internal_ticks = 3,

    gauge_ratio = 0.95,

    tick_labels = {"0", "", "2", "", "4", "", "6", "", "8", "", "10", "", "12", "", "14", "", "16", "", "18", "", "20",
                   "", "22"},

    tick_color = "white",

    arcs = {{
        color = "green",
        initial = 400,
        final = 1970,
        width = 10,
        internal = true
    }, {
        color = "red",
        initial = 1970,
        final = 2000,
        width = 10,
        internal = true
    }},

    font = "Inconsolata.ttf",
    font_color = "white",
    font_size = 25,
    internal_text = true,

    interpolate_table = {{0, 120}, {2200, 400}}
}

local NEEDLE = {
    circle_ratio = 0.15,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.85,
    needle_color = "#a3a8b0",
    needle_text = "",
    needle_tickness = 12,
    max_movement_per_cycle = 1.5
}


rpm_prop = user_prop_add_integer("Engine Number", 1, 4, 1, "Number of the engine that the rpm will be used")

draw_gauge(TORQUE_GAUGE_CFG)

torque_txt = txt_add("TORQUE", "font:Inconsolata-Bold.ttf; size:40; color: white; halign:center; valign:center;", 140,
    50, 120, 120)
lbfr_txt = txt_add("LB.FT. x 100", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;",
    110, 225, 200, 120)

torque_needle = add_needle(TORQUE_GAUGE_CFG, NEEDLE)

function new_data_fsx(bus_volts, trq)
    set_needle_value(torque_needle, TORQUE_GAUGE_CFG, trq)
end

fs2020_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "VOLTS", "ENG TORQUE:" .. tostring(user_prop_get(rpm_prop)),
    "Foot pounds", new_data_fsx)

