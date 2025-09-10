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
const _INIT_SPEED := 200.0
const _ACCELERATION := Vector2(10.0, 10.0)

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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("paddles"):
		var paddle: Paddle = body
		velocity.x = -1*velocity.x
		
		if (velocity.y > 0 && global_position.y < paddle.get_high_marker_position()) || (velocity.y < 0 && global_position.y > paddle.get_low_marker_position()):
			velocity.y = -1*velocity.y
			if effect == Effect.GROW:
				paddle.grow()
			elif effect == Effect.SHRINK:
				paddle.shrink()

		# Align acceleration vector with ball's velocity before adding to ball's velocity.
		# Randomly rotate new velocity by -5 to 5 degrees.	
		velocity = (velocity + _ACCELERATION.rotated(velocity.angle())).rotated(randi_range(-5, 5)*PI/180)
		$PaddleHit.play()
