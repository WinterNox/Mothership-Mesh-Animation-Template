local super_mothership = {}

local sides = 3  -- Remember to change the variable sides in ./graphics.lua as well!
local total_frames = 20 * (sides + 1)

function super_mothership.new(x, y)
  local entity_id = pewpew.new_customizable_entity(x, y)

  pewpew.customizable_entity_set_mesh_color(entity_id, 0xff2986ff)

  local frame = 0
  pewpew.entity_set_update_callback(entity_id, function()
    frame = frame + 2

    pewpew.customizable_entity_set_flipping_meshes(entity_id, "/dynamic/Super Mothership/graphics.lua", frame % total_frames, (frame + 1) % total_frames)
  end)

  return entity_id
end

return super_mothership