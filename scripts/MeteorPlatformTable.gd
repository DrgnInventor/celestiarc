extends PanelContainer

const default_font = preload("res://resources/DefaultLabelFont.tres")
onready var wrapper = $MarginContainer/Wrapper


func _ready():
	## Example data
	create_row("", "Angle 1", "Angle 2")
	create_row("M1-P1 --> ", "0.70", "0.20")
	create_row("M2-P1 --> ", "0.90", "0.40")
	create_row("M3-P1 --> ", "1.35", "1.74")


func _create_label(text: String) -> Label:
	var label = Label.new()
	label.set("custom_fonts/font", default_font)
	label.text = text
	return label


func create_row(a: String, b: String, c: String) -> void:
	wrapper.add_child(_create_label(a))
	wrapper.add_child(_create_label(b))
	wrapper.add_child(_create_label(c))
