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

func _on_wall_goal_right_ball_escaped(is_invincible: bool) -> void:
	_ball_escaped_common_logic(is_invincible)

func _on_wall_goal_left_ball_escaped(is_invincible: bool) -> void:
	_ball_escaped_common_logic(is_invincible)

func _ball_escaped_common_logic(is_invincible: bool) -> void:
	if not is_invincible && _health > 0:
		_health -= 1
		$HUD.update_survival_health(_health)
	_do_stuff_after_ball_escaped()

func _do_stuff_after_ball_escaped() -> void:
	if _health == 0:
		_game_over()
	elif get_tree().get_nodes_in_group("balls").size() <= 1:
		_ball_spawner.spawn_ball()

func _game_over() -> void:
	_secondElapsedTimer.stop()
	super()
