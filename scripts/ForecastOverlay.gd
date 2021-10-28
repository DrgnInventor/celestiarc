extends Control

onready var forecaster = $Panel/VBoxContainer/Content/Forecaster


func get_forecast_table():
	return forecaster

func set_table_data(mData: Array, pData: Array) -> void:
	forecaster.refresh_data(mData, pData)
