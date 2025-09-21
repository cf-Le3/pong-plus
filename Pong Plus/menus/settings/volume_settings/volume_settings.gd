class_name VolumeSettings
extends CanvasLayer

signal closed(volume_config: VolumeConfig)

var volume_config := VolumeConfig.new()

func _ready() -> void:
	$%MasterVolumeSlider.value = volume_config.get_master_vol_value()
	$%MusicVolumeSlider.value = volume_config.get_music_vol_value()
	$%SFXVolumeSlider.value = volume_config.get_sfx_vol_value()
	$%MasterVolumeSlider.grab_focus()

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
	ButtonSfxManager.play_cancel_sound()

func _on_confirm_button_pressed() -> void:
	volume_config.set_master_vol_value($%MasterVolumeSlider.value)
	volume_config.set_music_vol_value($%MusicVolumeSlider.value)
	volume_config.set_sfx_vol_value($%SFXVolumeSlider.value)
	closed.emit(volume_config)
	ButtonSfxManager.play_confirm_sound()
