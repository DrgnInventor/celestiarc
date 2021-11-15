extends "res://scripts/BaseLevel.gd"

var dialog = Dialogic.start("Tutorial")


func _ready() -> void:
	add_child(dialog)
	dialog.connect("dialogic_signal", self, "dialog_handler")
	dialog.connect("timeline_end", self, "_on_first_timeline_ended")
	input_blocked = true


func _process(_delta: float) -> void:
	if input_blocked and Input.is_action_just_pressed("click"):
		## Simulate ui_accept
		var ev = InputEventAction.new()
		ev.action = "ui_accept"
		ev.pressed = true
		Input.parse_input_event(ev)


func _handle_win() -> void:
	var last_dialog = Dialogic.start("Tutorial after win")
	add_child(last_dialog)
	last_dialog.connect("timeline_end", self, "_on_last_timeline_ended")


func _on_first_timeline_ended(_ignore: Object) -> void:
	# Small delay for smoother transition
	yield(get_tree().create_timer(.5), "timeout")
	_on_confirmed()
	# warning-ignore:return_value_discarded
	Globals.connect("win", self, "_handle_win")


func _on_last_timeline_ended(_ignore: Object) -> void:
	input_blocked = false


func dialog_handler(value: String) -> void:
	match value:
		"goto_config": handle_overlay("config")
		"goto_forecast": handle_overlay("forecast")
		"goto_collidix": handle_overlay("collidix")
		"goto_confirm": handle_overlay("confirm")
		"goto_formula": handle_overlay("formula")
		"hide_overlay": hide_overlay()
		"start_calculation": Globals.emit_signal("start_calculation")
		"configure_p1":
			Globals.emit_signal("change_platform_config", 0, "0.7023")
		"configure_p2":
			Globals.emit_signal("change_platform_config", 1, "5.5099")
