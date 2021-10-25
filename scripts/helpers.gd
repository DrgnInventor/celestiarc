class_name Helpers


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
		CoordUtil.px_to_canon_coord(meteor.position),
		CoordUtil.px_to_canon_coord(platform.position),
		platform.radius,
		platform.rotational_velocity,
		meteor.velocity
	)
