extends CanvasLayer
signal close_credits

func _ready() -> void:
	$BackButton.grab_focus()

func _on_back_button_pressed() -> void:
	close_credits.emit()
