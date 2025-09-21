extends TextureButton

@export var button_type := ButtonSfxManager.SoundType.CONFIRM

func _on_pressed() -> void:
	ButtonSfxManager.play_press_sound(button_type)
