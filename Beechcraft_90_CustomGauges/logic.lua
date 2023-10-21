local airspeed_gauge = Gauge:new({
    size = 500,

    major_tick = 16,
    minor_tick = 8,

    background_img = {
        file = "instrument_base.png",
        offset_x = 0,
        offset_y = 0,
        size = 500
    },
    gauge_img = {
        file = "gauge.png",
        offset_x = 0,
        offset_y = 0,
        size = 500
    },

    background = "#505761",
    gauge_bottom = "#12111e",

    gauge_ratio = 0.90,

    tick_color = "white",

    font = "Aller_Bd.ttf",
    font_color = "white",
    font_size = 30,
    internal_text = true,

    ticks_table = {
        {
            initial_angle = 20,
            end_angle = 340,
            num_ticks = 22,
            internal_ticks = 1,
            ticks_labels = {"40", "", "60", "", "80", "", "100", "", "120", "", "140", "", "160", "", "180", "", "200",
                            "", "220", "", "240", "", "260"},
            value = 40
        },
        top_of_scale = {260, 340}
    },

    extra_ticks = {{
        color = "red",
        size = 80,
        value = 80
    }, {
        color = "blue",
        size = 80,
        value = 115
    }},

    arcs = {{
        color = "white",
        initial = 78,
        final = 84,
        width = 8,
        internal = true
    }, {
        color = "white",
        initial = 84,
        final = 158,
        width = 5,
        internal = true
    }}

})

airspeed_gauge:draw()

local barberpole_needle = ImageNeedle:new({
    image = "barberpole.png",
    center = {
        x = 0.5,
        y = 0.5
    },
    img_size = {
        x = 80,
        y = 500
    },
    scale = 0.93,
    max_movement_per_cycle = 1.5
}, airspeed_gauge)

barberpole_needle:draw()

local airspeed_needle = ImageNeedle:new({
    image = "as_needle.png",
    center = {
        x = 0.5,
        y = 0.5
    },
    img_size = {
        x = 60,
        y = 500
    },
    scale = 0.93,
    max_movement_per_cycle = 1.5
}, airspeed_gauge)

airspeed_needle:draw()

-- IMAGES
-- img_add_fullscreen("background.png")
img_add("cap.png", 230, 230, 40, 40)

-- FUNCTIONS
function new_data_xpl(bus_volts, ias, vno)

    if bus_volts[1] >= 18 then
        airspeed_needle:set_value(ias)
        barberpole_needle:set_value(vno)
    else
        airspeed_needle:set_value(0)
        barberpole_needle:set_value(0)
        gbl_tar_vno = 0
    end

end

function new_data_fsx(bus_volts, ias, vno)

    if bus_volts >= 18 then
        airspeed_needle:set_value(ias)
        barberpole_needle:set_value(vno)
    else
        airspeed_needle:set_value(0)
        barberpole_needle:set_value(0)
    end

end

-- DATA BUS SUBSCRIBE
xpl_dataref_subscribe("sim/cockpit2/electrical/bus_volts", "FLOAT[6]",
    "sim/cockpit2/gauges/indicators/airspeed_kts_pilot", "FLOAT", "sim/aircraft/view/acf_Vno", "FLOAT", new_data_xpl)
fsx_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "VOLTS", "AIRSPEED INDICATED", "KNOTS", "AIRSPEED BARBER POLE",
    "KNOTS", new_data_fsx)
fs2020_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "VOLTS", "AIRSPEED INDICATED", "KNOTS", "AIRSPEED BARBER POLE",
    "KNOTS", new_data_fsx)

-- TIMER
tmr_update = timer_start(0, 50, timer_callback)
