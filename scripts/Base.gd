extends Node2D

const tutorial_level = preload("res://scenes/Levels/Tutorial.tscn")
var current_level_obj: Node = null
onready var main_menu = $MainMenuWrapper/MainMenu
onready var level_menu = $MainMenuWrapper/LevelMenu
onready var extra_menu = $MainMenuWrapper/ExtraMenu

func _ready():
	main_menu.connect("play", self, "_on_play")
	main_menu.connect("exit", self, "_on_exit")
	main_menu.connect("extra", self, "_on_extra")
	Globals.connect("close_extra", self, "_exit_extra")
	# warning-ignore:return_value_discarded
	Globals.connect("retry", self, "_on_retry")
	# warning-ignore:return_value_discarded
	Globals.connect("next_level", self, "_on_next_level")
	# warning-ignore:return_value_discarded
	Globals.connect("switch_level", self, "_on_switch_level")
	# warning-ignore:return_value_discarded
	Globals.connect("switch_tutorial_level", self, "_on_switch_tutorial_level")
	scan_level()
	Globals.connect("show_level_menu", self, "_show_level_menu")


func _on_retry():
	load_level(Globals.current_level_n)


func _on_next_level() -> void:
	load_level(Globals.current_level_n + 1)


func _on_switch_level(n: int) -> void:
	load_level(n)
	level_menu.visible = false


func _on_switch_tutorial_level() -> void:
	load_tutorial_level()
	level_menu.visible = false


func _on_play():
	level_menu.refresh_buttons()
	level_menu.visible = true
	main_menu.visible = false


func _exit_extra():
	main_menu.visible = true
	extra_menu.visible = false


func _on_exit():
	get_tree().quit()


func _on_extra():
	extra_menu.visible = true
	main_menu.visible = false


func load_tutorial_level():
	if main_menu.visible:
		main_menu.visible = false

	if current_level_obj:
		current_level_obj.queue_free()
		current_level_obj = null

	Globals.current_level_n = 1 # FIXME Hack
	current_level_obj = tutorial_level.instance()
	add_child(current_level_obj)


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


func _show_level_menu():
	current_level_obj.queue_free()
	current_level_obj = null
	level_menu.visible = true
