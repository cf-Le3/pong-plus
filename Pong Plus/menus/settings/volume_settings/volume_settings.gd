class_name VolumeSettings
extends CanvasLayer
signal close_volume_settings

func _ready() -> void:
	$%MasterVolumeSlider.grab_focus()
	get_viewport().connect("gui_focus_changed", _on_viewport_gui_focus_changed)

func _on_viewport_gui_focus_changed(_node: Control):
	MenuSfx.play_select_sound()

func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() == $%SFXVolumeSlider:
		if event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right"):
			$SFXTestSound.play()

func _on_sfx_volume_slider_drag_ended(_value_changed: bool) -> void:
	$SFXTestSound.play()

func _on_default_button_pressed() -> void:
	$%MasterVolumeSlider.set_value(1.0)
	$%MusicVolumeSlider.set_value(0.5)
	$%SFXVolumeSlider.set_value(1.0)
	MenuSfx.play_cancel_sound()

func _on_confirm_button_pressed() -> void:
	close_volume_settings.emit()
	MenuSfx.play_confirm_sound()
