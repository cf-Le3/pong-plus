class_name SurvivalGame
extends Game

const MAX_HEALTH := 5

# Nodes
var secondTimer: Timer

# Game state
var _health := MAX_HEALTH
var _score := 0
var _time_elapsed := 0

func _ready() -> void:
	super()
	secondTimer = Timer.new()
	secondTimer.connect("timeout", _on_second_timer_timeout)
	_debug_print_health()

func begin() -> void:
	secondTimer.start()
	super()

func _on_second_timer_timeout() -> void:
	_time_elapsed += 1

func _on_wall_goal_right_ball_escaped(can_score: bool) -> void:
	print("DEBUG | Ball escaped via right wall!")
	_ball_escaped_common_logic()

func _on_wall_goal_left_ball_escaped(can_score: bool) -> void:
	print("DEBUG | Ball escaped via left wall!")
	_ball_escaped_common_logic()

func _ball_escaped_common_logic() -> void:
	if _health > 0:
		_health -= 1
	_debug_print_health()
	_do_stuff_after_ball_escaped()

func _do_stuff_after_ball_escaped() -> void:
	if _health == 0:
		_game_over()
	elif get_tree().get_nodes_in_group("balls").size() <= 1:
		_ball_spawner.spawn_ball()

func _debug_print_health() -> void:
	print("DEBUG | HP: " + str(_health))

func _game_over() -> void:
	secondTimer.stop()
	print("DEBUG | Time elapsed: " + str(_time_elapsed))
	super()
