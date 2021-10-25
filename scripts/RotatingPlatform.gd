tool
extends Node2D
# Note: Comments with "because trigonometry" explain compensation for Godot's
# rotation which goes clockwise unlike in trigonometry where rotation goes
# counterclowise

export var radius = 100 setget set_radius
export var rotational_velocity = 1.07 setget set_rotational_velocity
export var rotational_offset = 0.00 setget set_rotational_offset
onready var collider = $Collider
onready var orbit_line = $OrbitLine


func _ready():
	collider.position.x = px_radius()
	if not Engine.editor_hint:
		orbit_line.visible = false


func _physics_process(delta):
	if not Engine.editor_hint:
		# Minus because trigonometry
		rotation -= rotational_velocity * delta


# This is needed for tool because it sometimes runs scripts before it's ready
func is_ready():
	return collider != null


func px_radius() -> float:
	return CoordUtil.x_canon_to_px_coord(radius)


func tool_refresh():
	if Engine.editor_hint and is_ready():
		collider.position.x = px_radius()
		# Minus because trigonometry
		rotation = -rotational_offset
		refresh_orbit()


func refresh_orbit():
	var point_count = 100
	var angle_delta = 2 * PI / point_count
	orbit_line.clear_points()
	for i in range(point_count):
		orbit_line.add_point(Vector2(px_radius() * cos(i * angle_delta),
									 px_radius() * sin(i * angle_delta)))


func set_radius(value):
	radius = value
	tool_refresh()


func set_rotational_velocity(value):
	rotational_velocity = value
	tool_refresh()


func set_rotational_offset(value):
	rotational_offset = value
	tool_refresh()
