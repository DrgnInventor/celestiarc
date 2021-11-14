extends Control

onready var button_container = $Panel/MarginContainer/VBoxContainer/ButtonContainer


func _ready() -> void:
	Helpers.kill_children(button_container)


func _on_button_pressed(n: int) -> void:
	Globals.emit_signal("switch_level", n)


func _on_tutorial_button_pressed() -> void:
	Globals.emit_signal("switch_tutorial_level")


func _add_button(n: int) -> void:
	var btn = Button.new()
	btn.set("custom/fonts/font", Helpers.default_font)
	btn.text = "Level %d" % n
	btn.connect("pressed", self, "_on_button_pressed", [n])
	button_container.add_child(btn)


func refresh_buttons() -> void:
	var btn = Button.new()
	btn.set("custom/fonts/font", Helpers.default_font)
	btn.text = "Tutorial"
	btn.connect("pressed", self, "_on_tutorial_button_pressed")
	button_container.add_child(btn)

	for i in range(Globals.levels.size()):
		_add_button(i + 1)
