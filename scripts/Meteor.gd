extends KinematicBody2D

signal hit
const direction_vector = Vector2(1, 0)
export var velocity = 100.0000


func _physics_process(delta):
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


func _is_space_station(body: Object) -> bool:
	return body.name == "SpaceStation"
