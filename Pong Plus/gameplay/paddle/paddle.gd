extends CharacterBody2D
@export var is_player_1: bool
var is_player_controlled: bool = true
var init_x: float
const SPEED_MAX = 300
const ACCELERATION = 10

func _physics_process(delta: float) -> void:
	if is_player_controlled:
		set_velocity_player()
	else:
		set_velocity_ai()
	var collision = move_and_collide(velocity*delta)
	
	# Slow down faster upon colliding with walls to prevent "sticking".
	if collision && collision.get_collider().is_in_group("bounce_walls"):
		velocity.y = lerp(velocity.y, 0.0, 0.2)
	
	# Correct horizontal shift of paddles upon colliding with balls.	
	if collision && collision.get_collider().is_in_group("balls"):
		if global_position.x != init_x:
			global_position.x = init_x

func set_velocity_player() -> void:
	if (is_player_1 && Input.is_action_pressed("up_player1")) || (!is_player_1 && Input.is_action_pressed("up_player2")):
		velocity.y = max(velocity.y - ACCELERATION, -SPEED_MAX)
	elif (is_player_1 && Input.is_action_pressed("down_player1")) || (!is_player_1 && Input.is_action_pressed("down_player2")):
		velocity.y = min(velocity.y + ACCELERATION, SPEED_MAX)
	else:
		velocity.y = lerp(velocity.y, 0.0, 0.05)
		
func set_velocity_ai() -> void:
	var balls = get_tree().get_nodes_in_group("balls")
	if balls.size() > 0:
		var nearest_ball: CharacterBody2D = null
		var nearest_distance: float = INF
		for b in balls:
			if b.velocity.x > 0 && b.global_position.x < global_position.x:
				var distance: float = global_position.x - b.global_position.x
				if distance < nearest_distance:
					nearest_ball = b
					nearest_distance = distance
		if nearest_ball != null:
			if nearest_ball.global_position.y < global_position.y:
				velocity.y = max(velocity.y - ACCELERATION, -SPEED_MAX)
			elif nearest_ball.global_position.y > global_position.y:
				velocity.y = min(velocity.y + ACCELERATION, SPEED_MAX)
			else:
				velocity.y = lerp(velocity.y, 0.0, 0.05)
			return
	velocity.y = lerp(velocity.y, 0.0, 0.05)
