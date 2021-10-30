extends 'res://addons/gut/test.gd'

const Helpers = preload("res://scripts/helpers.gd")


func returns(input: float, expected_output: float) -> void:
	assert_almost_eq(Helpers.normalize_angle(input), expected_output, 0.001)


func test_normal_angles() -> void:
	returns(0.000, 0.000)
	returns(3.1416, 3.1416)
	returns(6.2832, 0.000)
	returns(4.137, 4.137)


func test_negative_big_angles() -> void:
	returns(20.0841, 1.2345)
	returns(132.7126, 0.7654)


func test_negative_angles() -> void:
	returns(-1.2345, 5.0487)
	returns(-75.3984, 0.000)
	returns(-103.4022, 3.4122)
