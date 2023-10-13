# Custom Gauges ans Needles

This library can be used for generating guages without using graphical tools just by setting a table of inputs with the various parameters of the gauges and needles. All EMB-110 gauges are using this library. To use, just copy/link the contents of this folder to the lib folder of the instrument. 

# gauge.lua

To draw a gauge, the syntax is:

```lua
local my_gauge = Gauge:new(my_gauge_config)
my_gauge:draw()
```

The config table is a LUA table containing elements for each parameter from the gauge. Here is a description of each element. For more info, check one of the gauges. RPM (multiple gauges on a single instrument), T5 (non-linear gauges), Fuel/Oil (multiple needles) are good complex examples that can be used as en example. Text labels are added manually. 

| Member      | Description | Mandatory | 
| ----------- | ----------- | --------- |
| size      | Size of the gauge (px)       | Yes |
| major_tick      | Size of major tick (px)      | Yes |
| minor_tick      | Size of the ticks located between the major ticks (px)      | No |
| mini_tick      | Size of the ticks located between the minor ticks (px)      | No |
| mini_tick      | Size of the ticks located between the minor ticks (px)      | No |
| tick_color      | Color of the ticks      | Yes |
| background      | Background collor (behind the gauge)      | Yes |
| gauge_bottom      | Color of the bottom of the gauge (inside the gauge)      | Yes |
| gauge_ratio      | Ratio (from 0 to 1) of the gauge size compared to the instument size  | Yes |
| font      | Font for printing the labels (the TTF file needs to be contained on the resource folder)  | Yes |
| font_color      | Font color  | Yes |
| font      | Font Size  | Yes |
| internal_text      | True if the numbers are shown inside the gauge, false for outside  | Yes |
| ticks_table      | Table for the positioning of the ticks, check below for more details | Yes |
| extra_ticks       | Table for extra ticks (e.g. Vr on a Airspeed gauge), check below for more details | Yes |
| arcs        | Arcs showing specific ranges of values (e.g flap speed) on the gauge, check below for more details | Yes |






# needle.lua

A gauge is useless without a needle. Syntax is similar as for the gauge (but the config table is completely different) and the gauge where the needle is located is also a parameter

```lua
local my_needle = Needle:new(my_needle_config, my_gauge)
my_needle:draw()

---set a new value to the needle
my_needle:set_value(new_value)
```

Don't forget to draw the needle after the Gauge and after any extra text added to the gauge. The needle also contain a timer to make the movement smoother. 
