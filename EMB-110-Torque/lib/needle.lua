Needle = {}

function Needle:set_timer()
    tmr_update = timer_start(0, 50, function()
        is_incremental = self.gauge.is_incremental

        expected_angle = self.gauge:get_angle(self.current_value)

        angle_diff = math.abs(expected_angle - self.current_angle)
        direction = (expected_angle > self.current_angle) and 1 or -1
        corrected_direction = direction * (is_incremental and 1 or -1)

        if angle_diff < self.max_movement_per_cycle then
            self.current_angle = expected_angle
        else
            self.current_angle = (self.current_angle + (self.max_movement_per_cycle * corrected_direction))
        end
        rotate(self.canvas, self.current_angle)

    end)

end

function Needle:draw()
    canvas_draw(self.canvas, function()
        circle_r = self.gauge.radius * self.circle_ratio
        needle_size = self.gauge.radius * self.size_ratio

        _move_to(self.gauge.centerX, self.gauge.centerY)
        _line_to(self.gauge.centerX, self.gauge.centerY - needle_size)
        _stroke(self.needle_color, self.needle_tickness)

        _triangle(self.gauge.centerX - (self.needle_tickness / 2), self.gauge.centerY - needle_size,
            self.gauge.centerX + (self.needle_tickness / 2), self.gauge.centerY - needle_size, self.gauge.centerX,
            self.gauge.centerY - self.gauge.radius + self.gauge.minor_tick)
        _fill(self.needle_color)

        _circle(self.gauge.centerX, self.gauge.centerY, circle_r)
        _fill(self.circle_color)

        if self.needle_label then
            _txt(self.needle_label[2], self.needle_label[1], self.gauge.centerX,
                self.gauge.centerY - (self.gauge.radius / 2))
        end
    end)

    rotate(self.canvas, self.current_angle)
    self:set_timer()
end

function Needle:new(needle, gauge)
    local o = needle or {}
    setmetatable(o, {
        __index = self
    })
    if gauge then
        o.gauge = gauge

        if gauge.top_x and gauge.top_y then
            o.canvas = canvas_add(gauge.top_x, gauge.top_y, gauge.size, gauge.size)
        else
            o.canvas = canvas_add(0, 0, gauge.size, gauge.size)
        end

        o.current_value = gauge:get_initial_value()
        o.current_angle = gauge:get_initial_angle()
    end

    return o
end

function Needle:set_value(value)
    self.current_value = value
end

ImageNeedle = Needle:new()

function ImageNeedle:draw()
    canvas_draw(self.canvas, function()
        _circle(self.gauge.centerX, self.gauge.centerY, self.gauge.radius)

        img_size = {x = self.img_size.x * self.scale, y = self.img_size.y * self.scale}

        dx = img_size.x * self.center.x
        dy = img_size.y * self.center.y 




        _fill_img(self.image, self.gauge.centerX - dx, self.gauge.centerY - dy, img_size.x, img_size.y)

        
    end)

    rotate(self.canvas, self.current_angle)
    self:set_timer()
end

