Gauge = {}

function Gauge:new(mainGauge)
    local o = mainGauge
    setmetatable(o, {
        __index = self
    })

    o.radius = (mainGauge.size / 2) * mainGauge.gauge_ratio
    o.centerX = mainGauge.size / 2
    o.centerY = mainGauge.size / 2

    if mainGauge.top_x and mainGauge.top_y then
        o.canvas_id = canvas_add(mainGauge.top_x, mainGauge.top_y, mainGauge.size, mainGauge.size)
    else
        o.canvas_id = canvas_add(0, 0, mainGauge.size, mainGauge.size)
    end

    if mainGauge.ticks_table then
        interpolate_table = {}
        if mainGauge.ticks_table.bottom_of_scale then
            table.insert(interpolate_table, mainGauge.ticks_table.bottom_of_scale)
        end

        for _, ticks in ipairs(mainGauge.ticks_table) do

            table.insert(interpolate_table, {ticks.value, ticks.initial_angle})
        end
        if mainGauge.ticks_table.top_of_scale then
            table.insert(interpolate_table, mainGauge.ticks_table.top_of_scale)
        end

        o.interpolate_table = interpolate_table
    end

    o.swap_interpolate_table = {}

    for i = 1, #o.interpolate_table do
        local invertedEntry = {o.interpolate_table[i][2], o.interpolate_table[i][1]}
        table.insert(o.swap_interpolate_table, invertedEntry)
    end

    local first = o.interpolate_table[1][1]
    local last = o.interpolate_table[#o.interpolate_table][1]
    self.is_incremental = first < last

    return o
end

function Gauge:get_angle(value)
    return interpolate_linear(self.interpolate_table, value, true)
end

function Gauge:get_initial_value()
    return self.interpolate_table[1][1]
end

function Gauge:get_initial_angle()
    return self.swap_interpolate_table[1][1]
end

function Gauge:get_value(angle)
    return interpolate_linear(self.swap_interpolate_table, angle, true)
end

function Gauge:is_incremental()

end

function Gauge:draw_arc(arc)
    initial = self:get_angle(arc.initial)
    final = self:get_angle(arc.final)
    if arc.internal then
        _arc(self.centerX, self.centerY, initial - 90, final - 90, self.radius - arc.width / 2)
    else
        _arc(self.centerX, self.centerY, initial - 90, final - 90, self.radius + arc.width / 2)
    end
    _stroke(arc.color, arc.width)
end

function Gauge:draw_tick_text(angle, label, tick_size)
    if self.internal_text then
        offset = (tick_size * 1.2) + self.font_size / 2
    else
        offset = -self.font_size / 1.5
    end
    if label ~= nil then
        begin_x, begin_y = geo_rotate_coordinates(angle, self.radius - offset)
        font = "font:" .. self.font .. "; size:" .. self.font_size .. "; color: " .. self.font_color ..
                   "; halign:center; valign:center"
        _txt(label, font, begin_x + self.centerX, begin_y + self.centerY)
    end
end

function Gauge:draw_tick(degrees, tick_size, tick_color)
    if not tick_color then
        tick_color = self.tick_color
    end
    arc_angle = degrees - 90
    _arc(self.centerX, self.centerY, arc_angle - 0.5, arc_angle + 0.5, self.radius - tick_size / 2)
    _stroke(tick_color, tick_size)
end

function Gauge:draw_ticks_sequence(initial_angle, end_angle, num_ticks, tick_labels, internal_ticks)
    div = (end_angle - initial_angle) / (num_ticks - 1)
    -- 
    for i = 1, num_ticks do
        local angle = initial_angle + (i - 1) * div
        self:draw_tick(angle, self.major_tick)
        self:draw_tick_text(angle, tick_labels[i], self.major_tick)

        internal_div = (div / (internal_ticks + 1))
        if i < num_ticks then
            for j = 1, internal_ticks do
                local internal_angle = angle + internal_div + (j - 1) * internal_div
                if self.mini_tick then
                    if j % 2 == 1 then
                        self:draw_tick(internal_angle, self.mini_tick)
                    else
                        self:draw_tick(internal_angle, self.minor_tick)    
                    end
                else
                    self:draw_tick(internal_angle, self.minor_tick)
                end
            end
        end
    end

end

function Gauge:draw_arcs()
    if self.arcs then
        for _, arc in pairs(self.arcs) do
            self:draw_arc(arc)
        end
    end
end

function Gauge:draw_extra_ticks()
    if self.extra_ticks then
        for _, tick in pairs(self.extra_ticks) do
            angle = self:get_angle(tick.value)
            self:draw_tick(angle, tick.size, tick.color)
        end
    end
end

function Gauge:draw_tics()
    if self.ticks_table then
        for _, ticks in ipairs(self.ticks_table) do
            self:draw_ticks_sequence(ticks.initial_angle, ticks.end_angle, ticks.num_ticks, ticks.ticks_labels,
                ticks.internal_ticks)
        end
    else
        self:draw_ticks_sequence(self.initial_angle, self.end_angle, self.num_ticks, self.tick_labels,
            self.internal_ticks, self)

    end
end

function Gauge:draw()
    canvas_draw(self.canvas_id, function()

        if self.background then
            _rect(0, 0, self.size, self.size)
            _fill(self.background)
        end
        _circle(self.centerX, self.centerY, self.radius)
        _fill(self.gauge_bottom)

        self:draw_arcs()
        self:draw_tics()
        self:draw_extra_ticks()

    end)

end
