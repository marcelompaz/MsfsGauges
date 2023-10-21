-------------------------------------------
-- Sim Innovations - All rights reserved --
--   Beechcraft C90 Airspeed indicator   --
-------------------------------------------


local airspeed_gauge = Gauge:new({

    size = 500,

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


airspeed_gauge:draw()

X = 60
Y = 500





local barberpole_needle = ImageNeedle:new({
    image = "barberpole.png",
    center = {x=0.5, y=0.5},
    img_size = {x=80, y=500},
    scale = 0.93,
    max_movement_per_cycle = 1.5
}, airspeed_gauge)

barberpole_needle:draw()

local airspeed_needle = ImageNeedle:new({
    image = "as_needle.png",
    center = {x=0.5, y=0.5},
    img_size = {x=60, y=500},
    scale = 0.93,
    max_movement_per_cycle = 1.5
}, airspeed_gauge)


airspeed_needle:draw()

-- IMAGES
-- img_add_fullscreen("background.png")
-- img_vmo_needle = img_add("barberpole.png", 210, 0, 80, 500)
-- img_ias_needle = img_add("as_needle.png", 220, 0, 60, 500)
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
                      "sim/cockpit2/gauges/indicators/airspeed_kts_pilot", "FLOAT", 
                      "sim/aircraft/view/acf_Vno", "FLOAT", new_data_xpl)
fsx_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "VOLTS",
                       "AIRSPEED INDICATED", "KNOTS", 
                       "AIRSPEED BARBER POLE", "KNOTS", new_data_fsx)
fs2020_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "VOLTS",
                          "AIRSPEED INDICATED", "KNOTS", 
                          "AIRSPEED BARBER POLE", "KNOTS", new_data_fsx)                       
                       
-- TIMER
tmr_update = timer_start(0, 50, timer_callback)