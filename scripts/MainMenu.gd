extends Control

signal play
signal exit
onready var play_button = $Panel/VBoxContainer/PlayButton
onready var exit_button = $Panel/VBoxContainer/ExitButton


func _ready():
	play_button.connect("pressed", self, "_on_play_button_pressed")
	exit_button.connect("pressed", self, "_on_exit_button_pressed")


func _on_play_button_pressed():
	emit_signal("play")


func _on_exit_button_pressed():
	emit_signal("exit")
