extends 'res://addons/gut/test.gd'

const Helpers = preload("res://scripts/helpers.gd")
const window_height = 750
const hud_height = 50


func to_px_coord(coord: Vector2) -> Vector2:
		return Helpers.canon_to_px_coord(coord, window_height, hud_height)


func to_canon_coord(coord: Vector2) -> Vector2:
		return Helpers.px_to_canon_coord(coord, window_height, hud_height)


func test_assert_coord_1():
		assert_eq(to_px_coord(Vector2(0, 0)),
							Vector2(0, window_height))


func test_assert_coord_2():
		assert_eq(to_px_coord(Vector2(100, 100)),
							Vector2(window_height - hud_height, hud_height))
