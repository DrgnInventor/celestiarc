extends Control

const default_font = preload("res://resources/DefaultLabelFont.tres")
onready var wrapper = $Wrapper


func _ready():
	## Example data
	refresh_data([
		["M1-P1", "0.70", "0.20"],
		["M2-P1", "0.90", "0.40"],
		["M3-P1", "1.35", "1.74"],
	])


func _create_label(text: String) -> Label:
	var label = Label.new()
	label.set("custom_fonts/font", default_font)
	label.text = text
	return label


func create_row(a: String, b: String, c: String) -> void:
	wrapper.add_child(_create_label(a))
	wrapper.add_child(_create_label(b))
	wrapper.add_child(_create_label(c))


func refresh_data(data: Array) -> void:
	"""data: N sized array with arrays of 3 strings as children."""
	for child in wrapper.get_children():
		child.queue_free()

	create_row("", "Angle 1", "Angle 2")
	for d in data:
		create_row(d[0], d[1], d[2])
