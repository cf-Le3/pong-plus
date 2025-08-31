extends Node2D
signal close_game
@export var ball_scene: PackedScene
const ARENA_W = 1024
const ARENA_H = 512
const SCORE_MAX = 5
const BALLS_MAX = 5
var is_multiplayer: bool = true
var viewport_w
var viewport_h
var balls_spawned = 0
var ball_textures = [load("res://ball/ball1.png"), load("res://ball/ball2.png"), load("res://ball/ball3.png")]
var initial_angles = [45*PI/180, 60*PI/180, 75*PI/180]
var initial_angles_offsets = [0, PI/2, PI, 3*PI/2]
var score_player_1 = 0
var score_player_2 = 0
var close_game_enabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_w = get_viewport_rect().size.x
	viewport_h = get_viewport_rect().size.y
	$WallBounceHigh.global_position = Vector2(viewport_w/2, (viewport_h-ARENA_H)/2)
	$WallBounceLow.global_position = Vector2(viewport_w/2, viewport_h-(viewport_h-ARENA_H)/2)
	$WallGoalLeft.global_position = Vector2((viewport_w-ARENA_W)/2, viewport_h/2)
	$WallGoalRight.global_position = Vector2(viewport_w-(viewport_w-ARENA_W)/2, viewport_h/2)
	$Paddle1.global_position = Vector2((viewport_w-ARENA_W)/2+32, viewport_h/2)
	$Paddle1.init_x = $Paddle1.global_position.x
	$Paddle2.global_position = Vector2(viewport_w-(viewport_w-ARENA_W)/2-32, viewport_h/2)
	$Paddle2.init_x = $Paddle2.global_position.x
	if not is_multiplayer:
		$Paddle2.is_player_controlled = false
	$BallSpawn.global_position = Vector2(viewport_w/2, viewport_h/2)
	$Sprite2D.global_position = Vector2(viewport_w/2, viewport_h/2)
	$StartGameTimer.start()
	$GameStartSound.play()

func _input(event) -> void:
	if event is InputEventKey && close_game_enabled:
		close_game.emit()

func _on_wall_goal_left_ball_escaped() -> void:
	score_player_2 += 1
	$HUD.update_score(score_player_2, false)
	do_stuff_after_scoring()

func _on_wall_goal_right_ball_escaped() -> void:
	score_player_1 += 1
	$HUD.update_score(score_player_1, true)
	do_stuff_after_scoring()

func _on_start_game_timer_timeout() -> void:
	start_game()

func _on_ball_timer_timeout() -> void:
	spawn_ball()
	
func _on_close_game_timer_timeout() -> void:
	$HUD.show_end_game()
	close_game_enabled = true

func start_game() -> void:
	$HUD.show_score()
	spawn_ball()

func spawn_ball() -> void:
	if get_tree().get_nodes_in_group("balls").size() < BALLS_MAX:
		var ball = ball_scene.instantiate()
		ball.init_pos = $BallSpawn.global_position
		ball.init_dir = initial_angles[balls_spawned%3] + initial_angles_offsets.pick_random()
		ball.texture = ball_textures[balls_spawned%3]
		add_child(ball)
		balls_spawned += 1
		$BallTimer.start()
		
func do_stuff_after_scoring() -> void:
	if score_player_1 >= SCORE_MAX || score_player_2 >= SCORE_MAX:
		game_over()
	elif get_tree().get_nodes_in_group("balls").size() <= 1:
		spawn_ball()

func game_over() -> void:
	$BallTimer.stop()
	get_tree().call_group("paddles", "queue_free")
	get_tree().call_group("balls", "queue_free")
	$HUD.show_game_over(score_player_1, score_player_2)
	$CloseGameTimer.start()
	$GameOverSound.play()
