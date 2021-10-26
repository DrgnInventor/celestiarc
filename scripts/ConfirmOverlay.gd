extends Control

signal confirmed
onready var confirm_button = $Panel/VBoxContainer/Content/VBoxContainer/ConfirmButton


func _ready() -> void:
	confirm_button.connect("pressed", self, "_on_confirm_button_pressed")


func _on_confirm_button_pressed() -> void:
	emit_signal("confirmed")
