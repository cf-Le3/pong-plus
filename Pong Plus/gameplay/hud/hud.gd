extends CanvasLayer

func _ready() -> void:
	$ScoreLabel1.text = str(0)
	$ScoreLabel2.text = str(0)

func show_score() -> void:
	$ScoreLabel1.visible = true
	$ScoreLabel2.visible = true
	$ReadyMessage.visible = false

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
	
func show_end_game():
	$ContinueLabel.visible = true
