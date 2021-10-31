extends Node2D

var current_level_obj: Node = null
onready var main_menu = $MainMenuWrapper/MainMenu
onready var level_menu = $MainMenuWrapper/LevelMenu


func _ready():
	main_menu.connect("play", self, "_on_play")
	main_menu.connect("exit", self, "_on_exit")
	# warning-ignore:return_value_discarded
	Globals.connect("retry", self, "_on_retry")
	# warning-ignore:return_value_discarded
	Globals.connect("next_level", self, "_on_next_level")
	# warning-ignore:return_value_discarded
	Globals.connect("switch_level", self, "_on_switch_level")
	scan_level()


func _on_retry():
	load_level(Globals.current_level_n)


func _on_next_level() -> void:
	load_level(Globals.current_level_n + 1)


func _on_switch_level(n: int) -> void:
	load_level(n)
	level_menu.visible = false


func _on_play():
	level_menu.refresh_buttons()
	level_menu.visible = true
	main_menu.visible = false


func _on_exit():
	get_tree().quit()


func load_level(n: int):
	"""Make n-th level the current running level.

	n: N-th level, n >= 1"""
	if main_menu.visible:
		main_menu.visible = false

	if current_level_obj:
		current_level_obj.queue_free()
		current_level_obj = null

	Globals.current_level_n = n
	current_level_obj = Globals.levels[n - 1].instance()
	add_child(current_level_obj)


func scan_level(level_n: int = 1) -> void:
	"""Recursively scan currently available levels by checking levels folder."""
	var level_path = "res://scenes/Levels/Level%d.tscn" % level_n

	if ResourceLoader.exists(level_path):
		Globals.levels.append(load(level_path))
		scan_level(level_n + 1)
