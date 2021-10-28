extends Control

onready var mforecast = $HBoxContainer/MForecast
onready var pforecast = $HBoxContainer/PForecast

func forecast_mformater(data: Array):
	var mTable = []
	var format = "Position: %s; Velocity: %s"
	for meteor in data:
		var v = stepify(meteor.velocity, Globals.number_rounder)
		var pos = CoordUtil.px_to_canon_coord(meteor.global_position)
		pos.y = stepify(pos.y, Globals.number_rounder)
		pos.x = stepify(pos.x, Globals.number_rounder)
		mTable.append(format % [pos, v])
	return mTable


func forecast_pformater(data: Array):
	var pTable = []
	var format = "Original Position: %s; Radius: %s"
	for platform in data:
		var pos = CoordUtil.px_to_canon_coord(platform.global_position)
		pos.y = stepify(pos.y, Globals.number_rounder)
		pos.x = stepify(pos.x, Globals.number_rounder)
		var radius = platform.radius
		pTable.append(format % [pos, radius])
	return pTable


func refresh_data(mData: Array, pData: Array) -> void:
	var m = forecast_mformater(mData)
	var p = forecast_pformater(pData)
	
	"""data: N sized array with arrays of 3 strings as children."""
	Helpers.kill_children(mforecast)
	Helpers.kill_children(pforecast)
	
	Helpers.create_row(mforecast, ["Meteors: "])
	Helpers.create_row(pforecast, ["Platforms: "])
	
	for obj in m:
		Helpers.create_row(mforecast, [obj])
	for obj in p:
		Helpers.create_row(pforecast, [obj])
	
