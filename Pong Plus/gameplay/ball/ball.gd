class_name Ball
extends CharacterBody2D
enum Effect {
	NORMAL,
	GROW,
	SHRINK
}
var effect: Effect
var init_pos: Vector2
var init_dir: float
var texture: Texture
var _can_collide_with_other_balls := true
const _INIT_SPEED := 200.0
const _ACCELERATION_BY_PADDLE := Vector2(10.0, 10.0)
const _ACCELERATION_BY_BALL := Vector2(5.0, 5.0)

func _ready() -> void:
	global_position = init_pos
	velocity = Vector2(_INIT_SPEED, 0).rotated(init_dir)
	$Sprite2D.texture = texture
	
func _physics_process(delta: float) -> void:
	var collision := move_and_collide(velocity*delta)
	if collision:
		var collider := collision.get_collider()
		if collider.is_in_group("bounce_walls"):
			velocity.y = -1*velocity.y
			$WallHit.play()

func enable_ball_collisions():
	$Area2D.set_collision_mask_value(3, true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("paddles"):
		_handle_paddle_collision(body)
		_can_collide_with_other_balls = false

	elif body.is_in_group("balls") && _can_collide_with_other_balls && body != self:
		_handle_ball_collision(body)
		_randomly_tilt_velocity()
		$WallHit.play()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("paddles"):
		_can_collide_with_other_balls = true

func _handle_paddle_collision(paddle: Paddle) -> void:
		velocity.x = -1*velocity.x
		
		if (velocity.y > 0 && global_position.y < paddle.get_high_marker_position()) || (velocity.y < 0 && global_position.y > paddle.get_low_marker_position()):
			velocity.y = -1*velocity.y
			if effect == Effect.GROW:
				paddle.grow()
			elif effect == Effect.SHRINK:
				paddle.shrink()

		# Align acceleration vector with ball's velocity before adding to ball's velocity.
		velocity = velocity + _ACCELERATION_BY_PADDLE.rotated(velocity.angle())
		_randomly_tilt_velocity()
		$PaddleHit.play()				

func _handle_ball_collision(other_ball: Ball) -> void:
	if !_is_matching_x_polarity_with(other_ball) && !_is_matching_y_polarity_with(other_ball):
		if velocity.length() == other_ball.velocity.length():
			velocity.x = -1*velocity.x
			velocity.y = -1*velocity.y
		elif !_is_slower_than(other_ball):
			if abs(velocity.x) >= abs(velocity.y):
				velocity.y = -1*velocity.y
			else:
				velocity.x = -1*velocity.x
		else:
			if abs(other_ball.velocity.x) >= abs(other_ball.velocity.y):
				velocity.y = -1*velocity.y
			else:
				velocity.x = -1*velocity.x
	elif _is_matching_x_polarity_with(other_ball) && !_is_matching_y_polarity_with(other_ball):
		velocity.y = -1*velocity.y
	elif !_is_matching_x_polarity_with(other_ball) && _is_matching_y_polarity_with(other_ball):
		velocity.x = -1*velocity.x
	elif _is_matching_x_polarity_with(other_ball) && _is_matching_y_polarity_with(other_ball):
		var temp := Vector2(velocity.x, velocity.y)
		velocity = Vector2(other_ball.velocity.x, other_ball.velocity.y)
		other_ball.velocity = temp
		
	if _is_slower_than(other_ball):
		# Align acceleration vector with ball's velocity before adding to ball's velocity.
		velocity = velocity + _ACCELERATION_BY_BALL.rotated(velocity.angle())
	_randomly_tilt_velocity()
	$WallHit.play()

func _is_matching_x_polarity_with(other_ball: Ball) -> bool:
	return (velocity.x >= 0 && other_ball.velocity.x >= 0) || (velocity.x < 0 && other_ball.velocity.x < 0)

func _is_matching_y_polarity_with(other_ball: Ball) -> bool:
	return (velocity.y >= 0 && other_ball.velocity.y >= 0) || (velocity.y < 0 && other_ball.velocity.y < 0)

func _is_slower_than(other_ball: Ball) -> bool:
	return velocity.length() < other_ball.velocity.length()

func _randomly_tilt_velocity() -> void:
	# Randomly rotate velocity by -5 to 5 degrees.	
	velocity = velocity.rotated(randi_range(-5, 5)*PI/180)
