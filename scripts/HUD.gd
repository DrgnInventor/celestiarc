extends Control

signal collidix_button_pressed
const collidix_overlay = preload("res://scenes/CollidixOverlay.tscn")
onready var hp_label = $Panel/HBoxContainer/HpLabel
onready var collidix_button = $Panel/HBoxContainer/CollidixButton


func _ready():
	collidix_button.connect("pressed", self, "_on_collidix_button_pressed")


func _on_collidix_button_pressed():
	emit_signal("collidix_button_pressed")


func set_hp_label(hp: int) -> void:
	hp_label.text = "HP: %03d" % hp
