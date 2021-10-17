extends Node2D

export var radius = 100
export var rotational_velocity = 1.07
onready var collider = $Collider


func _ready():
	collider.position.x += radius


func _physics_process(delta):
	rotation += rotational_velocity * delta
