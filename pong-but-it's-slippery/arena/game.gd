extends Node2D
@export var ball_scene: PackedScene
var viewport_w
var viewport_h
var arena_w = 1024
var arena_h = 512
var balls_spawned = 0
var ball_textures = [load("res://ball/ball1.png"), load("res://ball/ball2.png"), load("res://ball/ball3.png")]
var initial_angles = [45*PI/180, 60*PI/180, 75*PI/180]
var initial_angles_offsets = [0, PI/2, PI, 3*PI/2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_w = get_viewport_rect().size.x
	viewport_h = get_viewport_rect().size.y
	$WallBounceHigh.global_position = Vector2(viewport_w/2, (viewport_h-arena_h)/2)
	$WallBounceLow.global_position = Vector2(viewport_w/2, viewport_h-(viewport_h-arena_h)/2)
	$WallGoalLeft.global_position = Vector2((viewport_w-arena_w)/2, viewport_h/2)
	$WallGoalRight.global_position = Vector2(viewport_w-(viewport_w-arena_w)/2, viewport_h/2)
	$Paddle1.global_position = Vector2((viewport_w-arena_w)/2+32, viewport_h/2)
	$Paddle2.global_position = Vector2(viewport_w-(viewport_w-arena_w)/2-32, viewport_h/2)
	$BallSpawn.global_position = Vector2(viewport_w/2, viewport_h/2)
	$Sprite2D.global_position = Vector2(viewport_w/2, viewport_h/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("balls").size() < 1:
		spawn_ball()

func _on_ball_timer_timeout() -> void:
	spawn_ball()

func spawn_ball() -> void:
	if get_tree().get_nodes_in_group("balls").size() < 3:
		var ball = ball_scene.instantiate()
		ball.init_pos = $BallSpawn.global_position
		ball.init_dir = initial_angles[balls_spawned%3] + initial_angles_offsets.pick_random()
		ball.texture = ball_textures[balls_spawned%3]
		add_child(ball)
		balls_spawned += 1
		$BallTimer.start()
