extends CanvasLayer
signal new_game_singleplayer
signal new_game_multiplayer
signal view_help
signal view_credits

func _ready() -> void:
	delay_input()

func _on_wait_timer_timeout() -> void:
	$SinglePlayerButton.grab_focus()

func _on_single_player_button_pressed() -> void:
	new_game_singleplayer.emit()

func _on_multi_player_button_pressed() -> void:
	new_game_multiplayer.emit()

func _on_help_button_pressed() -> void:
	view_help.emit()

func _on_credits_button_pressed() -> void:
	view_credits.emit()

func delay_input() -> void:
	$WaitTimer.start()
	
func set_version(version: String) -> void:
	$VersionLabel.text = version
