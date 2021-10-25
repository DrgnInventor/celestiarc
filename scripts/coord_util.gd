tool
extends Node
class_name coord_util

# It is easier to hardcode these values for now
const hud_h = 50.0
const window_h = 600.0


func px_to_canon_coord(coord: Vector2) -> Vector2:
	"""Convert pixel coordinates to the coordinates more comfortable for game.

	Canonical origin is located at the bottom left corner of the window, just
	like in mathematics. Point (0, 100) is located at the top left corner,
	*below the hud*. There are 2 reasons, a) it's simpler to think with round
	numbers and b) HUD is opaque and we don't want meteorites there."""
	var new_coord = coord
	# Move origin to bottom left
	new_coord.y -= window_h
	# Flip Y axis
	new_coord.y *= -1
	# The numerator is the distance from bottom to hud. Since this distance
	# should be 100 units, we divide it with 100. The result is the scale, the
	# multiplier to obtain from canon to pixel (not vice-versa). Because of that
	# coordinates are diviced not multiplied
	new_coord /= (window_h - hud_h) / 100
	return new_coord


func canon_to_px_coord(coord: Vector2) -> Vector2:
	"""Convert the convenient coordinates to pixel grid.

	Since this is the reverse of `px_to_canon_coord`, the explanation of the
	code can be seen there."""
	var new_coord = coord
	new_coord *= (window_h - hud_h) / 100
	new_coord /= Vector2(1, -1)
	new_coord.y += window_h
	return new_coord


func x_canon_to_px_coord(x: float) -> float:
	return canon_to_px_coord(Vector2(x, 0)).x
