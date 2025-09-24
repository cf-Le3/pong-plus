extends CanvasLayer

func show_hud_elements(game_mode: Game.GameMode) -> void:
	$ScoreLabel2.visible = true
	if game_mode == Game.GameMode.VERSUS:
		$ScoreLabel1.visible = true
	elif game_mode == Game.GameMode.SURVIVAL:
		$HealthBar.visible = true

func update_versus_score(score: int, is_player_1: bool) -> void:
	if is_player_1:
		$ScoreLabel1.text = str(score)
	else:
		$ScoreLabel2.text = str(score)

func update_survival_score(score: int) -> void:
	$ScoreLabel2.text = str(score)

func update_survival_health(health: int) -> void:
	$HealthBar.value = health
