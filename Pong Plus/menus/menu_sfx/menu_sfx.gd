extends Node

func play_select_sound() -> void:
	$SelectSound.play()
	
func play_confirm_sound() -> void:
	$ConfirmSound.play()
	
func play_cancel_sound() -> void:
	$CancelSound.play()
