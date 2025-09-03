class_name Game
extends Node2D
signal close_game
@export var _ball_spawner_scene: PackedScene

# Configuration values
var config_is_multiplayer := true
var config_resize_enabled := true
var config_score_max := 5
var config_balls_max := 5
# var config_cpu_difficulty = null

# Session-specific
var _ball_spawner: BallSpawner
var score_player_1 := 0
var score_player_2 := 0
var close_game_enabled := false

# Arena dimensions
const ARENA_W := 1024
const ARENA_H := 512

func _ready() -> void:
	var viewport_w := get_viewport_rect().size.x
	var viewport_h := get_viewport_rect().size.y
	
	$WallBounceHigh.global_position = Vector2(viewport_w/2, (viewport_h-ARENA_H)/2)
	$WallBounceLow.global_position = Vector2(viewport_w/2, viewport_h-(viewport_h-ARENA_H)/2)
	$WallGoalLeft.global_position = Vector2((viewport_w-ARENA_W)/2, viewport_h/2)
	$WallGoalRight.global_position = Vector2(viewport_w-(viewport_w-ARENA_W)/2, viewport_h/2)
	$Sprite2D.global_position = Vector2(viewport_w/2, viewport_h/2)
	
	$Paddle1.global_position = Vector2((viewport_w-ARENA_W)/2+32, viewport_h/2)
	$Paddle1.init_x = $Paddle1.global_position.x
	$Paddle2.global_position = Vector2(viewport_w-(viewport_w-ARENA_W)/2-32, viewport_h/2)
	$Paddle2.init_x = $Paddle2.global_position.x
	if not config_is_multiplayer:
		$Paddle2.is_player_controlled = false
	
	_ball_spawner = _ball_spawner_scene.instantiate()
	_ball_spawner.enable_magic_balls = config_resize_enabled
	_ball_spawner.connect("spawned", _on_ball_spawner_spawned)
	_ball_spawner.global_position = Vector2(viewport_w/2, viewport_h/2)
	add_child(_ball_spawner)
	
	$StartGameTimer.start()
	$GameStartSound.play()

func _on_start_game_timer_timeout() -> void:
	$HUD.show_score()
	_ball_spawner.spawn_ball()

func _on_ball_spawner_spawned(ball: Ball) -> void:
	add_child(ball)
	$BallSpawnTimer.start()

func _on_ball_spawn_timer_timeout() -> void:
	if get_tree().get_nodes_in_group("balls").size() < config_balls_max:
		_ball_spawner.spawn_ball()

func _on_wall_goal_right_ball_escaped(can_score: bool) -> void:
	if can_score:
		score_player_1 += 1
		$HUD.update_score(score_player_1, true)
	do_stuff_after_scoring()

func _on_wall_goal_left_ball_escaped(can_score: bool) -> void:
	if can_score:
		score_player_2 += 1
		$HUD.update_score(score_player_2, false)
	do_stuff_after_scoring()

func do_stuff_after_scoring() -> void:
	if score_player_1 >= config_score_max || score_player_2 >= config_score_max:
		game_over()
	elif get_tree().get_nodes_in_group("balls").size() <= 1:
		_ball_spawner.spawn_ball()

func game_over() -> void:
	$BallSpawnTimer.stop()
	get_tree().call_group("paddles", "queue_free")
	get_tree().call_group("balls", "queue_free")
	$HUD.show_game_over(score_player_1, score_player_2)
	$CloseGameTimer.start()
	$GameOverSound.play()

func _on_close_game_timer_timeout() -> void:
	$HUD.show_end_game()
	close_game_enabled = true

func _input(event) -> void:
	if event is InputEventKey && close_game_enabled:
		close_game.emit()
