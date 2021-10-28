extends Control

onready var m_forecast = $HBoxContainer/MForecast
onready var p_forecast = $HBoxContainer/PForecast

func forecast_mformater(data: Array):
	var m_Table = []
	var format = "Position: %s; Velocity: %s"
	for meteor in data:
		var v = stepify(meteor.velocity, Globals.number_rounder)
		var pos = CoordUtil.px_to_canon_coord(meteor.global_position)
		pos.y = stepify(pos.y, Globals.number_rounder)
		pos.x = stepify(pos.x, Globals.number_rounder)
		m_Table.append(format % [pos, v])
	return m_Table


func forecast_pformater(data: Array):
	var p_table = []
	var format = "Original Position: %s; Radius: %s"
	for platform in data:
		var pos = CoordUtil.px_to_canon_coord(platform.global_position)
		pos.y = stepify(pos.y, Globals.number_rounder)
		pos.x = stepify(pos.x, Globals.number_rounder)
		var radius = platform.radius
		p_table.append(format % [pos, radius])
	return p_table


func refresh_data(mData: Array, pData: Array) -> void:
	var m = forecast_mformater(mData)
	var p = forecast_pformater(pData)
	
	"""data: N sized array with arrays of 3 strings as children."""
	Helpers.kill_children(m_forecast)
	Helpers.kill_children(p_forecast)
	
	Helpers.create_row(m_forecast, ["Meteors: "])
	Helpers.create_row(p_forecast, ["Platforms: "])
	
	for obj in m:
		Helpers.create_row(m_forecast, [obj])
	for obj in p:
		Helpers.create_row(p_forecast, [obj])
	
