extends Control

onready var button_container = $Panel/MarginContainer/VBoxContainer/ButtonContainer


func _ready() -> void:
	Helpers.kill_children(button_container)


func _on_button_pressed(n: int) -> void:
	Globals.emit_signal("switch_level", n)


func _add_button(n: int) -> void:
	var btn = Button.new()
	btn.set("custom/fonts/font", Helpers.default_font)
	btn.text = "Level %d" % n
	btn.connect("pressed", self, "_on_button_pressed", [n])
	button_container.add_child(btn)


func refresh_buttons() -> void:
	for i in range(Globals.levels.size()):
		_add_button(i + 1)
