extends Control

onready var forecast = $Forecast


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

func checkCase(m: Array, p: Array, i: int):
	var mlen = m.size() -1
	var plen = p.size() -1
	if i <= mlen and i <= plen:
		return 0
	elif i > plen and i < mlen:
		return 1
	elif i > mlen and i < plen:
		return 2
	else:
		return 3


func refresh_data(mData: Array, pData: Array) -> void:
	var m = forecast_mformater(mData)
	var p = forecast_pformater(pData)
	var i = 0
	"""data: N sized array with arrays of 3 strings as children."""
	for child in forecast.get_children():
		child.queue_free()
	while true:
		match checkCase(m, p, i):
			0:
				Helpers.create_row(forecast, m[i], "", p[i])
			1:
				Helpers.create_row(forecast, m[i], "", "")
			2:	
				Helpers.create_row(forecast, "", "", p[i])
			3:
				break
		i += 1
