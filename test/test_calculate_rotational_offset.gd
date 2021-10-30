extends 'res://addons/gut/test.gd'

const Helpers = preload("res://scripts/helpers.gd")


func assert_offsets(actual: Array, expected: Array) -> void:
		assert_almost_eq(actual[0], expected[0], 0.001)
		assert_almost_eq(actual[1], expected[1], 0.001)


func test_1() -> void:
	"""Check scenario when meteor is above origin and can collide."""
	assert_offsets(Helpers.calculate_rotational_offset(
				Vector2(18.182, 72.727),
				Vector2(125.307, 61.005),
				36.364,
				1.123,
				36.364
		), [2.2401, 0.5665])


func test_2() -> void:
	"""Check scenario when meteor is above origin and cannot collide."""
	assert_eq(Helpers.calculate_rotational_offset(
		Vector2(0.123, 61.389),
		Vector2(82.391, 2.320),
		10.0,
		4.321,
		34.921
	), [])


func test_3() -> void:
	"""Check scenario when meteor is below origin and cannot collide."""
	assert_eq(Helpers.calculate_rotational_offset(
		Vector2(2.020, 5.102),
		Vector2(123.200, 83.001),
		20.0,
		4.321,
		34.921
	), [])


func test_4() -> void:
	"""Check scenario when meteor is below origin and can collide."""
	assert_eq(
		len(Helpers.calculate_rotational_offset(
			Vector2(2.020, 68.102),
			Vector2(123.200, 83.001),
			20.0,
			4.321,
			34.921
			)),
		2)
