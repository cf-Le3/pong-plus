extends CharacterBody2D
@export var is_player_1: bool

func _ready() -> void:
	if not is_player_1:
		$Sprite2D.texture = preload("res://paddle/paddle2.png")

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if (is_player_1 && Input.is_action_pressed("up_player1")) || (!is_player_1 && Input.is_action_pressed("up_player2")):
		velocity.y = -100
	elif (is_player_1 && Input.is_action_pressed("down_player1")) || (!is_player_1 && Input.is_action_pressed("down_player2")):
		velocity.y = 100
		
	move_and_slide()
