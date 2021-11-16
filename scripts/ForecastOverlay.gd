extends Control

const IconifiedTextInfo = preload("res://scripts/IconifiedTextInfo.gd")
const ArrowRightIcon = preload("res://assets/phospor-icons/arrow-right.png")
const MapPinLineIcon = preload("res://assets/phospor-icons/map-pin-line.png")
const ArrowsOutSimpleIcon = preload("res://assets/phospor-icons/arrows-out-simple.png")
const ArrowsCounterClockwiseIcon = preload("res://assets/phospor-icons/arrows-counter-clockwise.png")
onready var meteor_table = $Panel/VBoxContainer/Content/Wrapper/MeteorTable
onready var platform_table = $Panel/VBoxContainer/Content/Wrapper/PlatformTable


func _process_table_data(table: Node, data: Array) -> void:
	for row in data:
		for cell in row:
			table.add_cell(cell)


func gen_meteor_data(meteor_arr: Array) -> Array:
	var data = []
	for i in range(meteor_arr.size()):
		var meteor = meteor_arr[i]
		var v = Helpers.f_round_fmt(meteor.velocity)
		var pos = Helpers.v2_round_fmt(
			CoordUtil.px_to_canon_coord(meteor.global_position)
		)
		data.append(["M%s" % (i + 1), pos, v])
	return data


func gen_platform_data(platform_arr: Array):
	var data = []
	for i in range(platform_arr.size()):
		var platform = platform_arr[i]
		var pos = Helpers.v2_round_fmt(
			CoordUtil.px_to_canon_coord(platform.global_position)
		)
		var radius = Helpers.f_round_fmt(platform.radius)
		var omega = Helpers.f_round_fmt(platform.rotational_velocity)
		data.append(["P%s" % (i + 1) ,pos, radius, omega])
	return data


func gen_meteor_table(meteor_arr: Array) -> void:
	var col_info = [
		IconifiedTextInfo.new("Position", MapPinLineIcon),
		IconifiedTextInfo.new("Velocity", ArrowRightIcon),
	]
	meteor_table.setup_table(col_info)
	meteor_table.set_title("Meteors")
	_process_table_data(meteor_table, gen_meteor_data(meteor_arr))


func gen_platform_table(platform_arr: Array) -> void:
	var col_info = [
		IconifiedTextInfo.new("Origin position", MapPinLineIcon),
		IconifiedTextInfo.new("Radius", ArrowsOutSimpleIcon),
		IconifiedTextInfo.new("Omega", ArrowsCounterClockwiseIcon),
	]
	platform_table.setup_table(col_info)
	platform_table.set_title("Platforms")
	_process_table_data(platform_table, gen_platform_data(platform_arr))


func gen_tables(meteor_arr: Array, platform_arr: Array) -> void:
	gen_meteor_table(meteor_arr)
	gen_platform_table(platform_arr)
