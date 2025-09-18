class_name BallSpawner
extends Node2D

signal spawned(ball: Ball)

@export var _ball_scene: PackedScene

var _initial_angles := [45*PI/180, 60*PI/180, 75*PI/180]
var _initial_angles_offsets := [0, PI/2, PI, 3*PI/2]
var _textures_normal: Array[Texture] = [preload("res://gameplay/ball_spawner/assets_textures/ball1.png"), preload("res://gameplay/ball_spawner/assets_textures/ball2.png"), preload("res://gameplay/ball_spawner/assets_textures/ball3.png")]
var _textures_magic: Array[Texture] = [preload("res://gameplay/ball_spawner/assets_textures/ball_normal.png"), preload("res://gameplay/ball_spawner/assets_textures/ball_grow.png"), preload("res://gameplay/ball_spawner/assets_textures/ball_shrink.png")]
var _balls_spawned := 0
var _colliding_balls_enabled: bool
var _magic_balls_enabled: bool

const _NO_UNIQUE_BALLS := 3

func configure_ball_behaviors(colliding_balls_enabled: bool, magic_balls_enabled: bool) -> void:
	_colliding_balls_enabled = colliding_balls_enabled
	_magic_balls_enabled = magic_balls_enabled

func spawn_ball() -> void:
	_balls_spawned += 1
	spawned.emit(_generate_ball())

func _generate_ball() -> Ball:
	var ball: Ball = _ball_scene.instantiate()
	var rand_index: int = randi_range(0, _NO_UNIQUE_BALLS-1)
	
	ball.init_pos = $BallSpawnPoint.global_position
	ball.init_dir = _initial_angles[_balls_spawned%_NO_UNIQUE_BALLS] + _initial_angles_offsets.pick_random()

	if _colliding_balls_enabled:
		ball.enable_ball_collisions()

	if _magic_balls_enabled:
		ball.set_magic_effect(Ball.Effect[Ball.Effect.keys()[rand_index]])
		ball.init_texture = _textures_magic[rand_index]
	else:
		ball.set_magic_effect(Ball.Effect.NORMAL)
		ball.init_texture = _textures_normal[_balls_spawned%_NO_UNIQUE_BALLS]

	return ball
