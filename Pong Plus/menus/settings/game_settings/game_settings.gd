class_name GameSettings
extends CanvasLayer

signal closed(game_config: GameConfig)

var game_config := GameConfig.new()
var _last_focused: Control = null

#TODO: Moddify focus neighbor attributes for resizing button controls and adjacent controls.

func _ready() -> void:
	_update_display()

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
		
	if game_config.get_magic_balls_enabled():
		$%ResizingEnabledButton.button_pressed = true
	else:
		$%ResizingDisabledButton.button_pressed = true

	$%PointsButtonR.grab_focus()
	get_viewport().connect("gui_focus_changed", _on_viewport_gui_focus_changed)

func _on_viewport_gui_focus_changed(node: Control):
	if node is BaseButton && _last_focused is BaseButton:
		if node.button_group != null && node.button_group != _last_focused.button_group:
			node.button_group.get_pressed_button().grab_focus()
	_last_focused = node
	MenuSfx.play_select_sound()

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
	_update_display()
	MenuSfx.play_cancel_sound()

func _on_points_button_r_pressed() -> void:
	game_config.set_max_points(game_config.get_max_points()+1)
	_update_display()
	MenuSfx.play_confirm_sound()

func _on_balls_button_l_pressed() -> void:
	game_config.set_max_balls(game_config.get_max_balls()-1)
	_update_display()
	MenuSfx.play_cancel_sound()

func _on_balls_button_r_pressed() -> void:
	game_config.set_max_balls(game_config.get_max_balls()+1)
	_update_display()
	MenuSfx.play_confirm_sound()

func _on_easy_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_difficulty(GameConfig.Difficulty.EASY)
		MenuSfx.play_confirm_sound()

func _on_normal_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_difficulty(GameConfig.Difficulty.NORMAL)
		MenuSfx.play_confirm_sound()

func _on_hard_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_difficulty(GameConfig.Difficulty.HARD)
		MenuSfx.play_confirm_sound()

func _on_collisions_enabled_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_ball_collisions_enabled(true)
		MenuSfx.play_confirm_sound()

func _on_collisions_disabled_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_ball_collisions_enabled(false)
		MenuSfx.play_cancel_sound()

func _on_resizing_enabled_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_magic_balls_enabled(true)
		MenuSfx.play_confirm_sound()

func _on_resizing_disabled_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_config.set_magic_balls_enabled(false)
		MenuSfx.play_cancel_sound()

func _on_default_button_pressed() -> void:
	game_config = GameConfig.new()
	$%NormalButton.button_pressed = true
	$%CollisionsDisabledButton.button_pressed = true
	$%ResizingDisabledButton.button_pressed = true
	_update_display()
	MenuSfx.play_cancel_sound()

func _on_confirm_button_pressed() -> void:
	closed.emit(game_config)
	MenuSfx.play_confirm_sound()

func _update_display() -> void:
	$%PointsCounter.text = str(game_config.get_max_points())
	$%BallsCounter.text = str(game_config.get_max_balls())
