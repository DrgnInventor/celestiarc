extends Control

onready var m_forecast = $VBoxContainer/MForecast
onready var p_forecast = $VBoxContainer/PForecast


func meteor_formatter(data: Array):
	var m_table = []
	for meteor in data:
		var v = Helpers.f_round_fmt(meteor.velocity)
		var pos = Helpers.v2_round_fmt(
			CoordUtil.px_to_canon_coord(meteor.global_position)
		)
		m_table.append("Position: %s; Velocity: %s" % [pos, v])
	return m_table


func platform_formatter(data: Array):
	var p_table = []
	for platform in data:
		var pos = Helpers.v2_round_fmt(
			CoordUtil.px_to_canon_coord(platform.global_position)
		)
		var radius = Helpers.f_round_fmt(platform.radius)
		var omega = Helpers.f_round_fmt(platform.rotational_velocity)
		p_table.append(
			"Origin Position: %s; Radius: %s; Omega %s" % [pos, radius, omega]
		)
	return p_table


func refresh_data(m_data: Array, p_data: Array) -> void:
	"""data: N sized array with arrays of 3 strings as children."""
	var m = meteor_formatter(m_data)
	var p = platform_formatter(p_data)
	
	Helpers.kill_children(m_forecast)
	Helpers.kill_children(p_forecast)
	
	Helpers.create_row(m_forecast, ["Meteors: "])
	Helpers.create_row(p_forecast, ["Platforms: "])
	
	for obj in m:
		Helpers.create_row(m_forecast, [obj])
	for obj in p:
		Helpers.create_row(p_forecast, [obj])
	
