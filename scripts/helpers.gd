class_name Helpers

const rounded_PI = 3.1416 # PI that is rounded to 0.001
const default_font = preload("res://resources/DefaultLabelFont.tres")

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


	val1 = f_round(normalize_angle(val1))
	val2 = f_round(normalize_angle(val2))

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


static func normalize_angle(angle: float) -> float:
	"""Convert angle to range of [0; 2PI)."""
	# To be consistent, PI with 4 digit precision is used
	return fposmod(angle, rounded_PI * 2)


static func _create_label(text: String) -> Label:
	var label = Label.new()
	label.set("custom_fonts/font", default_font)
	label.text = text
	return label


static func calculate_velocity(
	meteor_position: Vector2,
	platform_rotational_origin: Vector2,
	radius: float,
	rotational_velocity: float,
	rotational_offset: float,
	iteration: int = 0
) -> float:
	"""Given parameters, get potential velocity.

	Its purpose is manual level construction and is not well-tested.
	`iteration` represents the count of full rotation. There are infinite
	velocities possible."""
	var m = meteor_position
	var o = platform_rotational_origin
	var R = radius
	rotational_offset = normalize_angle(rotational_offset)
	var root_expr = sqrt((R - m.y + o.y) * (R + m.y - o.y))
	## Formula is different when angle is on the left side or right side
	if (rounded_PI * 0.5 < rotational_offset
		and rotational_offset < rounded_PI * 1.5):
		return - (rotational_velocity * (o.x - m.x - root_expr)) \
			/ (rotational_offset - rounded_PI + asin((m.y - o.y) / radius)
				- 2 * rounded_PI * iteration)
	else:
		return - (rotational_velocity * (o.x - m.x + root_expr)) \
			/ (rotational_offset - asin((m.y - o.y) / radius)
				- 2 * rounded_PI * iteration)


static func create_row(wrapper: Node, data: Array) -> void:
	for child in data:
		if typeof(child) == TYPE_STRING:
			wrapper.add_child(_create_label(child))
		else:
			push_warning("create_row argument is not a String, but is: " + str(typeof(child)))


static func kill_children(container: Node):
		for child in container.get_children():
			child.queue_free()


static func simple_calculate_velocity(
	meteor: KinematicBody2D,
	platform: Node2D,
	iteration: int = 0
) -> float:
	"""Convenience method for `calculate_velocity`."""
	return calculate_velocity(
		CoordUtil.px_to_canon_coord(meteor.position),
		CoordUtil.px_to_canon_coord(platform.position),
		platform.radius,
		platform.rotational_velocity,
		platform.rotational_offset,
		iteration
	)


static func f_round(f: float) -> float:
	return stepify(f, Globals.epsilon)


static func v2_round(v2: Vector2) -> Vector2:
	return Vector2(f_round(v2.x), f_round(v2.y))


static func f_round_fmt(f: float) -> String:
	# log(val) / log(10) is base 10 log.
	var digits = -(log(Globals.epsilon) / log(10))
	return "%.{digits}f".format({"digits": digits}) % f


static func v2_round_fmt(v2: Vector2) -> String:
	return "(%s; %s)" % [f_round_fmt(v2.x), f_round_fmt(v2.y)]


static func can_switch_to_next_level() -> bool:
	return Globals.current_level_n < Globals.levels.size()


static func get_level_count() -> int:
	return Globals.levels.size()
