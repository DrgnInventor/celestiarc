extends Control

onready var forecast = $Forecast


func forecast_mformater(data: Array):
	var mTable = []
	var format = "Position: %s; Velocity: %s"
	for meteor in data:
		var v = meteor.velocity
		var pos = CoordUtil.px_to_canon_coord(meteor.global_position)
		mTable.append(format % [pos, v])
	return mTable


func forecast_pformater(data: Array):
	var pTable = []
	var format = "Original Position: %s; Radius: %s"
	for platform in data:
		var pos = CoordUtil.px_to_canon_coord(platform.global_position)
		pos.y = stepify(pos.y, 1)
		pos.x = stepify(pos.x, 1)
		var radius = platform.radius
		pTable.append(format % [pos, radius])
	return pTable


func refresh_data(mData: Array, pData: Array) -> void:
	var m = forecast_mformater(mData)
	var p = forecast_pformater(pData)
	
	"""data: N sized array with arrays of 3 strings as children."""
	for child in forecast.get_children():
		child.queue_free()

	if m.size() >= p.size():
		for i in range(m.size()):
			if i <= p.size()-1:
				Helpers.create_row(forecast, m[i], "", p[i])
			else:
				Helpers.create_row(forecast, m[i], "", "")
	else:
		for i in range(p.size()):
			if i <= m.size()-1:
				Helpers.create_row(forecast, m[i], "", p[i])
			else:
				Helpers.create_row(forecast, "", "", p[i])
