class_name GameSettings
extends CanvasLayer
signal close_game_settings(game_config: GameConfig)
var game_config := GameConfig.new()

func _ready() -> void:
	_update_counters()
	$%PointsButtonL.grab_focus()

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

func _on_default_button_pressed() -> void:
	game_config = GameConfig.new()
	_update_counters()

func _on_confirm_button_pressed() -> void:
	close_game_settings.emit(game_config)

func _update_counters() -> void:
	$%PointsCounter.text = str(game_config.get_max_points())
	$%BallsCounter.text = str(game_config.get_max_balls())
