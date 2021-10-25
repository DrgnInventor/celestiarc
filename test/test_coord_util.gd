extends 'res://addons/gut/test.gd'


func test_assert_coord_1():
		assert_eq(CoordUtil.canon_to_px_coord(Vector2(0, 0)),
				  Vector2(0, CoordUtil.window_h))


func test_assert_coord_2():
		assert_eq(CoordUtil.canon_to_px_coord(Vector2(100, 100)),
				  Vector2(CoordUtil.window_h - CoordUtil.hud_h,
									CoordUtil.hud_h))


func test_two_way_conversion():
		"""When a coordinate is converted canon to px to canon, it should stay
		the same."""
		var v = Vector2(rand_range(-1000.0, 1000.0), rand_range(-1000.0, 1000.0))
		assert_eq(CoordUtil.px_to_canon_coord(CoordUtil.canon_to_px_coord(v)),
							v)
