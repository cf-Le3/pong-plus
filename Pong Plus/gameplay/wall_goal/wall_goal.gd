extends Area2D
signal ball_escaped()
var is_invincible := false

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("balls"):
		body.queue_free()
	ball_escaped.emit()
	if not is_invincible:
		enable_invincibility()
		$GoalSound.play()

func enable_invincibility() -> void:
	is_invincible = true
	$InvincibilityTimer.start()

func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
