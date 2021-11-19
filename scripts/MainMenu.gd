extends Control

signal play
signal exit
signal extra
onready var play_button = $Panel/VBoxContainer/PlayButton
onready var exit_button = $Panel/VBoxContainer/ExitButton
onready var extra_button = $Panel/VBoxContainer/ExtraButton

func _ready():
	play_button.connect("pressed", self, "_on_play_button_pressed")
	exit_button.connect("pressed", self, "_on_exit_button_pressed")
	extra_button.connect("pressed", self, "_on_extra_button_pressed")


func _on_play_button_pressed():
	emit_signal("play")


func _on_exit_button_pressed():
	emit_signal("exit")


func _on_extra_button_pressed():
	emit_signal("extra")
