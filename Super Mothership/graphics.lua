local color_helpers = require("/dynamic/color_helpers.lua")

meshes = {}

local radius = 84
local sides = 3
local total_frames = 20 * (sides + 1)

for frame = 0, total_frames - 1 do
  local c_vertexes, c_colors, c_segments = {}, {}, {}

  table.insert(c_vertexes, {0, 0, -radius})  -- The vertex from which the central lines originate
  table.insert(c_colors, 0x00000000)  -- This vertex itself will be transparent (black)

  local vertex_index = 1

  local inner_segment = {}
  local outer_segment = {}

  local inner_segment_angle = math.tau * (frame / total_frames)  -- A complete rotation counter-clockwise
  local outer_segment_angle = -inner_segment_angle  -- A complete rotation clockwise

  -- The visual difference between the inner segment's angle and the outer segment's angle
  local difference_in_angles = math.abs((inner_segment_angle - outer_segment_angle + math.pi) % math.tau - math.pi)
  local t = difference_in_angles / math.pi

  local inner_segment_opacity = (192 * (1 - t) ^ 2) // 1
  local inner_segment_color = color_helpers.make_color(255, 255, 255, inner_segment_opacity)

  local triangles_width = 16 * math.cos(inner_segment_angle * 2)

  if math.abs(triangles_width) < 2 then
    triangles_width = 2
  end

  for i = 0, sides - 1 do
    local angle_offset = math.tau * (i / sides)

    -- Inner segment
    local y1, x1 = math.sincos(inner_segment_angle + angle_offset)
    table.insert(c_vertexes, {x1 * radius / 2, y1 * radius / 2, radius * 6/7})

    table.insert(inner_segment, vertex_index)

    table.insert(c_colors, inner_segment_color)

    -- Outer segment
    local y2, x2 = math.sincos(outer_segment_angle + angle_offset)
    table.insert(c_vertexes, {x2 * radius, y2 * radius})

    table.insert(outer_segment, vertex_index + 1)

    table.insert(c_colors, 0xffffffff)

    -- Line going from a vertex in the inner segment to the corresponding vertex of the outer segment
    table.insert(c_segments, {vertex_index, vertex_index + 1})

    -- Central lines
    local y3, x3 = math.sincos(outer_segment_angle * 2 + angle_offset)
    table.insert(c_vertexes, {x3 * radius / 6, y3 * radius / 6})

    table.insert(c_segments, {0, vertex_index + 2})

    table.insert(c_colors, 0xffffffff)

    -- Triangles
    local triangle_angle = (outer_segment_angle + angle_offset) + math.pi / sides

    local y4, x4 = math.sincos(triangle_angle)
    local dy, dx = math.sincos(triangle_angle + math.pi / 2)
    table.insert(c_vertexes, {x4 * (radius + 2) - dx * triangles_width, y4 * (radius + 2) - dy * triangles_width})
    table.insert(c_vertexes, {x4 * (radius + 16), y4 * (radius + 16)})
    table.insert(c_vertexes, {x4 * (radius + 2) + dx * triangles_width, y4 * (radius + 2) + dy * triangles_width})

    table.insert(c_segments, {vertex_index + 3, vertex_index + 4, vertex_index + 5, vertex_index + 3})

    table.insert(c_colors, 0xffffffff)
    table.insert(c_colors, 0xffffffff)
    table.insert(c_colors, 0xffffffff)

    vertex_index = vertex_index + 6
  end

  -- Add the starting vertexes of the segments to complete the polygons
  table.insert(inner_segment, 1)
  table.insert(outer_segment, 2)

  table.insert(c_segments, inner_segment)
  table.insert(c_segments, outer_segment)

  -- Add the mesh to the meshes table
  table.insert(meshes, {
    vertexes = c_vertexes,
    colors = c_colors,
    segments = c_segments
  })
end