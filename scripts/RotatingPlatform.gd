tool
extends Node2D
# Note: Comments with "because trigonometry" explain compensation for Godot's
# rotation which goes clockwise unlike in trigonometry where rotation goes
# counterclowise

## Exported with Globals.epsilon precision
export(float, 0, 1000, 0.0001) var radius = 100 setget set_radius
export(float, 0, 7, 0.0001) var rotational_velocity = 1.07 \
	setget set_rotational_velocity
export(float, 0, 7, 0.0001) var rotational_offset = 0.00 \
	setget set_rotational_offset
export var canon_coord = Vector2(0.0, 0.0) setget set_canon_coord
onready var collider = $Collider
onready var orbit_line = $OrbitLine
# Variable that is used to listen for position change
onready var tool_last_global_position = global_position


func _ready():
	collider.position.x = px_radius()
	if not Engine.editor_hint:
		display_orbit(false)
	refresh_orbit()


func _process(_delta: float) -> void:
	if Engine.editor_hint:
		if tool_last_global_position != global_position:
			_on_global_position_changed()


func _physics_process(delta):
	if not Engine.editor_hint:
		if not Globals.level_running:
			return
		# Minus because trigonometry
		rotation -= rotational_velocity * delta


# This is needed for tool because it sometimes runs scripts before it's ready
func is_ready():
	return collider != null


func px_radius() -> float:
	return CoordUtil.x_canon_to_px_coord(radius)


func tool_refresh():
	if Engine.editor_hint and is_ready():
		property_list_changed_notify()
		collider.position.x = px_radius()
		# Minus because trigonometry
		rotation = -rotational_offset
		refresh_orbit()


func refresh_orbit():
	var point_count = 100
	var angle_delta = 2 * PI / point_count
	orbit_line.clear_points()
	# point_count+1 so that the circle closes
	for i in range(point_count + 1):
		orbit_line.add_point(Vector2(px_radius() * cos(i * angle_delta),
									 px_radius() * sin(i * angle_delta)))


func _on_global_position_changed():
	canon_coord = CoordUtil.px_to_canon_coord(global_position)
	tool_last_global_position = global_position
	tool_refresh()


func set_radius(value):
	radius = value
	tool_refresh()


func set_rotational_velocity(value):
	rotational_velocity = value
	tool_refresh()


func set_rotational_offset(value):
	rotational_offset = value
	rotation = -rotational_offset
	tool_refresh()


func set_canon_coord(value: Vector2) -> void:
	canon_coord = value
	global_position = CoordUtil.canon_to_px_coord(value)
	tool_refresh()


func display_orbit(b: bool):
	orbit_line.visible = b
