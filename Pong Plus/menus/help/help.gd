class_name Help
extends CanvasLayer

signal closed

func _ready() -> void:
	$%RightButton.grab_focus()

func _on_back_button_pressed() -> void:
	closed.emit()
