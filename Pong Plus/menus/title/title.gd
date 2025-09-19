class_name Title
extends CanvasLayer

signal new_game_singleplayer
signal new_game_multiplayer
signal open_volume_settings
signal open_game_settings
signal view_license
signal view_help
signal view_credits

enum ActiveMenu {
	TITLE,
	PLAY,
	SETTINGS
}

var _active_menu := ActiveMenu.TITLE

func _ready() -> void:
	get_viewport().connect("gui_focus_changed", _on_viewport_gui_focus_changed)

func set_version(version: String) -> void:
	$%VersionLabel.text = version

func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() == null:
		# Ensures that the top-most button is the one that is focused on
		# regardless of which key was first pressed.
		if event.is_action_pressed("ui_up"):
			if _active_menu == ActiveMenu.TITLE:
				$%SettingsButton.grab_focus()
			elif _active_menu == ActiveMenu.PLAY:
				$%VsPlayerButton.grab_focus()
			elif _active_menu == ActiveMenu.SETTINGS:
				$%GameSettingsButton.grab_focus()
		elif event.is_action_pressed("ui_down"):
			if _active_menu == ActiveMenu.TITLE:
				$%CreditsButton.grab_focus()
			elif _active_menu == ActiveMenu.PLAY:
				$%PlayBackButton.grab_focus()
			elif _active_menu == ActiveMenu.SETTINGS:
				$%SettingsBackButton.grab_focus()

func _on_viewport_gui_focus_changed(_node: Control) -> void:
	MenuSfx.play_select_sound()

func switch_menu(target_menu: ActiveMenu) -> void:
	if target_menu == ActiveMenu.TITLE:
		if _active_menu == ActiveMenu.PLAY:
			$%VBoxPlayButtons.visible = false
		elif _active_menu == ActiveMenu.SETTINGS:
			$%VBoxSettingsButtons.visible = false
		$%VBoxTitleButtons.visible = true
	else:
		$%VBoxTitleButtons.visible = false
		if target_menu == ActiveMenu.PLAY:
			$%VBoxPlayButtons.visible = true
		elif target_menu == ActiveMenu.SETTINGS:
			$%VBoxSettingsButtons.visible = true
	_active_menu = target_menu

func _on_play_button_pressed() -> void:
	switch_menu(ActiveMenu.PLAY)
	MenuSfx.play_confirm_sound()

func _on_play_back_button_pressed() -> void:
	switch_menu(ActiveMenu.TITLE)
	MenuSfx.play_cancel_sound()

func _on_vs_cpu_button_pressed() -> void:
	new_game_singleplayer.emit()
	MenuSfx.play_confirm_sound()

func _on_vs_player_button_pressed() -> void:
	new_game_multiplayer.emit()
	MenuSfx.play_confirm_sound()

func _on_endless_button_pressed() -> void:
	pass # Replace with function body.

func _on_settings_button_pressed() -> void:
	switch_menu(ActiveMenu.SETTINGS)
	MenuSfx.play_confirm_sound()

func _on_settings_back_button_pressed() -> void:
	switch_menu(ActiveMenu.TITLE)
	MenuSfx.play_cancel_sound()

func _on_volume_settings_button_pressed() -> void:
	open_volume_settings.emit()
	MenuSfx.play_confirm_sound()

func _on_game_settings_button_pressed() -> void:
	open_game_settings.emit()
	MenuSfx.play_confirm_sound()

func _on_license_button_pressed() -> void:
	view_license.emit()
	MenuSfx.play_confirm_sound()

func _on_help_button_pressed() -> void:
	view_help.emit()
	MenuSfx.play_confirm_sound()

func _on_credits_button_pressed() -> void:
	view_credits.emit()
	MenuSfx.play_confirm_sound()
