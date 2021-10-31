tool
extends KinematicBody2D

signal hit
const direction_vector = Vector2(1, 0)
# Exported with Globals.epsilon precision
export(float, 0, 1000, 0.0001) var velocity = 100.0000
export var canon_coord = Vector2(0.0, 0.0) setget set_canon_coord
onready var tool_last_global_position = global_position


func _process(_delta: float) -> void:
	if Engine.editor_hint:
		if tool_last_global_position != global_position:
			_on_global_position_changed()


func _physics_process(delta):
	if not Engine.editor_hint:
		if not Globals.level_running:
			return

		var collision = move_and_collide(
			CoordUtil.canon_to_px_coord(Vector2(velocity, 0)).x
			* direction_vector * delta
		)

		if collision:
			if _is_space_station(collision.get_collider()):
				emit_signal("hit")

			queue_free()


func _on_global_position_changed() -> void:
	canon_coord = CoordUtil.px_to_canon_coord(global_position)
	tool_last_global_position = global_position
	property_list_changed_notify()


func _is_space_station(body: Object) -> bool:
	return body.name == "SpaceStation"


func set_canon_coord(value: Vector2) -> void:
	canon_coord = value
	global_position = CoordUtil.canon_to_px_coord(value)
