extends Control

const IconifiedText = preload("res://scenes/IconifiedText.tscn")
const IconifiedTextInfo = preload("res://scripts/IconifiedTextInfo.gd")
var item_row_count = 0 # How many rows (except title row) are there
onready var table_grid = $TableGrid
onready var table_title = $Title


func _ready() -> void:
	var cols = []
	for title in ["Prop Foo", "Prop Bar", "Prop Baz", "Prop Qux"]:
		cols.append(IconifiedTextInfo.new(title, null))

	setup_table(cols)
	for i in range(20):
		add_cell("VAL-%s" % i)


func setup_table(col_info_array: Array) -> void:
	for col_info in col_info_array:
		if not col_info is IconifiedTextInfo:
			push_error("'%s' is not IconifiedTextInfo!" % col_info)

	Helpers.kill_children(table_grid)
	table_grid.columns = col_info_array.size() + 1
	table_grid.add_child(MarginContainer.new()) # Blank cell
	for info in col_info_array:
		var label = IconifiedText.instance()
		label.set_text(info.title)
		if info.icon:
			label.set_icon(info.icon)
		table_grid.add_child(label)


func set_title(value: String) -> void:
	table_title.text = value


func add_cell(value: String) -> void:
	table_grid.add_child(Helpers._create_label(value))


func get_column_count() -> int:
	return table_grid.columns
