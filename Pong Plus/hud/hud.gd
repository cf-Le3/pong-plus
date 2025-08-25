extends CanvasLayer

func _ready() -> void:
	$ScoreLabel1.text = str(0)
	$ScoreLabel2.text = str(0)

func update_score(score: int, is_player_1: bool) -> void:
	if is_player_1:
		$ScoreLabel1.text = str(score)
	else:
		$ScoreLabel2.text = str(score)

func show_game_over(score_player_1, score_player_2):
	if score_player_1 >= score_player_2:
		$GameOverMessage/WinnerLabel.text = "PLAYER 1 WINS"
	else:
		$GameOverMessage/WinnerLabel.text = "PLAYER 2 WINS"
	$GameOverMessage.visible = true
