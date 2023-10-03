local Gauge = {}

function Gauge:new(mainGauge)
    mainGauge = mainGauge or {}
    setmetatable(mainGauge, self)
    self.__index = self

    self.radius = (self.size / 2) * self.gauge_ratio
    self.centerX = self.size / 2
    self.centerY = self

    if self.top_x and self.top_y then
        self.canvas_id = canvas_add(self.top_x, self.top_y, self.size, self.size)
    else
        self.canvas_id = canvas_add(0, 0, self.size, self.size)
    end

    return mainGauge
end

function Gauge:get_angle(value)
    return interpolate_linear(self.interpolate_table, value, true)
end


function Gauge:draw_arc(arc)
    initial = self.get_angle(arc.initial)
    final = self.get_angle(arc.final)
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

function Gauge:draw_tick(degrees, tick_size)
    arc_angle = degrees - 90
    _arc(self.centerX, self.centerY, arc_angle - 0.5, arc_angle + 0.5, self.radius - tick_size / 2)
    _stroke(self.tick_color, tick_size)
end

function Gauge:draw_ticks_sequence(initial_angle, end_angle, num_ticks, tick_labels, internal_ticks)
    div = (end_angle - initial_angle) / (num_ticks - 1)
    -- 
    for i = 1, num_ticks do
        local angle = initial_angle + (i - 1) * div
        self.draw_tick(angle, self.major_tick)
        self.draw_tick_text(angle, tick_labels[i], self.major_tick)

        internal_div = (div / (internal_ticks + 1))
        if i < num_ticks then
            for j = 1, internal_ticks do
                local internal_angle = angle + internal_div + (j - 1) * internal_div
                self.draw_tick(internal_angle, self.minor_tick)
            end
        end
    end

end

function Gauge:draw_arcs()
    if self.arcs then
        for _, arc in pairs(self.arcs) do
            self.draw_arc(arc)
        end
    end
end

function Gauge:create_interpolate_table()
    if self.ticks_table then
        interpolate_table = {}
        if self.ticks_table.bottom_of_scale then
            table.insert(interpolate_table, self.ticks_table.bottom_of_scale)
        end

        for _, ticks in ipairs(self.ticks_table) do
            table.insert(interpolate_table, {ticks.value, ticks.initial_angle})
        end
        if self.ticks_table.top_of_scale then
            table.insert(interpolate_table, self.ticks_table.top_of_scale)
        end

        self.interpolate_table = interpolate_table
    end
end

function Gauge:draw_tics()
    if self.ticks_table then
        for _, ticks in ipairs(self.ticks_table) do
            draw_ticks_sequence(ticks.initial_angle, ticks.end_angle, ticks.num_ticks, ticks.ticks_labels,
                ticks.internal_ticks, self)
        end
    else
        draw_ticks_sequence(self.initial_angle, self.end_angle, self.num_ticks, self.tick_labels, self.internal_ticks,
            self)

    end
end

function Gauge:draw()
    canvas_draw(canvas_id, function()

        if self.background then
            _rect(0, 0, self.size, self.size)
            _fill(self.background)
        end
        _circle(self.centerX, self.centerY, self.radius)
        _fill(self.gauge_bottom)

        self.draw_arcs()
        self.create_interpolate_table()
        self.draw_tics()

    end)

end