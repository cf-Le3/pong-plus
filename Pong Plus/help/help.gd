extends CanvasLayer
signal close_help

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BackButton.grab_focus()

func _on_back_button_pressed() -> void:
	close_help.emit()
