class_name GameConfig
var _max_points := 5
var _max_balls := 5

func set_max_points(max_points: int) -> void:
	_max_points = max_points
	
func set_max_balls(max_balls: int) -> void:
	_max_balls = max_balls

func get_max_points() -> int:
	return _max_points
	
func get_max_balls() -> int:
	return _max_balls
