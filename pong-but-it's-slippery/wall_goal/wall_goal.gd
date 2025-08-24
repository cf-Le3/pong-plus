extends Area2D

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("balls"):
		body.queue_free()
