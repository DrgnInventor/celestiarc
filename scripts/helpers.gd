class_name Helpers


static func px_to_canon_coord(
	coord: Vector2,
	window_height: float,
	hud_height: float
) -> Vector2:
	"""Convert pixel coordinates to the coordinates more comfortable for game.

	Canonical origin is located at the bottom left corner of the window, just
	like in mathematics. Point (0, 100) is located at the top left corner,
	*below the hud*. There are 2 reasons, a) it's simpler to think with round
	numbers and b) HUD is opaque and we don't want meteorites there."""
	var new_coord = coord
	# Move origin to bottom left
	new_coord.y -= window_height
	# Flip Y axis
	new_coord.y *= -1
	# The numerator is the distance from bottom to hud. Since this distance
	# should be 100 units, we divide it with 100. The result is the scale, the
	# multiplier to obtain from canon to pixel (not vice-versa). Because of that
	# coordinates are diviced not multiplied
	new_coord /= (window_height - hud_height) / 100
	return new_coord


static func canon_to_px_coord(
	coord: Vector2,
	window_height: float,
	hud_height: float
) -> Vector2:
	"""Convert the convenient coordinates to pixel grid.

	Since this is the reverse of `px_to_canon_coord`, the explanation of the
	code can be seen there."""
	var new_coord = coord
	new_coord *= (window_height - hud_height) / 100
	new_coord /= Vector2(1, -1)
	new_coord.y += window_height
	return new_coord
