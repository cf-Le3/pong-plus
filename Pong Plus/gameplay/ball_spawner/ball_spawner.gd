class_name BallSpawner
extends Node2D

signal spawned(ball: Ball)

@export var _ball_scene: PackedScene

var _initial_angles := [45*PI/180, 60*PI/180, 75*PI/180]
var _initial_angles_offsets := [0, PI/2, PI, 3*PI/2]
var _balls_spawned := 0
var colliding_balls_enabled: bool
var magic_balls_enabled: bool

const _TEXTURES_NORMAL: Array[Texture] = [preload("res://gameplay/ball_spawner/assets_textures/ball1.png"), preload("res://gameplay/ball_spawner/assets_textures/ball2.png"), preload("res://gameplay/ball_spawner/assets_textures/ball3.png")]
const _TEXTURES_MAGIC: Array[Texture] = [preload("res://gameplay/ball_spawner/assets_textures/ball_normal.png"), preload("res://gameplay/ball_spawner/assets_textures/ball_grow.png"), preload("res://gameplay/ball_spawner/assets_textures/ball_shrink.png")]
const _NO_UNIQUE_BALLS := 3

func spawn_ball() -> void:
	_balls_spawned += 1
	spawned.emit(_generate_ball())

func _generate_ball() -> Ball:
	var ball: Ball = _ball_scene.instantiate()
	var rand_index: int = randi_range(0, _NO_UNIQUE_BALLS-1)
	
	ball.init_pos = $BallSpawnPoint.global_position
	ball.init_dir = _initial_angles[_balls_spawned%_NO_UNIQUE_BALLS] + _initial_angles_offsets.pick_random()

	if colliding_balls_enabled:
		ball.enable_ball_collisions()

	if magic_balls_enabled:
		ball.magic_effect = Ball.Effect[Ball.Effect.keys()[rand_index]]
		ball.texture = _TEXTURES_MAGIC[rand_index]
	else:
		ball.magic_effect = Ball.Effect.NORMAL
		ball.texture = _TEXTURES_NORMAL[_balls_spawned%_NO_UNIQUE_BALLS]

	return ball
