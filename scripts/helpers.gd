class_name Helpers
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

	if abs(m.y - o.y) == 1:
		return [stepify(val1, Globals.epsilon)]
	else:
		return [stepify(val1, Globals.epsilon), 
		stepify(val2, Globals.epsilon)
		]


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


static func _create_label(text: String) -> Label:
	var label = Label.new()
	label.set("custom_fonts/font", default_font)
	label.text = text
	return label


static func create_row(wrapper: Node, data: Array) -> void:
	for child in data: 
		if typeof(child) == TYPE_STRING:
			wrapper.add_child(_create_label(child))
		else: 
			push_warning("create_row argument is not a String, but is: " + str(typeof(child)))
	

static func kill_children(container: Node):
		for child in container.get_children():
			child.queue_free()
