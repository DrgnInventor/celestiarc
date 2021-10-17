tool
extends Node2D

export var radius = 100 setget set_radius
export var rotational_velocity = 1.07 setget set_rotational_velocity
onready var collider = $Collider


func _ready():
	collider.position.x = radius


func _physics_process(delta):
	if not Engine.editor_hint:
		rotation += rotational_velocity * delta


func tool_refresh():
	# Sometimes collider is null and in that case do nothing
	# That probably is caused by tool being executed before collider is loaded
	if Engine.editor_hint and collider != null:
		collider.position.x = radius


func set_radius(value):
	radius = value
	tool_refresh()


func set_rotational_velocity(value):
	rotational_velocity = value
	tool_refresh()
