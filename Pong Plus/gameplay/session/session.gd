class_name Session
extends Node

signal session_closed

@export var _game_scene: PackedScene

var is_multiplayer := false
var game_config := GameConfig.new()
var _game: Game
var _can_pause := false

const TEXT_READY := "READY"
const TEXT_PAUSED := "PAUSED"
const TEXT_PLAYER_WIN := "YOU WIN"
const TEXT_CPU_WIN := "YOU LOSE"
const TEXT_PLAYER_1_WIN := "PLAYER 1 WINS"
const TEXT_PLAYER_2_WIN := "PLAYER 2 WINS"

func _ready() -> void:
	_start_game()
	
func _start_game() -> void:
	_game = _game_scene.instantiate()
	_game.is_multiplayer = is_multiplayer
	_game.game_config = game_config
	_game.connect("game_ended", _on_game_ended)
	add_child(_game)
	_show_ready(true)
	$StartGameTimer.start()
	$StartGameSound.play()

func _on_start_game_timer_timeout() -> void:
	assert(_game != null)
	_show_ready(false)
	_game.begin()
	_can_pause = true

func _show_ready(status: bool) -> void:
	$%LabelContainer.visible = status
	if $%LabelContainer.visible:
		$%Label.text = TEXT_READY

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") && _can_pause:
		if not get_tree().paused:
			get_tree().paused = true
			_show_pause(true)
		else:
			get_tree().paused = false
			_show_pause(false)

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	_show_pause(false)
		
func _show_pause(status: bool) -> void:
	$%LabelContainer.visible = status
	if $%LabelContainer.visible:
		$%Label.text = TEXT_PAUSED
	$%ButtonContainer.visible = status

func _on_game_ended(player_1_won) -> void:
	_show_end(true, player_1_won)
	_can_pause = false
	$EndGameSound.play()
	
func _on_restart_button_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
		_show_pause(false)
	else:
		_show_end(false)
	_game.queue_free()
	_start_game()

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

func _on_exit_button_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	session_closed.emit()
