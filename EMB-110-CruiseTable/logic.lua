local g_alt_feet = 0
local g_weight_kg = 0
local g_temperature = 0

canvas_add(0, 0, 200, 300, function()
    _rect(0, 0, 200, 300)
    _fill("#505761")
end)


txt_add("TORQUE:", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 0, 0,
    200, 60)

torque_txt = txt_add("0", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 100, 0,
    200, 60)

txt_add("CURR:", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 0, 30,
    200, 60)

current_torque_txt = txt_add("0", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 100,
    30,
    200, 60)


txt_add("KIAS:", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 0, 60,
    200, 60)


kias_txt = txt_add("1", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 100, 60,
    200, 60)

txt_add("CURR:", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 0, 90,
    200, 60)


curr_kias_txt = txt_add("1", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 100, 90,
    200, 60)


txt_add("CONS:", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 0, 120,
    200, 60)

cons_txt = txt_add("2", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 100, 120,
    200, 60)

txt_add("CURR:", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 0, 150,
    200, 60)

curr_cons_txt = txt_add("2", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 100, 150,
    200, 60)



txt_add("WEIGHT:", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 0, 180,
    200, 60)

weight_txt = txt_add("3", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 100, 180,
    200, 60)

txt_add("RATIO:", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 0, 210,
    200, 60)

ratio_txt = txt_add("3", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 100, 210,
    200, 60)    


txt_add("P_ALT:", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 0, 240,
    200, 60)

palt_txt = txt_add("4", "font:Inconsolata-Bold.ttf; size:25; color: white; halign:left; valign:center;", 100, 240,
    200, 60)


timer_start(0, 3000, function()
    local val = get_optimal_cruise(g_alt_feet, g_temperature, g_weight_kg)
    if val then
        txt_set(torque_txt, math.floor(val[2] + 0.5))
        txt_set(kias_txt, math.floor(val[1] + 0.5))
        txt_set(cons_txt, math.floor(val[3] + 0.5))
    else
        txt_set(torque_txt, "N/A")
        txt_set(kias_txt, "N/A")
        txt_set(cons_txt, "N/A")
    end
end)

fs2020_variable_subscribe("PRESSURE ALTITUDE", "Meters", "TOTAL WEIGHT", "Pounds", "AMBIENT TEMPERATURE", "CELSIUS",
    function(pressure_alt, weight, temperature)
        g_alt_feet = pressure_alt * 3.28084
        g_weight_kg = weight * 0.453592
        g_temperature = temperature

        txt_set(weight_txt, math.floor(g_weight_kg + .5))
        txt_set(palt_txt, math.floor(g_alt_feet + .5))
    end)

fs2020_variable_subscribe("ENG TORQUE:1",
    "Foot pounds", "AIRSPEED INDICATED", "knots", "TURB ENG FUEL FLOW PPH:1", "Pounds per hour", "AIRSPEED TRUE", "Knots",
    function(torque, ias, cons, tas)
        txt_set(curr_cons_txt, math.floor(cons + .5))
        txt_set(curr_kias_txt, math.floor(ias + .5))
        txt_set(current_torque_txt, math.floor(torque + .5))

        if tas > 0 and cons > 0 then
            ratio = tas / cons
            txt_set(ratio_txt,  var_round(ratio, 3))
        end
    
    end)
