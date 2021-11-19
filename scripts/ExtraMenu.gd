extends Control

signal close_extra
onready var close_extra_button = $Panel/CloseExtraButton

func _ready():
	close_extra_button.connect("pressed", self, "_close_extra")

func _close_extra():
	Globals.emit_signal("close_extra")
