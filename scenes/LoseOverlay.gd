extends Control

onready var retry_button = $Panel/VBoxContainer/Content/VBoxContainer/RetryButton


func _ready():
	retry_button.connect("pressed", self, "_on_retry_button_pressed")


func _on_retry_button_pressed():
	Globals.emit_signal("retry")
