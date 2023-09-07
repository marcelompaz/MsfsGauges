prop_sync_on = switch_add("prop_sync_off.png", "prop_sync_on.png", 0, 0, 377, 156, callback)
prop_sync_btn = switch_add("prop_btn_off.png", "prop_btn_on.png", 377, 0, 130, 156, function(position, direction)
    fs2020_event("TOGGLE_PROPELLER_SYNC")

end)

fs2020_variable_subscribe("PROP SYNC ACTIVE:1", "BOOL", function(val)
    switch_set_position(prop_sync_on, val)
    switch_set_position(prop_sync_btn, val)
end)