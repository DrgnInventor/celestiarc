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


static func calculate_rotational_offset(
	meteor_position: Vector2,
	platform_rotational_origin: Vector2,
	radius: float,
	rotational_velocity: float,
	velocity: float
) -> Array:
	"""Given parameters, return such offset angles (in radians) that will make
	the platform collide with the meteor.

	Returns [], [float], [float, float]."""
	var o = platform_rotational_origin
	var m = meteor_position
	var R = radius

	# At this condition meteor would never collide a platform
	if abs(m.y - o.y) > radius:
		return []

	var root_res = sqrt((R - m.y + o.y) * (R + m.y - o.y))
	var val1 = asin((m.y - o.y) / R) \
		- (rotational_velocity / velocity) * (o.x - m.x + root_res)
	var val2 = (3.14 - asin((m.y - o.y) / R)) \
		- (rotational_velocity / velocity) * (o.x - m.x - root_res)

	if abs(m.y - o.y) == 1:
		return [val1]
	else:
		return [val1, val2]


static func simple_calculate_rotational_offset(
	meteor: KinematicBody2D,
	platform: Node2D
) -> Array:
	"""Convenience method for `calculate_rotational_offset`.

	`meteor` should be an instance of res://scenes/Meteor.tscn
	`platform` should be an instance of res://scenes/RotatingPlatform.tscn"""
	return calculate_rotational_offset(
		meteor.position,
		platform.position,
		platform.radius,
		platform.rotational_velocity,
		meteor.velocity
	)
