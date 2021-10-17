tool
extends Node2D

export var radius = 100 setget set_radius
export var rotational_velocity = 1.07 setget set_rotational_velocity
onready var collider = $Collider
onready var orbit_line = $OrbitLine


func _ready():
	collider.position.x = radius
	if not Engine.editor_hint:
		orbit_line.visible = false


func _physics_process(delta):
	if not Engine.editor_hint:
		rotation += rotational_velocity * delta


# This is needed for tool because it sometimes runs scripts before it's ready
func is_ready():
	return collider != null


func tool_refresh():
	if Engine.editor_hint and is_ready():
		collider.position.x = radius
		refresh_orbit()


func refresh_orbit():
	var point_count = 100
	var angle_delta = 2 * PI / point_count
	orbit_line.clear_points()
	for i in range(point_count):
		orbit_line.add_point(Vector2(radius * cos(i * angle_delta),
									 radius * sin(i * angle_delta)))


func set_radius(value):
	radius = value
	tool_refresh()


func set_rotational_velocity(value):
	rotational_velocity = value
	tool_refresh()
