extends Control

const main_scene_location = "res://scenes/Main.tscn"
onready var play_button = $Panel/VBoxContainer/PlayButton
onready var exit_button = $Panel/VBoxContainer/ExitButton


func _ready():
	play_button.connect("pressed", self, "_on_play_button_pressed")
	exit_button.connect("pressed", self, "_on_exit_button_pressed")


func _on_play_button_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(main_scene_location)


func _on_exit_button_pressed():
	get_tree().quit()
