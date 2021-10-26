extends Node2D

var Meteor = load("res://scenes/Meteor.tscn")
var Helpers = load("res://scripts/helpers.gd")
var is_table_active = false
onready var hud = $HUD
onready var space_station = $SpaceStation
onready var meteor_platform_table = $MeteorPlatformTable
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
	# warning-ignore:unused_variable
	var meteors = [
		add_meteor(Vector2(0, 40), 50),
		add_meteor(Vector2(0, 60), 50)
	]

	collidix_overlay.set_table_data(
		gen_meteor_platform_table_data(meteors, [$RotatingPlatform])
	)


func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_up"):
		show_table()
	if Input.is_action_just_pressed("ui_down"):
		hide_table()


func _on_meteor_collision():
	space_station.hit(10)


func _on_space_station_hp_change(_hp: int) -> void:
	refresh_hp_label()


func _on_config_button_pressed() -> void:
	config_overlay.visible = !config_overlay.visible


func _on_forecast_button_pressed() -> void:
	forecast_overlay.visible = !forecast_overlay.visible


func _on_collidix_button_pressed() -> void:
	collidix_overlay.visible = !collidix_overlay.visible


func _on_confirm_button_pressed() -> void:
	confirm_overlay.visible = !confirm_overlay.visible


func add_meteor(pos: Vector2, v: int) -> KinematicBody2D:
	var m = Meteor.instance()
	m.connect("hit", self, "_on_meteor_collision")
	m.velocity = v
	m.global_position = CoordUtil.canon_to_px_coord(pos)
	add_child(m)
	return m


func refresh_hp_label() -> void:
	hud.set_hp_label(space_station.current_hp)


func show_table() -> void:
	if is_table_active:
		return
	meteor_platform_table.rect_position.y -= meteor_platform_table.rect_size.y
	is_table_active = true


func hide_table():
	if not is_table_active:
		return
	meteor_platform_table.rect_position.y += meteor_platform_table.rect_size.y
	is_table_active = false


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
			match offsets.size():
				0:
					val_1 = "-"
					val_2 = "-"
				1:
					val_1 = str(offsets[0])
					val_2 = "-"
				2:
					val_1 = str(offsets[0])
					val_2 = str(offsets[1])
				_:
					push_error("'offsets' is in wrong shape! ")

			var title = "M%s-P%s" % [m_i + 1, p_i + 1]
			res.append([title, val_1, val_2])

	return res
