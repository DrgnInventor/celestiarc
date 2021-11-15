extends Control

const IconifiedTextInfo = preload("res://scripts/IconifiedTextInfo.gd")
const ArrowsCounterClockwiseIcon = preload("res://assets/phospor-icons/arrows-counter-clockwise.png")
var queued_lines = [] # Lines that are about to be printed to the shell
onready var table = $Panel/VBoxContainer/Content/Wrapper/Wrapper/CollidixTable
onready var calculate_button = $Panel/VBoxContainer/Content/Wrapper/CalculateButton
onready var shell_scroll = $Panel/VBoxContainer/Content/Wrapper/Wrapper/ShellBackground/ScrollContainer
onready var shell_label = $Panel/VBoxContainer/Content/Wrapper/Wrapper/ShellBackground/ScrollContainer/Text


func _ready() -> void:
	calculate_button.connect("pressed", self, "_calculate_button_pressed")
	table.visible = false
	shell_label.text = ""
	shell_write_line("$ ")


# Argument is not typed because the code won't be run otherwise
func _to_display_string(obj) -> String:
	match typeof(obj):
		TYPE_INT:
			return Helpers.f_round_fmt(float(obj))
		TYPE_REAL:
			return Helpers.f_round_fmt(obj)
		TYPE_VECTOR2:
			return Helpers.v2_round_fmt(obj)
		var type:
			push_error("Wrong type %s passed" % type)
			return "ERROR"


func _make_fmt_dict(meteor: Node, platform: Node) -> Dictionary:
	var old_values = {
		"m_x": meteor.canon_coord.x,
		"m_y": meteor.canon_coord.y,
		"m_v": meteor.velocity,
		"p_x": platform.canon_coord.x,
		"p_y": platform.canon_coord.y,
		"p_r": platform.radius,
		"p_omega": platform.rotational_velocity,
	}
	var new_values = {}
	for key in old_values:
		new_values[key] = _to_display_string(old_values[key])

	return new_values


func _calculate_button_pressed() -> void:
	for line in queued_lines:
		shell_write_line(line)
	queued_lines = []
	table.visible = true
	# There has to be a small wait time before scrolling. Most likely the lines
	# need some time to be printed and this delay does fine.
	yield(get_tree().create_timer(.1), "timeout")
	shell_scroll.set_v_scroll(999999) # Hack to scroll to the bottom


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
	queued_lines = shell_line_gen(meteor_arr, platform_arr)


func shell_write_line(line: String) -> void:
	"""Add a string and a newline to shell label."""
	shell_label.text += line + "\n"


func shell_line_gen(meteor_arr: Array, platform_arr: Array) -> Array:
	var lines = ["Reading data..."]
	for i in range(meteor_arr.size()):
		var prefix = "M%d_" % (i + 1)
		var m = meteor_arr[i]
		lines.append(prefix + "velocity = %s" % Helpers.f_round_fmt(m.velocity))
		lines.append(prefix + "position = %s"
			% Helpers.v2_round_fmt(m.canon_coord)
		)

	for i in range(platform_arr.size()):
		var prefix = "P%d_" % (i + 1)
		var p = platform_arr[i]
		lines.append(prefix + "origin_position = %s"
			% Helpers.v2_round_fmt(p.canon_coord)
		)
		lines.append(prefix + "radius = %s" % Helpers.f_round_fmt(p.radius))
		lines.append(prefix + "omega = %s"
			% Helpers.f_round_fmt(p.rotational_offset)
		)

	for i in range(platform_arr.size()):
		for j in range(meteor_arr.size()):
			var p = platform_arr[i]
			var m = meteor_arr[j]
			lines += [
				"Calculating M%d-P%d..." % [i + 1, j + 1],
				"Checking domain...",
				"abs(M_position.y - O_position.y) <= R",
				"abs(%s - %s) <= %s" % [
					Helpers.f_round_fmt(m.canon_coord.y),
					Helpers.f_round_fmt(p.canon_coord.y),
					Helpers.f_round_fmt(p.radius),
				],
			]

			var thetas = Helpers.simple_calculate_rotational_offset(m, p)
			var is_in_domain = abs(m.canon_coord.y - p.canon_coord.y) < p.radius
			lines.append(str(is_in_domain))

			var theta1_string = "theta1 = arcsin((M.y - O.y) / R) "\
				+ "- omega / M_velocity * ( O.x - M.position.x"\
				+ "+ sqrt((R - m.y + o.y) * (R + m.y - o.y)) )"

			var theta1_fmt = "theta1 = arcsin(({m_y} - {p_y}) / {p_r}) "\
				+ "- {p_omega} / {m_v} * ({p_x} - {m_x}"\
				+ "+ sqrt(({p_r} - {m_y} + {p_y}) * ({p_r} + {m_y} - {p_y})) )"

			var theta2_string = "theta2 = PI - arcsin((M.y - O.y) / R) "\
				+ "- omega / M_velocity * ( O.x - M.position.x"\
				+ "- sqrt((R - m.y + o.y) * (R + m.y - o.y)) )"

			var theta2_fmt = "theta2 = 3.1416 - arcsin(({m_y} - {p_y}) / {p_r}) "\
				+ "- {p_omega} / {m_v} * ({p_x} - {m_x}"\
				+ "- sqrt(({p_r} - {m_y} + {p_y}) * ({p_r} + {m_y} - {p_y})) )"\

			if is_in_domain:
				lines += [
					"Domain satisfied! Calculating theta...",
					theta1_string,
					theta1_fmt.format(_make_fmt_dict(m, p)),
					"Normalizing angle...",
					str(thetas[0]),
					theta2_string,
					theta2_fmt.format(_make_fmt_dict(m, p)),
					"Normalizing angle...",
					str(thetas[1]),
				]
			else:
				lines.append("Domain not satisfied! Aborting calculation...")

	# Post-calculation output
	lines += [
		"---",
		"Calculations are finished!",
		"$ ",
	]

	return lines
