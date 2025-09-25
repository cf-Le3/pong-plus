class_name BallSpawner
extends Node2D

signal spawned(ball: Ball)

var _ball_scene: PackedScene = load("res://gameplay/ball/ball.tscn")
var _survival_ball_scene: PackedScene = load("res://gameplay/ball/survival_ball.tscn")
var _initial_angles := [45*PI/180, 60*PI/180, 75*PI/180]
var _initial_angles_offsets := [0, PI/2, PI, 3*PI/2]
var _balls_spawned := 0
var game_mode: Game.GameMode
var colliding_balls_enabled: bool

const _TEXTURES_NORMAL: Array[Texture] = [preload("res://gameplay/ball_spawner/assets_textures/ball_1.png"), preload("res://gameplay/ball_spawner/assets_textures/ball_2.png"), preload("res://gameplay/ball_spawner/assets_textures/ball_3.png")]
const _TEXTURES_PLAIN: Array[Texture] = [preload("res://gameplay/ball_spawner/assets_textures/ball_plain_1.png"), preload("res://gameplay/ball_spawner/assets_textures/ball_plain_2.png"), preload("res://gameplay/ball_spawner/assets_textures/ball_plain_3.png")]
const _TEXTURES_PROGRESS: Array[Texture] = [preload("res://gameplay/ball_spawner/assets_textures/progress_1.png"), preload("res://gameplay/ball_spawner/assets_textures/progress_2.png"), preload("res://gameplay/ball_spawner/assets_textures/progress_3.png")]
const _NO_UNIQUE_BALLS := 3

func spawn_ball() -> void:
	_balls_spawned += 1
	spawned.emit(_generate_ball())

func _generate_ball() -> Ball:
	var ball: Ball
	
	if game_mode != Game.GameMode.SURVIVAL:
		ball = _ball_scene.instantiate()
		ball.texture = _TEXTURES_NORMAL[_balls_spawned%_NO_UNIQUE_BALLS]
		if colliding_balls_enabled:
			ball.enable_ball_collisions()
			
	else:
		ball = _survival_ball_scene.instantiate()
		ball.texture = _TEXTURES_PLAIN[_balls_spawned%_NO_UNIQUE_BALLS]
		ball.texture_progress = _TEXTURES_PROGRESS[_balls_spawned%_NO_UNIQUE_BALLS]

	ball.init_pos = $BallSpawnPoint.global_position
	ball.init_dir = _initial_angles[_balls_spawned%_NO_UNIQUE_BALLS] + _initial_angles_offsets.pick_random()
	return ball
