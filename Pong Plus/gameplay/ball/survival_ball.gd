class_name SurvivalBall
extends Ball

signal collided_with_paddle(points: int)
signal destroyed(points: int)

const _MAX_HEALTH := 6
const _POINTS_VALUE_HIGH = 3
const _POINTS_VALUE_MED = 2
const _POINTS_VALUE_LOW = 1

var _health := _MAX_HEALTH

func _handle_paddle_collision(paddle: Paddle) -> void:
	super(paddle)
	_deduct_health()
	if _health > 0:
		collided_with_paddle.emit(_calculate_points_value())
	else:
		#TODO: Play a unique animation. Pause physics and collisions before removing.
		destroyed.emit(_calculate_points_value())
		queue_free()
		
func _deduct_health() -> void:
	_health -= 1
	$HealthBar.value -= 1

func _calculate_points_value() -> int:
	if _health <= 0:
		return _POINTS_VALUE_HIGH
	elif _health <= 2:
		return _POINTS_VALUE_MED
	else:
		return _POINTS_VALUE_LOW
