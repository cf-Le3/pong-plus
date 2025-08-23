extends CharacterBody2D
@export var is_player_1: bool
const VELOCITY_MAX = 250
const ACCELERATION = 5

func _ready() -> void:
	if not is_player_1:
		$Sprite2D.texture = preload("res://paddle/paddle2.png")

func _physics_process(delta: float) -> void:
	if (is_player_1 && Input.is_action_pressed("up_player1")) || (!is_player_1 && Input.is_action_pressed("up_player2")):
		velocity.y = max(velocity.y - ACCELERATION, -VELOCITY_MAX)
	elif (is_player_1 && Input.is_action_pressed("down_player1")) || (!is_player_1 && Input.is_action_pressed("down_player2")):
		velocity.y = min(velocity.y + ACCELERATION, VELOCITY_MAX)
	else:
		velocity.y = lerp(velocity.y, 0.0, 0.05)
	var collision = move_and_collide(velocity*delta)

	# Slow down faster upon colliding with walls to prevent "sticking".
	if collision && collision.get_collider().is_in_group("bounce_walls"):
		velocity.y = lerp(velocity.y, 0.0, 0.2)
