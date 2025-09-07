extends CanvasLayer
signal new_game_singleplayer
signal new_game_multiplayer
signal view_help
signal view_credits
enum ActiveMenu {
	TITLE,
	PLAY
}
var _active_menu := ActiveMenu.TITLE

func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() == null:
		# Ensures that the top-most button is the one that is focused on
		# regardless of which key was first pressed.
		if event.is_action_pressed("ui_up"):
			if _active_menu == ActiveMenu.TITLE:
				$%SettingsButton.grab_focus()
			elif _active_menu == ActiveMenu.PLAY:
				$%VsPlayerButton.grab_focus()
		elif event.is_action_pressed("ui_down"):
			if _active_menu == ActiveMenu.TITLE:
				$%CreditsButton.grab_focus()
			elif _active_menu == ActiveMenu.PLAY:
				$%PlayBackButton.grab_focus()

func _on_play_button_pressed() -> void:
	if _active_menu == ActiveMenu.TITLE:
		$%VBoxTitleButtons.visible = false
		$%VBoxPlayButtons.visible = true
		_active_menu = ActiveMenu.PLAY

func _on_play_back_button_pressed() -> void:
	if _active_menu == ActiveMenu.PLAY:
		$%VBoxTitleButtons.visible = true
		$%VBoxPlayButtons.visible = false
		_active_menu = ActiveMenu.TITLE

func _on_vs_cpu_button_pressed() -> void:
	new_game_singleplayer.emit()

func _on_vs_player_button_pressed() -> void:
	new_game_multiplayer.emit()

func _on_endless_button_pressed() -> void:
	pass # Replace with function body.

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_help_button_pressed() -> void:
	view_help.emit()

func _on_credits_button_pressed() -> void:
	view_credits.emit()

func set_version(version: String) -> void:
	$%VersionLabel.text = version
