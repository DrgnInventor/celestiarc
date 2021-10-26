extends Control

onready var meteor_platform_table = $Panel/VBoxContainer/Content/MeteorPlatformTable


func get_meteor_platform_table():
	return meteor_platform_table


func set_table_data(data: Array) -> void:
	meteor_platform_table.refresh_data(data)
