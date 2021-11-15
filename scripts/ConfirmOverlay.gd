extends Control

signal confirmed
signal close_overlay
onready var confirm_button = $Panel/VBoxContainer/Content/VBoxContainer/ConfirmButton
onready var close_overlay_button = $Panel/VBoxContainer/TitleBar/HBoxContainer2/CloseOverlayButton

func _ready() -> void:
	confirm_button.connect("pressed", self, "_on_confirm_button_pressed")
	close_overlay_button.connect("pressed",self,"_on_close_overlay_button_pressed")

func _on_confirm_button_pressed() -> void:
	emit_signal("confirmed")


func _on_close_overlay_button_pressed():
	emit_signal("close_overlay")
