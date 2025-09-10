class_name Paddle
extends CharacterBody2D
enum Player {
	PLAYER_1,
	PLAYER_2,
	CPU_EASY,
	CPU_NORMAL,
	CPU_HARD
}
var player: Player
var _terminal_speed := 300.0
const _ACCELERATION := 10.0
const _SCALE_INCREMENT := 0.05
const _SPEED_INCREMENT := 25.0
const _SCALE_MIN := 0.75
const _SCALE_MAX := 1.25

func _physics_process(delta: float) -> void:
	if player == Player.PLAYER_1 || player == Player.PLAYER_2:
		_set_velocity_player()
	if player == Player.CPU_EASY || player == Player.CPU_NORMAL || player == Player.CPU_HARD:
		_set_velocity_ai()

	# Slow down faster upon colliding with walls to prevent "sticking".	
	var collision := move_and_collide(velocity*delta)	
	if collision && collision.get_collider().is_in_group("bounce_walls"):
		velocity.y = lerp(velocity.y, 0.0, 0.2)

func _set_velocity_player() -> void:
	if (player == Player.PLAYER_1 && Input.is_action_pressed("up_player1")) || (player == Player.PLAYER_2 && Input.is_action_pressed("up_player2")):
		_move_up()
	elif (player == Player.PLAYER_1 && Input.is_action_pressed("down_player1")) || (player == Player.PLAYER_2 && Input.is_action_pressed("down_player2")):
		_move_down()
	else:
		_slow_to_halt()
		
func _set_velocity_ai() -> void:
	var balls := get_tree().get_nodes_in_group("balls")

	if balls.size() > 0:
		var priority_ball: Ball = null
		var priority_attribute: float = INF
		
		for b: Ball in balls:
			if b.velocity.x > 0 && b.global_position.x < global_position.x:
				var attribute: float
				if player == Player.CPU_EASY:
					# EASY: Prioritize ball closest to paddle.
					attribute = global_position.distance_squared_to(b.global_position)
				else:
					# NORMAL: Prioitize ball horizontally closest to paddle.
					attribute = global_position.x - b.global_position.x
					# HARD: Prioritize ball that will reach paddle soonest.
					if player == Player.CPU_HARD:
						attribute = attribute / b.velocity.x
				if attribute < priority_attribute:
					priority_ball = b
					priority_attribute = attribute
					
		if priority_ball != null:
			# HARD: Align paddle such that the ball is between the two markers.
			if player == Player.CPU_HARD:
				if priority_ball.global_position.y < get_high_marker_position():
					_move_up()
				elif priority_ball.global_position.y > get_low_marker_position():
					_move_down()
				else:
					_slow_to_halt()
			# EASY / NORMAL: Align paddle and ball's global positions.
			else:
				if priority_ball.global_position.y < global_position.y:
					_move_up()
				elif priority_ball.global_position.y > global_position.y:
					_move_down()
				else:
					_slow_to_halt()
			return
	_slow_to_halt()
	
func _move_up() -> void:
	velocity.y = max(velocity.y - _ACCELERATION, -_terminal_speed)
	
func _move_down() -> void:
	velocity.y = min(velocity.y + _ACCELERATION, _terminal_speed)
	
func _slow_to_halt() -> void:
	velocity.y = lerp(velocity.y, 0.0, 0.05)

func get_high_marker_position() -> float:
	return $HighMarker2D.global_position.y
	
func get_low_marker_position() -> float:
	return $LowMarker2D.global_position.y

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
