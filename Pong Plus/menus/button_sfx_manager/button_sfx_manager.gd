extends Node

enum SoundType {
	CONFIRM,
	CANCEL
}

func play_select_sound() -> void:
	$SelectSound.play()
	
func play_press_sound(sound_type := SoundType.CONFIRM) -> void:
	if sound_type == SoundType.CONFIRM:
		$ConfirmSound.play()
	elif sound_type == SoundType.CANCEL:
		$CancelSound.play()
