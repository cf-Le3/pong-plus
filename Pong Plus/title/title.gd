extends CanvasLayer
signal new_game_multiplayer
signal view_help

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WaitTimer.start()

func _on_wait_timer_timeout() -> void:
	$MultiPlayerButton.grab_focus()

func _on_multi_player_button_pressed() -> void:
	new_game_multiplayer.emit()

func _on_help_button_pressed() -> void:
	view_help.emit()
