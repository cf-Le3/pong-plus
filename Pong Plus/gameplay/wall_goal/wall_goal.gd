extends Area2D

signal ball_escaped(is_invincible: bool)

var _is_invincible := false

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("balls"):
		body.queue_free()
	ball_escaped.emit(_is_invincible)
	if not _is_invincible:
		enable_invincibility()

func enable_invincibility() -> void:
	_is_invincible = true
	$InvincibilityTimer.start()

func _on_invincibility_timer_timeout() -> void:
	_is_invincible = false
