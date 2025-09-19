extends CanvasLayer

const TEXT_READY := "READY"
const TEXT_PAUSED := "PAUSED"
const TEXT_PLAYER_WIN := "YOU WIN"
const TEXT_CPU_WIN := "YOU LOSE"
const TEXT_PLAYER_1_WIN := "PLAYER 1 WINS"
const TEXT_PLAYER_2_WIN := "PLAYER 2 WINS"

func show_ready(status := true) -> void:
	$%LabelContainer.visible = status
	if $%LabelContainer.visible:
		$%Label.text = TEXT_READY
		
func show_pause(status := true) -> void:
	$%LabelContainer.visible = status
	if $%LabelContainer.visible:
		$%Label.text = TEXT_PAUSED
	$%ButtonContainer.visible = status
	
func show_end(status := true, is_multiplayer := true, player_1_won := true) -> void:
	$%LabelContainer.visible = status
	if $%LabelContainer.visible:
		if is_multiplayer:
			if player_1_won:
				$%Label.text = TEXT_PLAYER_1_WIN
			else:
				$%Label.text = TEXT_PLAYER_2_WIN
		else:
			if player_1_won:
				$%Label.text = TEXT_PLAYER_WIN
			else:
				$%Label.text = TEXT_CPU_WIN
	$%ButtonContainer.visible = status
	if %ButtonContainer.visible:
		$%ResumeButton.visible = false
	else:
		$%ResumeButton.visible = true
