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
| mini_tick       | Size of the ticks located between the minor ticks (px). If this value is not set, the minor ticks will have the same size  | No |
| tick_color      | Color of the ticks      | Yes |
| background      | Background collor (behind the gauge)      | Yes |
| gauge_bottom      | Color of the bottom of the gauge (inside the gauge)      | Yes |
| gauge_ratio      | Ratio (from 0 to 1) of the gauge size compared to the instument size  | Yes |
| font      | Font for printing the labels (the TTF file needs to be contained on the resource folder)  | Yes |
| font_color      | Font color  | Yes |
| font      | Font Size  | Yes |
| internal_text      | True if the numbers are shown inside the gauge, false for outside  | Yes |
| ticks_table      | Table for the positioning of the ticks, check below for more details | Yes |
| extra_ticks       | Table for extra ticks (e.g. Vr on a Airspeed gauge), check below for more details | No |
| arcs        | Arcs showing specific ranges of values (e.g flap speed) on the gauge, check below for more details | No |

## ticks_table

This table contains the core of the gauge, with the angles and values to be plotted. It contains one ore more tables where the gauge "ring" with values is defined. 
An example with one table from the Airspeed inidcator:

```lua
ticks_table = {
    {
        initial_angle = 195,
        end_angle = 525,
        num_ticks = 14,
        internal_ticks = 3,
        ticks_labels = {"4", "6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "30"},
        value = 40
    }, --single table for airspeed
    top_of_scale = {300, 525} 
}
```

The first values that needs to be defined are the initial and end angle in degrees where the gauge starts and the gauge ends, considering 0 degrees the top of the gauge. The end angle needs to be greater than the initial angle. This may look obvious, but is most of the gauges, the end angle is located in the first (0deg-90deg) or second quadrant (90deg-180deg), so you need to consider the "full path" that the needle goes from its initial value. For example, for the airspeed, the initial value (40kts) is located at 195 degrees. The final value (300kts) is located at 165 degrees, but you need to consider the path that the needles goes from the initial angle (195) all around the gauge, crossing the top at 360 degrees until it reaches the end (525deg = 360deg + 165deg). 

Then you need to define the num_ticks that its basically the number of major (big) ticks that the gauge contains with a fixed separation between then. If you want to draw smaller ticks between those major ticks, set internal ticks to the number that you want. 

The value is the numerical value corresponding to the "initial_angle". For the Airspeed, as mentioned, is 40 knots. 
The ticks_labels is an array with the same size as "num_ticks" where you defined the labels that will be plotted close to the major ticks. If you want to skip some labels, or not print labels at all, set it to empty strings. 

The top_of_scale, located outside the table, is to close the interpolation table used to calculate the position of the needle based on the value. In most cases, it will be the last value (300 knots) and the end_angle (525 degrees). But sometimes you want that the needle moves a bit more than the end of the gauge. For instance, for Nh-Ng, the top of scale is 100%, but the indication can sometimes exceeds this value, then a different top of scale is defined. And for cases where the gauge can rotate multiple times (like an Altimeter), the top of the scale can be a lot bigger than the end_angle. There is no altimeter done using this lib but the small clock for Nh-Ng (for decimals) is a good example. The needle does a full rotation each 10%, so the top of the scale is defined to 120% and 4320 degrees (12 * 360 degrees). You can read this as, if the Nh or Ng value changes from 0% (decimal will be 0) do 120%, the needle will move 4320 degrees (12 full circles) but in the end the decimal will still be 0. Keep in mind that if you use a top_of_scale different than the end_value of your table, you need to calculate it correctly or the needle position will be wrong. 

For most of the cases where the gauge is completely linear, it will contain only one table. But if the gauge has different scales for different values, it can contain more tables. The EMB-110 T5 gauge is a good example of a case with multiple tables. You can think those tables as separate gauges that are just used when the needle is on the respective range.

## arcs

In this table you define the arcs to show operation ranges, warning ranges, flaps ranges, etc. 
To define it, just define the table as this example:

```lua
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

}},
```
Initial and final are the values where the arc is defined. Those are values, not angles. For Airspeed, 70-148knots is the flaps operating airspeed. 
width is the widht of the arc in pixels and the color is the color. Internal set to false, means that the arcs will be drawn outside of the gauge (as usual for flap indication) and if set to true the arc will be drawn inside the gauge (in this case the operating airspeed range). 

## extra ticks

Extra ticks are custom extra ticks to indicate some special values on the gauge as, for example, the Vr (rotation) and Vne (never exceed) speeds for the EMB-110. Defining them is very straight forward

```lua
extra_ticks = {{
    color = "red",
    size = 16,
    value = 85 --Vr 
}, {
    color = "red",
    size = 16,
    value = 230 --Vne
}},
```

And that's it for gauges. Define this table, call draw() and you will have a gauge. 
# needle.lua

A gauge is useless without a needle. Syntax is similar as for the gauge (but the config table is completely different) and the gauge where the needle is located is also a parameter
You can set multiple needles for the same gauge. 

```lua
local my_needle = Needle:new(my_needle_config, my_gauge)
my_needle:draw()

---set a new value to the needle
my_needle:set_value(new_value)
```

Don't forget to draw the needle after the Gauge and after any extra text added to the gauge. The needle also contain a timer to make the movement smoother. 

The table for the needle looks like this

```lua
{
    circle_ratio = 0.20, --radius of the internal circle in the middle of the gauge needle in relation with the radius of the full gauge
    circle_color = "gray", --collor of the internal circle
    circle_text = "", --optional text to be drawn inside the circule
    size_ratio = 0.70, --ratio of the size of the needle comparing to its tip. Greater this value, less visible the tip of the needle will be. Smaller the value, the needle will looks more like a triangle. 
    needle_color = "#a3a8b0", --color of the needle
    needle_tickness = 10, --tickes of the needle on px
    max_movement_per_cycle = 1.5, --degrees that the needle can move each 50ms. This is for animation purposes to avoid sudden movements of the needle
    needle_label = {"font: Inconsolata.ttf; size: 20; color: black ; halign:center; valign:center",
                    "L"} --optional label to be drawn over the needle. Useful when you have multiple needles in the same gauge (Left/Right fuel for example)
}
```

It draws a straight needle with a triangular edge. 
