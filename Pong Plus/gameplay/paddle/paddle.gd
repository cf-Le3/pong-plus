extends CharacterBody2D
@export var is_player_1: bool
var is_player_controlled := true
var init_x: float
var _terminal_speed := 300.0
const _ACCELERATION := 10.0
const _SCALE_INCREMENT := 0.05
const _SPEED_INCREMENT := 25.0
const _SCALE_MIN := 0.75
const _SCALE_MAX := 1.25

func _physics_process(delta: float) -> void:
	if is_player_controlled:
		set_velocity_player()
	else:
		set_velocity_ai()
	
	var collision := move_and_collide(velocity*delta)
	
	# Slow down faster upon colliding with walls to prevent "sticking".
	if collision && collision.get_collider().is_in_group("bounce_walls"):
		velocity.y = lerp(velocity.y, 0.0, 0.2)
		
	if collision && collision.get_collider().is_in_group("balls"):
		var ball: Ball = collision.get_collider()
		if ball.can_collide_with_paddle:
			if ball.effect == Ball.Effect.GROW:
				grow()
			elif ball.effect == Ball.Effect.SHRINK:
				shrink()
	
	# Correct x-coordinate if paddle is shifted during collision.	
	if global_position.x != init_x:
		global_position.x = init_x

func set_velocity_player() -> void:
	if (is_player_1 && Input.is_action_pressed("up_player1")) || (!is_player_1 && Input.is_action_pressed("up_player2")):
		move_up()
	elif (is_player_1 && Input.is_action_pressed("down_player1")) || (!is_player_1 && Input.is_action_pressed("down_player2")):
		move_down()
	else:
		slow_to_halt()
		
func set_velocity_ai() -> void:
	var balls := get_tree().get_nodes_in_group("balls")
	
	if balls.size() > 0:
		var nearest_ball: Ball = null
		var nearest_distance: float = INF
		
		for b: Ball in balls:
			if b.velocity.x > 0 && b.global_position.x < global_position.x && b.can_collide_with_paddle:
				var distance: float = global_position.x - b.global_position.x
				if distance < nearest_distance:
					nearest_ball = b
					nearest_distance = distance

		if nearest_ball != null:
			if nearest_ball.global_position.y < global_position.y:
				move_up()
			elif nearest_ball.global_position.y > global_position.y:
				move_down()
			else:
				slow_to_halt()
			return
			
	slow_to_halt()
	
func move_up() -> void:
	velocity.y = max(velocity.y - _ACCELERATION, -_terminal_speed)
	
func move_down() -> void:
	velocity.y = min(velocity.y + _ACCELERATION, _terminal_speed)
	
func slow_to_halt() -> void:
	velocity.y = lerp(velocity.y, 0.0, 0.05)
	
func grow() -> void:
	if scale.y < _SCALE_MAX:
		scale.y += _SCALE_INCREMENT
		_terminal_speed -= _SPEED_INCREMENT
		$GrowSound.play()
		
func shrink() -> void:
	if scale.y > _SCALE_MIN:
		scale.y -= _SCALE_INCREMENT
		_terminal_speed += _SPEED_INCREMENT
		$ShrinkSound.play()
