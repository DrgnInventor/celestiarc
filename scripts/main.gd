extends Node2D

var Meteor = load("res://scenes/Meteor.tscn")
var Helpers = load("res://scripts/helpers.gd")
var is_table_active = false
var current_overlay = null
onready var hud = $HUD
onready var space_station = $SpaceStation
onready var platform_0 = $RotatingPlatform
onready var config_overlay = $Overlays/ConfigOverlay
onready var forecast_overlay = $Overlays/ForecastOverlay
onready var collidix_overlay = $Overlays/CollidixOverlay
onready var confirm_overlay = $Overlays/ConfirmOverlay

func _ready():
	refresh_hp_label()
	space_station.connect("hp_change", self, "_on_space_station_hp_change")
	hud.connect("collidix_button_pressed", self, "_on_collidix_button_pressed")
	hud.connect("forecast_button_pressed", self, "_on_forecast_button_pressed")
	hud.connect("config_button_pressed", self, "_on_config_button_pressed")
	hud.connect("confirm_button_pressed", self, "_on_confirm_button_pressed")
	config_overlay.connect("rotation_changed", self, "_on_rotation_changed")
	confirm_overlay.connect("confirmed", self, "_on_confirmed")
	# warning-ignore:unused_variable
	var meteors = [
		add_meteor(Vector2(0, 40), 50),
		add_meteor(Vector2(0, 80), 50)
	]
	
	
	collidix_overlay.set_table_data(
		gen_meteor_platform_table_data(meteors, [$RotatingPlatform])
	)
	forecast_overlay.set_table_data(meteors, [$RotatingPlatform])

func _process(_delta: float):
	if Input.is_action_just_pressed("ui_cancel"):
		hide_overlay()


func _on_meteor_collision():
	space_station.hit(10)


func _on_space_station_hp_change(_hp: int) -> void:
	refresh_hp_label()


func _on_config_button_pressed() -> void:
	handle_overlay_buttons("config")


func _on_forecast_button_pressed() -> void:
	handle_overlay_buttons("forecast")


func _on_collidix_button_pressed() -> void:
	handle_overlay_buttons("collidix")


func _on_confirm_button_pressed() -> void:
	handle_overlay_buttons("confirm")


func _on_rotation_changed(idx: int, value: float) -> void:
	if idx == 0:
		platform_0.rotational_offset = value


func _on_confirmed() -> void:
	hide_overlay()
	start_level()


func add_meteor(pos: Vector2, v: int) -> KinematicBody2D:
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
		_: push_error('Invalid overlay name %s!' % name)


func handle_overlay_buttons(overlay_name: String):
	var overlay = string_to_overlay(overlay_name)

	# If the same overlay button is clicked again, assume that the overlay
	# should be hidden
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
		handle_overlay_buttons(current_overlay)


func refresh_hp_label() -> void:
	hud.set_hp_label(space_station.current_hp)


func gen_meteor_platform_table_data(meteors: Array, platforms: Array) -> Array:
	var res = []
	for p_i in platforms.size():
		for m_i in meteors.size():
			var offsets = Helpers.simple_calculate_rotational_offset(
				meteors[m_i],
				platforms[p_i]
			)
			var val_1 = ""
			var val_2 = ""
			var roundTo = 0.01
			match offsets.size():
				0:
					val_1 = "-"
					val_2 = "-"
				1:
					val_1 = str(offsets[0], Globals.number_rounder)
					val_2 = "-"
				2:
					val_1 = str(offsets[0])
					val_2 = str(offsets[1])
				_:
					push_error("'offsets' is in wrong shape! ")

			var title = "M%s-P%s" % [m_i + 1, p_i + 1]
			res.append([title, val_1, val_2])

	return res
	

func start_level() -> void:
	Globals.level_running = true
