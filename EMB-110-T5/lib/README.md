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
| minor_tick      | Size of minor tick (px)      | No |




# needle.lua

A gauge is useless without a needle. Syntax is similar as for the gauge (but the config table is completely different) and the gauge where the needle is located is also a parameter

```lua
local my_needle = Needle:new(my_needle_config, my_gauge)
my_needle:draw()

---set a new value to the needle
my_needle:set_value(new_value)
```

Don't forget to draw the needle after the Gauge and after any extra text added to the gauge. The needle also contain a timer to make the movement smoother. 
