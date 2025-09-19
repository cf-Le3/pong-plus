class_name Session
extends Node

signal session_closed

@export var _game_scene: PackedScene

var is_multiplayer := false
var game_config := GameConfig.new()
var _game: Game

const TEXT_READY := "READY"
const TEXT_PAUSED := "PAUSED"
const TEXT_PLAYER_WIN := "YOU WIN"
const TEXT_CPU_WIN := "YOU LOSE"
const TEXT_PLAYER_1_WIN := "PLAYER 1 WINS"
const TEXT_PLAYER_2_WIN := "PLAYER 2 WINS"

func _ready() -> void:
	_create_new_game()
	_start_game()

func _create_new_game() -> void:
	_game = _game_scene.instantiate()
	_game.is_multiplayer = is_multiplayer
	_game.game_config = game_config
	_game.connect("game_ended", _on_game_ended)
	add_child(_game)

func _start_game() -> void:
	assert(_game != null)
	_show_ready(true)
	$StartGameTimer.start()
	$StartGameSound.play()

func _on_start_game_timer_timeout() -> void:
	_show_ready(false)
	_game.begin()
func _show_ready(status: bool) -> void:
	$%LabelContainer.visible = status
	if $%LabelContainer.visible:
		$%Label.text = TEXT_READY
		
func _show_pause(status: bool) -> void:
	$%LabelContainer.visible = status
	if $%LabelContainer.visible:
		$%Label.text = TEXT_PAUSED
	$%ButtonContainer.visible = status
	
func _show_end(status: bool, player_1_won: bool = true) -> void:
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
	
func _on_game_ended() -> void:
	session_closed.emit()
