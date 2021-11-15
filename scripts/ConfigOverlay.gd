extends Control

signal rotation_changed(idx, value)
onready var base = $Panel/VBoxContainer/Content/GridContainer
<<<<<<< HEAD
onready var close_overlay_button = $Panel/VBoxContainer/TitleBar/HBoxContainer2/CloseOverlayButton
onready var confirm_button = $Panel/HBoxContainer/ConfirmButton
=======
>>>>>>> parent of ef55650 (close overlay buttons)
onready var line_edits = [
	base.get_node("LineEdit"),
	base.get_node("LineEdit2")
]
var rotations = [0.0, 0.0]

func _ready():
	line_edits[0].connect("text_entered", self, "_on_line_edit_0_new_text")
	line_edits[0].connect("focus_exited", self, "_on_line_edit_0_new_text")
	line_edits[1].connect("text_entered", self, "_on_line_edit_1_new_text")
	line_edits[1].connect("focus_exited", self, "_on_line_edit_1_new_text")
<<<<<<< HEAD
	close_overlay_button.connect("pressed",self,"_close_overlay")
	confirm_button.connect("pressed", self, "_close_overlay")
=======
>>>>>>> parent of ef55650 (close overlay buttons)


func _on_line_edit_0_new_text(_ignore:Object = null) -> void:
	handle_row(0)


func _on_line_edit_1_new_text(_ignore:Object = null) -> void:
	handle_row(1)


func handle_row(idx: int) -> void:
	var value = line_edits[idx].text
	rotations[idx] = value.to_float() # Always gives a valid float
	# Float is reconverted to string because invalid string converts to 0.0 and
	# it is good UX to reflect what value is actually applied
	line_edits[idx].text = str(rotations[idx])
	emit_signal("rotation_changed", idx, rotations[idx])
<<<<<<< HEAD

func _close_overlay():
	emit_signal("close_overlay")
=======
>>>>>>> parent of ef55650 (close overlay buttons)
