extends Control

onready var wrapper = $Wrapper


func _ready():
	## Example data
	refresh_data([
		["M1-P1", "0.70", "0.20"],
		["M2-P1", "0.90", "0.40"],
		["M3-P1", "1.35", "1.74"],
	])


func refresh_data(data: Array) -> void:
	"""data: N sized array with arrays of 3 strings as children."""
	Helpers.kill_children(wrapper)

	Helpers.create_row(wrapper,["", "Angle 1", "Angle 2"])
	for d in data:
		Helpers.create_row(wrapper, [d[0], d[1], d[2]])
