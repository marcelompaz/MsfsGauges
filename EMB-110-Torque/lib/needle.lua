local Needle = {}


function Needle:draw_needle()
    circle_r = self.gauge.radius * self.circle_ratio
    needle_size = self.gauge.radius * self.size_ratio

    _move_to(self.gauge.centerX, self.gauge.centerY)
    _line_to(self.gauge.centerX, self.gauge.centerY - needle_size)
    _stroke(needle.needle_color, self.needle_tickness)

    _triangle(self.gauge.centerX - (self.needle_tickness / 2), self.gauge.centerY - needle_size,
    self.gauge.centerX + (self.needle_tickness / 2), self.gauge.centerY - needle_size, self.gauge.centerX,
        self.gauge.centerY - self.gauge.radius + self.gauge.minor_tick)
    _fill(self.needle_color)

    _circle(self.gauge.centerX, self.gauge.centerY, circle_r)
    _fill(self.circle_color)

    if self.needle_label then
        _txt(self.needle_label[2], self.needle_label[1], self.gauge.centerX, self.gauge.centerY - (self.gauge.radius / 2))
    end

end


function Needle:new(needle, gauge)
    needle = needle or {}
    setmetatable(mainGauge, self)
    self.__index = needle
    needle.gauge = gauge

    if gauge.top_x and gauge.top_y then
        needle.canvas = canvas_add(gauge.top_x, gauge.top_y, gauge.size, gauge.size)
    else
        needle.canvas = canvas_add(0, 0, gauge.size, gauge.size)
    end

    needle.current_needle_value = 0
    needle.current_value = 0

    canvas_draw(needle.canvas, function()
        draw_needle()
    end)

    -- tmr_update = timer_start(0, 50, function()


    --         current_needle = needle.current_needle_value
    --         current_value = needle.current_value
    
    --         if needle.max_needle_movement >= 0 then
    
    --             if (math.abs(current_value - current_needle) > needle.max_needle_movement) then
    --                 if current_value > current_needle then
    --                     current_needle = current_needle + needle.max_needle_movement
    --                 else
    --                     current_needle = current_needle - needle.max_needle_movement
    --                 end
    --             else
    --                 current_needle = current_value
    --             end
    
    --             needle.current_needle_value = current_needle
    --             needle.current_value = current_value
    
    --             rotate(needle.needle_canvas, current_needle)
    --         else
    --             rotate(needle.needle_canvas, current_value)
    --         end
    --     end
    
    -- end)

    return needle
end



function Needle:set_needle_value(value)
    self.current_value = self.gauge.get_angle(value, cfg)
    rotate(self.needle.needle_canvas, current_value)

end

