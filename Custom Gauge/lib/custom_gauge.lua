L = 400
W = L
R = (L / 2) * 0.95
Cx = L / 2
Cy = W / 2

MAJOR_TICK = 16
MINOR_TICK = 8

TICK_COLOR = "white"
BACKGROUND = "gray"
GAUGE_BOTTOM = "black"

INITIAL_ANGLE = 120
END_ANGLE = 400
NUM_TICKS = 23
INTERNAL_TICKS = 3




TICK_LABELS = {"0", "20", "40", "60", "80", "100", "120", "140", "160", "180", "200"}

FONT = "Inconsolata.ttf"
FONT_COLOR = "white"
FONT_SIZE = 25
INTERNAL_TEXT = true

FONT = "font:" .. FONT .. "; size:" .. FONT_SIZE .. "; color: " .. FONT_COLOR .. "; halign:center; valign:center"

img_needle = nil

VALUES = {
    min = 0,
    max = 2200
}

local settings = { { VALUES.min , INITIAL_ANGLE},
                   { VALUES.max, END_ANGLE },
}




ARCS = {{
    color = "red",
    initial = 150,
    final = 180,
    width = 10,
    internal = true
}, {
    color = "yellow",
    initial = 120,
    final = 150,
    width = 10,
    internal = true
}, {
    color = "green",
    initial = 60,
    final = 120,
    width = 10,
    internal = true
}, {
    color = "white",
    initial = 40,
    final = 80,
    width = 5,
    internal = false
}}

NEEDLE = {
    circle_ratio = 0.15,
    circle_color = "gray",
    circle_text = "",
    size_ratio = 0.85,
    needle_color = "white",
    needle_text = "",
    needle_tickness = 12,
}

function get_angle(value)
    return interpolate_linear(settings, value, true)
end

function draw_arc(arc)
    initial = get_angle(arc.initial)
    final = get_angle(arc.final)
    if arc.internal then
        _arc(Cx, Cy, initial - 90, final - 90, R - arc.width / 2)
    else
        _arc(Cx, Cy, initial - 90, final - 90, R + arc.width / 2)
    end
    _stroke(arc.color, arc.width)
end

function draw_tick_text(angle, label, tick_size)
    if INTERNAL_TEXT then
        offset = (tick_size * 1.2) + FONT_SIZE / 2
    else
        offset = -FONT_SIZE / 1.5
    end
    if label ~= nil then
        begin_x, begin_y = geo_rotate_coordinates(angle, R - offset)
        _txt(label, FONT, begin_x + Cx, begin_y + Cy)
    end
end

function draw_line(x1, y1, x2, y2)
    _move_to(x1, y1)
    _line_to(x2, y2)
    _stroke(TICK_COLOR, 3)
end

function draw_tick(degrees, tick_size)
    arc_angle = degrees - 90
    _arc(Cx, Cy, arc_angle-0.5, arc_angle+0.5, R - tick_size / 2) 
    _stroke(TICK_COLOR, tick_size)  
end

function draw_needle(needle)
    circle_r = R * needle.circle_ratio
    needle_size = R * needle.size_ratio 
    
    _move_to(Cx, Cy)
    _line_to(Cx, Cy-needle_size)
    _stroke(needle.needle_color, needle.needle_tickness)

    _triangle(Cx-(needle.needle_tickness/2), Cy-needle_size, Cx+(needle.needle_tickness/2), Cy-needle_size, Cx, Cx - R + MINOR_TICK)
    _fill(needle.needle_color)

    _circle(Cx, Cy, circle_r)
    _fill(needle.circle_color)
end


function draw_gauge()
    canvas_id = canvas_add(0, 0, L, W)

    canvas_draw(canvas_id, function()
        -- Queue a line from 100,100 to 200,200
        _rect(0, 0, L, W)
        _fill(BACKGROUND)
        _circle(Cx, Cy, R)
        _fill(GAUGE_BOTTOM)

        for _, arc in pairs(ARCS) do
            draw_arc(arc)
        end

        div = (END_ANGLE - INITIAL_ANGLE) / (NUM_TICKS - 1)


       -- 
        for i = 1, NUM_TICKS do
            local angle = INITIAL_ANGLE + (i-1)*div
            draw_tick(angle, MAJOR_TICK)
            draw_tick_text(angle, TICK_LABELS[i], MAJOR_TICK)

            internal_div = (div / (INTERNAL_TICKS + 1))
            if i < NUM_TICKS then
                for j = 1, INTERNAL_TICKS do
                    local internal_angle = angle + internal_div + (j-1)*internal_div
                    draw_tick(internal_angle, MINOR_TICK)
                end
            end
        end

    end)

    needle = canvas_add(0, 0, L, W)
    aaa = canvas_draw(needle, function()
        
        draw_needle(NEEDLE)
        
    end)
end

CURRENT_VALUE = 0
CURRENT_NEEDLE_VALUE = 0
MAX_NEEDLE_MOVEMENT = math.abs((VALUES.min - VALUES.max) * 0.10)

function set_value(value)
    CURRENT_VALUE = value
end

tmr_update = timer_start(0, 50, function()

    if (math.abs(CURRENT_VALUE - CURRENT_NEEDLE_VALUE) > MAX_NEEDLE_MOVEMENT) then
        if CURRENT_VALUE > CURRENT_NEEDLE_VALUE then
            CURRENT_NEEDLE_VALUE = CURRENT_NEEDLE_VALUE + MAX_NEEDLE_MOVEMENT
        else
            CURRENT_NEEDLE_VALUE = CURRENT_NEEDLE_VALUE - MAX_NEEDLE_MOVEMENT
        end
    else
        CURRENT_NEEDLE_VALUE = CURRENT_VALUE
    end

    rotate(needle, get_angle(CURRENT_NEEDLE_VALUE))
end)
