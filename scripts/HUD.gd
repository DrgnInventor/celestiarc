extends Control

signal config_button_pressed
signal collidix_button_pressed
signal confirm_button_pressed
const collidix_overlay = preload("res://scenes/CollidixOverlay.tscn")
onready var hp_label = $Panel/HBoxContainer/HpLabel
onready var config_button = $Panel/HBoxContainer/ConfigButton
onready var collidix_button = $Panel/HBoxContainer/CollidixButton
onready var confirm_button = $Panel/HBoxContainer/ConfirmButton


func _ready():
	collidix_button.connect("pressed", self, "_on_collidix_button_pressed")
	config_button.connect("pressed", self, "_on_config_button_pressed")
	confirm_button.connect("pressed", self, "_on_confirm_button_pressed")


func _on_config_button_pressed():
	emit_signal("config_button_pressed")


func _on_collidix_button_pressed():
	emit_signal("collidix_button_pressed")


func _on_confirm_button_pressed():
	emit_signal("confirm_button_pressed")


func set_hp_label(hp: int) -> void:
	hp_label.text = "HP: %03d" % hp
