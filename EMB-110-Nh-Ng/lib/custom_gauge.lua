function get_angle(value, cfg)
    return interpolate_linear(cfg.interpolate_table, value, true)
end

function draw_arc(arc, cfg)
    initial = get_angle(arc.initial, cfg)
    final = get_angle(arc.final, cfg)
    if arc.internal then
        _arc(cfg.centerX, cfg.centerY, initial - 90, final - 90, cfg.radius - arc.width / 2)
    else
        _arc(cfg.centerX, cfg.centerY, initial - 90, final - 90, cfg.radius + arc.width / 2)
    end
    _stroke(arc.color, arc.width)
end

function draw_tick_text(angle, label, tick_size, cfg)
    if cfg.internal_text then
        offset = (tick_size * 1.2) + cfg.font_size / 2
    else
        offset = -cfg.font_size / 1.5
    end
    if label ~= nil then
        begin_x, begin_y = geo_rotate_coordinates(angle, cfg.radius - offset)
        font = "font:" .. cfg.font .. "; size:" .. cfg.font_size .. "; color: " .. cfg.font_color ..
                   "; halign:center; valign:center"
        _txt(label, font, begin_x + cfg.centerX, begin_y + cfg.centerY)
    end
end

function draw_tick(degrees, tick_size, cfg)
    arc_angle = degrees - 90
    _arc(cfg.centerX, cfg.centerY, arc_angle - 0.5, arc_angle + 0.5, cfg.radius - tick_size / 2)
    _stroke(cfg.tick_color, tick_size)
end

function draw_needle(needle, cfg)
    circle_r = cfg.radius * needle.circle_ratio
    needle_size = cfg.radius * needle.size_ratio

    _move_to(cfg.centerX, cfg.centerY)
    _line_to(cfg.centerX, cfg.centerY - needle_size)
    _stroke(needle.needle_color, needle.needle_tickness)

    _triangle(cfg.centerX - (needle.needle_tickness / 2), cfg.centerY - needle_size,
        cfg.centerX + (needle.needle_tickness / 2), cfg.centerY - needle_size, cfg.centerX,
        cfg.centerY - cfg.radius + cfg.minor_tick)
    _fill(needle.needle_color)

    _circle(cfg.centerX, cfg.centerY, circle_r)
    _fill(needle.circle_color)

    if needle.needle_label then
        _txt(needle.needle_label[2], needle.needle_label[1], cfg.centerX, cfg.centerY - (cfg.radius / 2))
    end

end

function draw_ticks_sequence(initial_angle, end_angle, num_ticks, tick_labels, internal_ticks, cfg)
    div = (end_angle - initial_angle) / (num_ticks - 1)
    -- 
    for i = 1, num_ticks do
        local angle = initial_angle + (i - 1) * div
        draw_tick(angle, cfg.major_tick, cfg)
        draw_tick_text(angle, tick_labels[i], cfg.major_tick, cfg)

        internal_div = (div / (internal_ticks + 1))
        if i < num_ticks then
            for j = 1, internal_ticks do
                local internal_angle = angle + internal_div + (j - 1) * internal_div
                draw_tick(internal_angle, cfg.minor_tick, cfg)
            end
        end
    end

end

function draw_gauge(cfg)

    cfg.radius = (cfg.size / 2) * cfg.gauge_ratio
    cfg.centerX = cfg.size / 2
    cfg.centerY = cfg.size / 2

    if cfg.top_x and cfg.top_y then
        canvas_id = canvas_add(cfg.top_x, cfg.top_y, cfg.size, cfg.size)
    else
        canvas_id = canvas_add(0, 0, cfg.size, cfg.size)
    end

    canvas_draw(canvas_id, function()

        if cfg.background then
            _rect(0, 0, cfg.size, cfg.size)
            _fill(cfg.background)
        end
        _circle(cfg.centerX, cfg.centerY, cfg.radius)
        _fill(cfg.gauge_bottom)

        if cfg.ticks_table then
            interpolate_table = {}
            if cfg.ticks_table.bottom_of_scale then
                table.insert(interpolate_table, cfg.ticks_table.bottom_of_scale)
            end

            for _, ticks in ipairs(cfg.ticks_table) do
                table.insert(interpolate_table, {ticks.value, ticks.initial_angle})
            end
            if cfg.ticks_table.top_of_scale then
                table.insert(interpolate_table, cfg.ticks_table.top_of_scale)
            end

            cfg.interpolate_table = interpolate_table
        end

        if cfg.arcs then
            for _, arc in pairs(cfg.arcs) do
                draw_arc(arc, cfg)
            end
        end
        if cfg.ticks_table then
            for _, ticks in ipairs(cfg.ticks_table) do
                draw_ticks_sequence(ticks.initial_angle, ticks.end_angle, ticks.num_ticks, ticks.ticks_labels,
                    ticks.internal_ticks, cfg)
            end
        else
            draw_ticks_sequence(cfg.initial_angle, cfg.end_angle, cfg.num_ticks, cfg.tick_labels, cfg.internal_ticks,
                cfg)

        end

    end)

    return cfg

end

local LAST_HANDLE = 1
local NEEDLE_VALUES = {}

function add_needle(cfg, needle_cfg)

    if cfg.top_x and cfg.top_y then
        needle = canvas_add(cfg.top_x, cfg.top_y, cfg.size, cfg.size)
    else
        needle = canvas_add(0, 0, cfg.size, cfg.size)
    end

    aaa = canvas_draw(needle, function()

        draw_needle(needle_cfg, cfg)

    end)
    needle_cfg.handle = LAST_HANDLE

    table.insert(NEEDLE_VALUES, {
        -- current_value = get_angle(cfg.interpolate_table[1][1], cfg),
        -- current_needle_value = get_angle(cfg.interpolate_table[1][1], cfg),
        current_value = 0,
        current_needle_value = 0,
        needle_canvas = needle,
        cfg = cfg,
        max_needle_movement = needle_cfg.max_movement_per_cycle
    })
    LAST_HANDLE = LAST_HANDLE + 1
    return needle_cfg
end

function set_needle_value(needle_cfg, cfg, value)
    NEEDLE_VALUES[needle_cfg.handle].current_value = get_angle(value, cfg)
end

tmr_update = timer_start(0, 50, function()

    for _, needle in ipairs(NEEDLE_VALUES) do
        current_needle = needle.current_needle_value
        current_value = needle.current_value

        if needle.max_needle_movement >= 0 then

            if (math.abs(current_value - current_needle) > needle.max_needle_movement) then
                if current_value > current_needle then
                    current_needle = current_needle + needle.max_needle_movement
                else
                    current_needle = current_needle - needle.max_needle_movement
                end
            else
                current_needle = current_value
            end

            needle.current_needle_value = current_needle
            needle.current_value = current_value

            rotate(needle.needle_canvas, current_needle)
        else
            rotate(needle.needle_canvas, current_value)
        end
    end

end)
