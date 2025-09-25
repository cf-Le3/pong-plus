class_name SurvivalGame
extends Game

const _MAX_HEALTH := 5

# Nodes
var _secondElapsedTimer: Timer

# Game state
var _health := _MAX_HEALTH
var _score := 0
var _time_elapsed := 0

func _ready() -> void:
	super()
	_secondElapsedTimer = Timer.new()
	_secondElapsedTimer.connect("timeout", _on_second_timer_timeout)
	add_child(_secondElapsedTimer)

func begin() -> void:
	_secondElapsedTimer.start()
	super()

func _on_second_timer_timeout() -> void:
	_time_elapsed += 1
	if _time_elapsed % 10 == 0:
		game_config.set_max_balls(game_config.get_max_balls()+1)

func _on_wall_goal_right_ball_escaped(is_invincible: bool) -> void:
	if not is_invincible && _health > 0:
		_update_health(-1)
	_do_stuff_after_ball_escaped()

func _on_wall_goal_left_ball_escaped(is_invincible: bool) -> void:
	if not is_invincible && _health > 0:
		_update_health(-1)
	_do_stuff_after_ball_escaped()

func _do_stuff_after_ball_escaped() -> void:
	if _health == 0:
		_game_over()
	elif get_tree().get_nodes_in_group("balls").size() <= 1:
		_ball_spawner.spawn_ball()

func _compile_results() -> Results:
	var results = Results.new()
	results.set_score(_score)
	results.set_time_elapsed(_time_elapsed)
	return results

func _game_over() -> void:
	_secondElapsedTimer.stop()
	super()
