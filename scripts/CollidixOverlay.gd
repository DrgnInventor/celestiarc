extends Control

const IconifiedTextInfo = preload("res://scripts/IconifiedTextInfo.gd")
const ArrowsCounterClockwiseIcon = preload("res://assets/phospor-icons/arrows-counter-clockwise.png")
onready var table = $Panel/VBoxContainer/Content/CollidixTable


func gen_meteor_platform_table_data(meteors: Array, platforms: Array) -> Array:
	var res = []
	for p_i in platforms.size():
		for m_i in meteors.size():
			var offsets = Helpers.simple_calculate_rotational_offset(
				meteors[m_i],
				platforms[p_i]
			)
			var val_1 = ""
			var val_2 = ""
			match offsets.size():
				0:
					val_1 = "-"
					val_2 = "-"
				1:
					val_1 = Helpers.f_round_fmt(offsets[0])
					val_2 = "-"
				2:
					val_1 = Helpers.f_round_fmt(offsets[0])
					val_2 = Helpers.f_round_fmt(offsets[1])
				_:
					push_error("'offsets' is in wrong shape! ")

			var title = "M%s-P%s" % [m_i + 1, p_i + 1]
			res.append([title, val_1, val_2])

	return res


func _process_table_data(data: Array):
	for row in data:
		for cell in row:
			table.add_cell(cell)


func gen_table(meteor_arr: Array, platform_arr: Array) -> void:
	var col_info = [
		IconifiedTextInfo.new("Angle 1", ArrowsCounterClockwiseIcon),
		IconifiedTextInfo.new("Angle 2", ArrowsCounterClockwiseIcon),
	]
	table.setup_table(col_info)
	table.set_title("Angles")
	_process_table_data(
		gen_meteor_platform_table_data(meteor_arr, platform_arr)
	)
