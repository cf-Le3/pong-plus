class_name VolumeSettings
extends CanvasLayer
signal close_volume_settings

func _ready() -> void:
	$%MasterVolumeSlider.grab_focus()

func _on_sfx_volume_slider_drag_ended(_value_changed: bool) -> void:
	$SFXTestSound.play()

func _on_default_button_pressed() -> void:
	$%MasterVolumeSlider.set_value(1.0)
	$%MusicVolumeSlider.set_value(0.5)
	$%SFXVolumeSlider.set_value(1.0)

func _on_confirm_button_pressed() -> void:
	close_volume_settings.emit()
