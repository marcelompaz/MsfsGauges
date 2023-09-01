
MAJOR_TICK = 16
MINOR_TICK = 8

TICK_COLOR = "white"
BACKGROUND = "gray"
GAUGE_BOTTOM = "black"

INITIAL_ANGLE = 120
END_ANGLE = 400
NUM_TICKS = 23
INTERNAL_TICKS = 3

VALUES = {
    min = 0,
    max = 2200
}


ARCS = {{
    color = "green",
    initial = 400,
    final = 1970,
    width = 10,
    internal = true
},{
    color = "red",
    initial = 1970,
    final = 2000,
    width = 10,
    internal = true
}}

TICK_LABELS = {"0", "","2", "","4", "","6", "","8", "","10", "","12", "","14", "","16", "","18", "","20", "","22"}

draw_gauge()

torque_txt = txt_add("TORQUE", "font:Inconsolata-Bold.ttf; size:40; color: white; halign:center; valign:center;", 140, 50, 120, 120)
lbfr_txt = txt_add("LB.FT. x 100", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:center; valign:center;", 110, 225, 200, 120)

function new_data_fsx(bus_volts, trq)
    set_value(trq)
 end

fs2020_variable_subscribe("ELECTRICAL MAIN BUS VOLTAGE", "VOLTS",
                          "ENG TORQUE:1", "Foot pounds", new_data_fsx)



