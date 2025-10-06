class_name Credits
extends CanvasLayer

signal closed

func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() == null:
		$%BackButton.grab_focus()
	if event.is_action("ui_up"):
		$%ScrollContainer.set_v_scroll($%ScrollContainer.get_v_scroll()-10)
	elif event.is_action("ui_down"):
		$%ScrollContainer.set_v_scroll($%ScrollContainer.get_v_scroll()+10)

func _on_back_button_pressed() -> void:
	closed.emit()
