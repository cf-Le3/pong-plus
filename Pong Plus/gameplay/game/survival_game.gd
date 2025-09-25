class_name SurvivalGame
extends Game

const _MAX_HEALTH := 5

# Nodes
var _secondElapsedTimer: Timer
var _damageSound: AudioStreamPlayer2D

# Game state
var _health := _MAX_HEALTH
var _score := 0
var _time_elapsed := 0

func _ready() -> void:
	super()
	_initialize_unique_nodes()

func _initialize_unique_nodes() -> void:
	_secondElapsedTimer = Timer.new()
	_secondElapsedTimer.connect("timeout", _on_second_timer_timeout)
	add_child(_secondElapsedTimer)
	
	_damageSound = AudioStreamPlayer2D.new()
	_damageSound.stream = preload("res://gameplay/game/assets_audio/Boss hit 1.wav")
	_damageSound.bus = &"SFX"
	add_child(_damageSound)

func begin() -> void:
	_secondElapsedTimer.start()
	super()

func _on_second_timer_timeout() -> void:
	_time_elapsed += 1
	if _time_elapsed % 10 == 0:
		game_config.set_max_balls(game_config.get_max_balls()+1)

func _on_ball_spawner_spawned(ball: Ball) -> void:
	ball.connect("collided_with_paddle", _on_ball_collided_with_paddle)
	ball.connect("destroyed", _on_ball_destroyed)
	super(ball)

func _on_ball_collided_with_paddle(points: int) -> void:
	_update_score(points)

func _on_ball_destroyed(points: int) -> void:
	_update_score(points)
	_update_health(1)
	$ScoreSound.play()

func _update_score(points: int) -> void:
	_score += points
	$HUD.update_survival_score(_score)

func _update_health(hit_points: int) -> void:
	_health += hit_points
	$HUD.update_survival_health(_health)

func _on_wall_goal_right_ball_escaped(is_invincible: bool) -> void:
	if not is_invincible && _health > 0:
		_update_health(-1)
		_damageSound.play()
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
	$HUD.hide()
	super()
