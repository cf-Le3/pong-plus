extends CharacterBody2D
var init_pos: Vector2
var init_dir: float
var texture: Texture
var can_collide_with_paddle = true
const INIT_SPEED = 200.0
const ACCELERATION = Vector2(10.0, 10.0)

func _ready() -> void:
	global_position = init_pos
	velocity = Vector2(INIT_SPEED, 0).rotated(init_dir)
	$Sprite2D.texture = texture
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity*delta)
	if collision: 
		if collision.get_collider().is_in_group("bounce_walls"):
			velocity.y = -1*velocity.y
			$WallHit.play()
		elif collision.get_collider().is_in_group("paddles"):
			if can_collide_with_paddle:
				velocity.x = -1*velocity.x
				velocity = (velocity + ACCELERATION.rotated(velocity.angle())).rotated(randi_range(-5, 5)*PI/180)
				can_collide_with_paddle = false
				$HitTimer.start()
				$PaddleHit.play()

func _on_hit_timer_timeout() -> void:
	can_collide_with_paddle = true
