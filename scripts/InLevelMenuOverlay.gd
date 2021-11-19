extends Control

onready var main_menu_button = $Panel/VBoxContainer/Content/VBoxContainer/MainMenuButton
onready var exit_button = $Panel/VBoxContainer/Content/VBoxContainer/ExitButton


func _ready() -> void:
	main_menu_button.connect("pressed", self, "_on_main_menu_button_pressed")
	exit_button.connect("pressed", self, "_on_exit_button_pressed")


func _on_main_menu_button_pressed() -> void:
	Globals.emit_signal("show_level_menu")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
