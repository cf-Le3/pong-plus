extends Area2D
signal ball_escaped()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("balls"):
		get_parent().remove_child(body)
		body.queue_free()
	ball_escaped.emit()
	$GoalSound.play()
