extends CanvasLayer
signal new_game_multiplayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MultiPlayerButton.grab_focus()

func _on_multi_player_button_pressed() -> void:
	new_game_multiplayer.emit()
