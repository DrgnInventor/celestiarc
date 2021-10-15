extends KinematicBody2D

const direction_vector = Vector2(1, 0)
export var velocity = 100


func _physics_process(delta):
	# warning-ignore:return_value_discarded
	move_and_collide(velocity * direction_vector * delta)
