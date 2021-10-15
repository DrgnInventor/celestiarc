extends StaticBody2D

signal die
signal hp_change(hp)
export var max_hp = 100
var current_hp = max_hp


func hit(hp):
	current_hp = max(0, current_hp - hp)
	emit_signal("hp_change", hp)
	if current_hp == 0:
		emit_signal("die")
