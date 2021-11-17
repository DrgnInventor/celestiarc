extends Button

func _pressed():
	Globals.emit_signal("close_overlay")
