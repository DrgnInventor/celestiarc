extends Control

signal config_button_pressed
signal forecast_button_pressed
signal collidix_button_pressed
signal confirm_button_pressed
const collidix_overlay = preload("res://scenes/CollidixOverlay.tscn")
onready var config_button = $Panel/HBoxContainer/ConfigButton
onready var forecast_button = $Panel/HBoxContainer/ForecastButton
onready var collidix_button = $Panel/HBoxContainer/CollidixButton
onready var confirm_button = $Panel/HBoxContainer/ConfirmButton


func _ready():
	collidix_button.connect("pressed", self, "_on_collidix_button_pressed")
	forecast_button.connect("pressed", self, "_on_forecast_button_pressed")
	config_button.connect("pressed", self, "_on_config_button_pressed")
	confirm_button.connect("pressed", self, "_on_confirm_button_pressed")


func _on_config_button_pressed():
	emit_signal("config_button_pressed")


func _on_forecast_button_pressed():
	emit_signal("forecast_button_pressed")


func _on_collidix_button_pressed():
	emit_signal("collidix_button_pressed")


func _on_confirm_button_pressed():
	emit_signal("confirm_button_pressed")


func disable_buttons():
	collidix_button.disabled = true
	forecast_button.disabled = true
	config_button.disabled = true
	confirm_button.disabled = true
