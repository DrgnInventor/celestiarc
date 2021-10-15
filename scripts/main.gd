extends Node2D

const Meteor = preload("res://scenes/Meteor.tscn")


func _ready():
	# warning-ignore:return_value_discarded
	add_meteor(Vector2(100, 100), 300)
	# warning-ignore:return_value_discarded
	add_meteor(Vector2(100, 200), 200)


func add_meteor(pos: Vector2, v: int) -> KinematicBody2D:
	var m = Meteor.instance()
	m.velocity = v
	m.global_position = pos
	add_child(m)
	return m
