class_name BallSpawner
extends Node2D
signal spawned(ball: Ball)
@export var _ball_scene: PackedScene
var _balls_spawned := 0
var _initial_angles := [45*PI/180, 60*PI/180, 75*PI/180]
var _initial_angles_offsets := [0, PI/2, PI, 3*PI/2]
var _textures : Array[Texture]
var colliding_balls_enabled := false
var magic_balls_enabled := false
const _NO_UNIQUE_BALLS := 3

func _ready() -> void:
	if magic_balls_enabled:
		_textures = [load("res://gameplay/ball_spawner/assets_textures/ball_normal.png"), load("res://gameplay/ball_spawner/assets_textures/ball_grow.png"), load("res://gameplay/ball_spawner/assets_textures/ball_shrink.png")]
	else:
		_textures = [load("res://gameplay/ball_spawner/assets_textures/ball1.png"), load("res://gameplay/ball_spawner/assets_textures/ball2.png"), load("res://gameplay/ball_spawner/assets_textures/ball3.png")]

func spawn_ball() -> void:
	_balls_spawned += 1
	spawned.emit(_generate_ball())

func _generate_ball() -> Ball:
	var ball: Ball = _ball_scene.instantiate()
	var random_index: int = randi_range(0, _NO_UNIQUE_BALLS-1)
	
	ball.init_pos = $BallSpawnPoint.global_position
	ball.init_dir = _initial_angles[_balls_spawned%_NO_UNIQUE_BALLS] + _initial_angles_offsets.pick_random()
	ball.texture = _textures[random_index]

	if colliding_balls_enabled:
		ball.enable_ball_collisions()

	if magic_balls_enabled:
		ball.effect = Ball.Effect[Ball.Effect.keys()[random_index]]
	else:
		ball.effect = Ball.Effect.NORMAL

	return ball
