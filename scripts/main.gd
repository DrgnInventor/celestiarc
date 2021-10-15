extends Node2D

const Meteor = preload("res://scenes/Meteor.tscn")
onready var hp_label = $HUD/Panel/HpLabel
onready var space_station = $SpaceStation


func _ready():
	refresh_hp_label()
	space_station.connect("hp_change", self, "_on_space_station_hp_change")
	# warning-ignore:return_value_discarded
	add_meteor(Vector2(100, 100), 300)
	# warning-ignore:return_value_discarded
	add_meteor(Vector2(100, 200), 200)


func _on_meteor_collision():
	space_station.hit(10)


func _on_space_station_hp_change(_hp: int) -> void:
	refresh_hp_label()


func add_meteor(pos: Vector2, v: int) -> KinematicBody2D:
	var m = Meteor.instance()
	m.connect("hit", self, "_on_meteor_collision")
	m.velocity = v
	m.global_position = pos
	add_child(m)
	return m

func refresh_hp_label() -> void:
	hp_label.text = "HP: %03d" % space_station.current_hp
