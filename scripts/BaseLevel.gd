extends Node2D

enum Status { ACTIVE, LOST, WIN }
var status = Status.ACTIVE
var Meteor = load("res://scenes/Meteor.tscn")
var Helpers = load("res://scripts/helpers.gd")
var is_table_active = false
var current_overlay = null
var input_blocked = false # When true, forbid input (except dialog)
onready var current_platforms = [
	$RotatingPlatforms/RotatingPlatform,
	$RotatingPlatforms/RotatingPlatform2,
]
onready var current_meteors = [
	$Meteors/Meteor,
	$Meteors/Meteor2,
	$Meteors/Meteor3,
]
onready var hud = $HUD
onready var config_overlay = $Overlays/ConfigOverlay
onready var forecast_overlay = $Overlays/ForecastOverlay
onready var collidix_overlay = $Overlays/CollidixOverlay
onready var confirm_overlay = $Overlays/ConfirmOverlay
onready var win_overlay = $Overlays/WinOverlay
onready var lose_overlay = $Overlays/LoseOverlay
onready var formula_overlay = $Overlays/FormulaOverlay
onready var in_level_menu_overlay = $Overlays/InLevelMenuOverlay
onready var alive_meteors = current_meteors.size()

func _ready():
	hud.connect("collidix_button_pressed", self, "_on_collidix_button_pressed")
	hud.connect("forecast_button_pressed", self, "_on_forecast_button_pressed")
	hud.connect("config_button_pressed", self, "_on_config_button_pressed")
	hud.connect("confirm_button_pressed", self, "_on_confirm_button_pressed")
	hud.connect("menu_button_pressed", self, "_on_menu_button_pressed")
	config_overlay.connect("rotation_changed", self, "_on_rotation_changed")
	confirm_overlay.connect("confirmed", self, "_on_confirmed")
	Globals.connect("close_overlay", self, "hide_overlay")

	for m in current_meteors:
		m.connect("hit", self, "_on_meteor_collision")
		m.connect("tree_exited", self, "_on_meteor_destruction")

	for p in current_platforms:
		p.display_orbit(true)

	collidix_overlay.gen_table(current_meteors, current_platforms)
	forecast_overlay.gen_tables(current_meteors, current_platforms)
	

func _process(_delta: float):
	if not input_blocked and Input.is_action_just_pressed("ui_cancel"):
		# For UX; provides an intuitive way to escape the level
		if not current_overlay:
			handle_overlay("in_level_menu")
		else:
			hide_overlay()


func _on_meteor_destruction() -> void:
	alive_meteors -= 1
	# Status is checked because this can be triggered when the last meteor hits
	# the space station
	if alive_meteors == 0 and status == Status.ACTIVE:
		status = Status.WIN
		win_handler()


func _on_meteor_collision() -> void:
	status = Status.LOST
	lose_handler()


func _on_config_button_pressed() -> void:
	handle_overlay("config")


func _on_forecast_button_pressed() -> void:
	handle_overlay("forecast")


func _on_collidix_button_pressed() -> void:
	handle_overlay("collidix")


func _on_confirm_button_pressed() -> void:
	handle_overlay("confirm")


func _on_menu_button_pressed() -> void:
	handle_overlay("in_level_menu")


func _on_rotation_changed(idx: int, value: float) -> void:
	if idx == 0:
		current_platforms[0].rotational_offset = value
	elif idx == 1:
		current_platforms[1].rotational_offset = value


func _on_confirmed() -> void:
	hide_overlay()
	hud.disable_buttons()
	for p in current_platforms:
		p.display_orbit(false)
	start_level()


func add_meteor(pos: Vector2, v: float) -> KinematicBody2D:
	var m = Meteor.instance()
	m.connect("hit", self, "_on_meteor_collision")
	m.velocity = v
	m.global_position = CoordUtil.canon_to_px_coord(pos)
	add_child(m)
	return m


func string_to_overlay(name: String):
	match name:
		"collidix": return collidix_overlay
		"forecast": return forecast_overlay
		"config": return config_overlay
		"confirm": return confirm_overlay
		"win": return win_overlay
		"lose": return lose_overlay
		"formula": return formula_overlay
		"in_level_menu": return in_level_menu_overlay
		_: push_error('Invalid overlay name %s!' % name)


func handle_overlay(overlay_name: String):
	var overlay = string_to_overlay(overlay_name)

	# If the same overlay is triggered again, assume that the overlay should be
	# hidden
	if current_overlay == overlay_name:
		overlay.visible = false
		current_overlay = null
	else:
		if current_overlay != null:
			string_to_overlay(current_overlay).visible = false
		overlay.visible = true
		current_overlay = overlay_name


func hide_overlay() -> void:
	# Since handling the same overlay button hides the overlay, this works
	if current_overlay:
		handle_overlay(current_overlay)


func start_level() -> void:
	Globals.level_running = true


func lose_handler() -> void:
	handle_overlay("lose")
	Globals.level_running = false
	for m in $Meteors.get_children():
		m.queue_free()


func win_handler() -> void:
	handle_overlay("win")
	Globals.level_running = false
	Globals.emit_signal("win")
