extends KinematicBody2D

signal hit
const direction_vector = Vector2(1, 0)
export var velocity = 100


func _physics_process(delta):
	var collision = move_and_collide(velocity * direction_vector * delta)
	if collision and _is_space_station(collision.get_collider()):
		emit_signal("hit")
		queue_free()


func _is_space_station(body: Object) -> bool:
	return body.name == "SpaceStation"
