extends Node2D

const target_scene = preload("res://scenes/Levels/Level1.tscn")
var current_level = null
onready var main_menu = $MainMenuWrapper/MainMenu


func _ready():
	main_menu.connect("play", self, "_on_play")
	main_menu.connect("exit", self, "_on_exit")
	# warning-ignore:return_value_discarded
	Globals.connect("retry", self, "_on_retry")


func _on_retry():
	load_level()


func _on_play():
	load_level()


func _on_exit():
	get_tree().quit()


func load_level():
	if main_menu.visible:
		main_menu.visible = false

	if current_level:
		current_level.queue_free()
		current_level = null

	current_level = target_scene.instance()
	add_child(current_level)
