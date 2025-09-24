class_name GameConfig

enum Difficulty {
	EASY,
	NORMAL,
	HARD
}

var _max_points := 5
var _max_balls := 5
var _difficulty := Difficulty.NORMAL
var _ball_collisions_enabled := false

const _MAX_POINTS_MIN := 1
const _MAX_POINTS_MAX := 9
const _MAX_BALLS_MIN := 1
const _MAX_BALLS_MAX := 9

func get_max_points() -> int:
	return _max_points
	
func get_max_balls() -> int:
	return _max_balls

func get_difficulty() -> Difficulty:
	return _difficulty
	
func get_ball_collisions_enabled() -> bool:
	return _ball_collisions_enabled

func set_max_points(max_points: int) -> void:
	if max_points >= _MAX_POINTS_MIN && max_points <= _MAX_POINTS_MAX:
		_max_points = max_points
	assert(_max_points >= _MAX_POINTS_MIN && _max_points <= _MAX_POINTS_MAX)
	
func set_max_balls(max_balls: int) -> void:
	if max_balls >= _MAX_BALLS_MIN && max_balls <= _MAX_BALLS_MAX:
		_max_balls = max_balls
	assert(_max_balls >= _MAX_BALLS_MIN && _max_balls <= _MAX_BALLS_MAX)

func set_difficulty(difficulty: Difficulty) -> void:
	_difficulty = difficulty
	
func set_ball_collisions_enabled(status: bool) -> void:
	_ball_collisions_enabled = status
