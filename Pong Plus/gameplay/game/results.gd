class_name Results

var _player_1_won := true
var _score := 0
var _time_elapsed := 0

func get_player_1_won() -> bool:
	return _player_1_won

func get_score() -> int:
	return _score

func get_time_elapsed() -> int:
	return _time_elapsed

func set_player_1_won(player_1_won: bool) -> void:
	_player_1_won = player_1_won
	
func set_score(score: int) -> void:
	_score = score
	
func set_time_elapsed(time_elapsed: int) -> void:
	_time_elapsed = time_elapsed 
