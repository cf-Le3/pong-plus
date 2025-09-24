extends CanvasLayer

const TEXT_READY := "READY"
const TEXT_PAUSED := "PAUSED"
const TEXT_PLAYER_WIN := "YOU WIN"
const TEXT_CPU_WIN := "YOU LOSE"
const TEXT_PLAYER_1_WIN := "PLAYER 1 WINS"
const TEXT_PLAYER_2_WIN := "PLAYER 2 WINS"
const TEXT_SURVIVAL_END := "GAME OVER"

func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() == null && $%ButtonContainer.visible:
		if $%ResumeButton.visible:
			if event.is_action_pressed("ui_left"):
				$%RestartButton.grab_focus()
			elif event.is_action_pressed("ui_right"):
				$%ExitButton.grab_focus()
		else:
			if event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right"):
				$%ExitButton.grab_focus()

func show_ready(status := true) -> void:
	$%MessageContainer.visible = status
	if $%MessageContainer.visible:
		$%Message.text = TEXT_READY
		
func show_pause(status := true) -> void:
	$%MessageContainer.visible = status
	if $%MessageContainer.visible:
		$%Message.text = TEXT_PAUSED
	$%ButtonContainer.visible = status
	
func show_end_versus(status := true, is_multiplayer := true, player_1_won := true) -> void:
	$%MessageContainer.visible = status
	if $%MessageContainer.visible:
		if is_multiplayer:
			if player_1_won:
				$%Message.text = TEXT_PLAYER_1_WIN
			else:
				$%Message.text = TEXT_PLAYER_2_WIN
		else:
			if player_1_won:
				$%Message.text = TEXT_PLAYER_WIN
			else:
				$%Message.text = TEXT_CPU_WIN
	_toggle_button_container_visibility_when_ending_game(status)

func show_end_survival(status := true, score := 0, time_elapsed := 0):
	$%MessageContainer.visible = status
	if $%MessageContainer.visible:
		$%Message.text = TEXT_SURVIVAL_END
	$%ResultsContainer.visible = status
	if $%ResultsContainer.visible:
		$%Score.text = str(score) + " pts"
		$%Time.text = str(time_elapsed) + " s"
	_toggle_button_container_visibility_when_ending_game(status)

func _toggle_button_container_visibility_when_ending_game(status := true):
	$%ButtonContainer.visible = status
	if %ButtonContainer.visible:
		$%ResumeButton.visible = false
	else:
		$%ResumeButton.visible = true

func _on_resume_button_visibility_changed() -> void:
	if $%ResumeButton.visible:
		$%RestartButton.focus_neighbor_left = NodePath($%RestartButton.get_path_to($%ResumeButton))
		$%ExitButton.focus_neighbor_right = NodePath($%ExitButton.get_path_to($%ResumeButton))
	else:
		$%RestartButton.focus_neighbor_left = NodePath($%RestartButton.get_path_to($%ExitButton))
		$%ExitButton.focus_neighbor_right = NodePath($%ExitButton.get_path_to($%RestartButton))
