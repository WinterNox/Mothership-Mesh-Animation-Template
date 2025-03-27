local entity_id = pewpew.new_customizable_entity(0fx, 0fx)

local sides = 3  -- Remember to change this variable everytime you change the corresponding variable in graphics.lua!
local total_frames = 20 * (sides + 1)

local frame = 0

pewpew.customizable_entity_set_mesh_color(entity_id, 0xff2986ff)

-- Update callback for 60 FPS animation
pewpew.entity_set_update_callback(entity_id, function()
  frame = frame + 2

  pewpew.customizable_entity_set_flipping_meshes(entity_id, "/dynamic/graphics.lua", frame % total_frames, (frame + 1) % total_frames)
end)