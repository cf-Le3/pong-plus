class_name GameSettings
extends CanvasLayer

signal closed(game_config: GameConfig)

var game_config := GameConfig.new()

func _ready() -> void:
	_update_counters()

	if game_config.get_difficulty() == GameConfig.Difficulty.EASY:
		$%EasyButton.button_pressed = true
	elif game_config.get_difficulty() == GameConfig.Difficulty.NORMAL:
		$%NormalButton.button_pressed = true
	elif game_config.get_difficulty() == GameConfig.Difficulty.HARD:
		$%HardButton.button_pressed = true

	if game_config.get_ball_collisions_enabled():
		$%CollisionsEnabledButton.button_pressed = true
	else:
		$%CollisionsDisabledButton.button_pressed = true
		
	if game_config.get_single_player_default_controls():
		$%WASDButton.button_pressed = true
	else:
		$%ArrowButton.button_pressed = true

	$%PointsButtonR.grab_focus()

func _input(event: InputEvent) -> void:
	var focus_owner := get_viewport().gui_get_focus_owner()
	if event.is_action_pressed("ui_left"):
		if focus_owner == $%PointsButtonL:
			$%PointsButtonL.pressed.emit()
		elif focus_owner == $%BallsButtonL:
			$%BallsButtonL.pressed.emit()
	elif event.is_action_pressed("ui_right"):
		if focus_owner == $%PointsButtonR:
			$%PointsButtonR.pressed.emit()
		elif focus_owner == $%BallsButtonR:
			$%BallsButtonR.pressed.emit()

func _on_points_button_l_pressed() -> void:
	game_config.set_max_points(game_config.get_max_points()-1)
	_update_counters()

func _on_points_button_r_pressed() -> void:
	game_config.set_max_points(game_config.get_max_points()+1)
	_update_counters()

func _on_balls_button_l_pressed() -> void:
	game_config.set_max_balls(game_config.get_max_balls()-1)
	_update_counters()

func _on_balls_button_r_pressed() -> void:
	game_config.set_max_balls(game_config.get_max_balls()+1)
	_update_counters()

func _on_easy_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_difficulty(GameConfig.Difficulty.EASY)

func _on_normal_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_difficulty(GameConfig.Difficulty.NORMAL)

func _on_hard_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_difficulty(GameConfig.Difficulty.HARD)

func _on_collisions_enabled_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_ball_collisions_enabled(true)

func _on_collisions_disabled_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_ball_collisions_enabled(false)

func _on_wasd_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_single_player_default_controls(true)

func _on_arrow_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_single_player_default_controls(false)

func _on_default_button_pressed() -> void:
	game_config = GameConfig.new()
	$%NormalButton.button_pressed = true
	$%CollisionsDisabledButton.button_pressed = true
	$%WASDButton.button_pressed = true
	_update_counters()

func _on_confirm_button_pressed() -> void:
	closed.emit(game_config)

func _update_counters() -> void:
	$%PointsCounter.text = str(game_config.get_max_points())
	$%BallsCounter.text = str(game_config.get_max_balls())
