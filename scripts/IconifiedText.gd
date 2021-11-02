tool
extends VBoxContainer

export(Texture) var icon = preload("res://icon.png") setget set_icon
export(String) var text = "Sample Title" setget set_text
var is_ready = false
onready var texture = $TextureRect
onready var label = $Label


func _ready() -> void:
	is_ready = true # Needed for tool
	refresh()


func refresh() -> void:
	if is_ready:
		label.text = text
		texture.texture = icon
		# The node will have size, this line will shrink the node as much
		# as possible, while respecting the inner node layout
		self.rect_size = Vector2(0,0)


func set_icon(value: Texture) -> void:
	icon = value
	refresh()


func set_text(value: String) -> void:
	text = value
	refresh()
