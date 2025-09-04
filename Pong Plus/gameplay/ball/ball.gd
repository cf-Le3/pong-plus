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
var can_collide_with_paddle := true
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
			
		elif collider.is_in_group("paddles"):
			if can_collide_with_paddle:
				velocity.x = -1*velocity.x
				var collider_shape := collision.get_collider_shape()
				
				if velocity.y > 0 && collider_shape == collider.get_node("TopCollisionShape2D"):
					velocity.y = -1*velocity.y
					
				elif velocity.y < 0 && collider_shape == collider.get_node("BottomCollisionShape2D"):
					velocity.y = -1*velocity.y
				
				# Align acceleration vector with ball's velocity before adding to ball's velocity.
				# Randomly rotate new velocity by -5 to 5 degrees.
				velocity = (velocity + _ACCELERATION.rotated(velocity.angle())).rotated(randi_range(-5, 5)*PI/180)
				_disable_paddle_collision()
				$PaddleHit.play()

func _disable_paddle_collision():
	can_collide_with_paddle = false
	$HitTimer.start()

func _on_hit_timer_timeout() -> void:
	can_collide_with_paddle = true
