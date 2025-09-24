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

func show_ready(showing := true) -> void:
	$%MessageContainer.visible = showing
	if $%MessageContainer.visible:
		$%Message.text = TEXT_READY
		
func show_pause(showing := true) -> void:
	$%MessageContainer.visible = showing
	if $%MessageContainer.visible:
		$%Message.text = TEXT_PAUSED
	$%ButtonContainer.visible = showing

func show_end(showing := true, game_mode := Game.GameMode.VERSUS_1, results: Results = null):
	$%MessageContainer.visible = showing
	if $%MessageContainer.visible && results != null:
		if game_mode == Game.GameMode.VERSUS_1:
			if results.get_player_1_won():
				$%Message.text = TEXT_PLAYER_WIN
			else:
				$%Message.text = TEXT_CPU_WIN
		elif game_mode == Game.GameMode.VERSUS_2:
			if results.get_player_1_won():
				$%Message.text = TEXT_PLAYER_1_WIN
			else:
				$%Message.text = TEXT_PLAYER_2_WIN
		elif game_mode == Game.GameMode.SURVIVAL:
			$%Message.text = TEXT_SURVIVAL_END
	
	if (showing && game_mode == Game.GameMode.SURVIVAL) || not showing:
		$%ResultsContainer.visible = showing
		if $%ResultsContainer.visible && results != null:
			$%Score.text = str(results.get_score()) + " pts"
			$%Time.text = str(results._time_elapsed) + " s"
			
	$%ButtonContainer.visible = showing
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
