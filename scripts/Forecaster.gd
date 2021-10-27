extends Control

const default_font = preload("res://resources/DefaultLabelFont.tres")
onready var forecast = $Forecast


func _create_label(text: String) -> Label:
	var label = Label.new()
	label.set("custom_fonts/font", default_font)
	label.text = text
	return label


func create_row(a: String, b: String) -> void:
	forecast.add_child(_create_label(a))
	forecast.add_child(_create_label(b))


func refresh_data(m: Array, p: Array) -> void:
	"""data: N sized array with arrays of 3 strings as children."""
	for child in forecast.get_children():
		child.queue_free()

	var i = 0

	create_row("Meteors", "Platforms")	
	while true:
		if i+1 <= p.size() and i+1 <= m.size():
			create_row(m[i], p[i])
		elif i+1 > p.size() and i+1 <= m.size():
			create_row(m[i], "")
		elif i+1 <= p.size() and i+1 > m.size():
			create_row("", p[i])
		else:
			break
		i += 1
