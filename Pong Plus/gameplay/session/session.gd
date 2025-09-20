class_name Session
extends Node

signal closed

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
	_game.connect("ended", _on_game_ended)
	add_child(_game)
	$Display.show_ready()
	$StartGameTimer.start()
	$StartGameSound.play()

func _on_start_game_timer_timeout() -> void:
	assert(_game != null)
	$Display.show_ready(false)
	_game.begin()
	_can_pause = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") && _can_pause:
		if not get_tree().paused:
			_pause_game(true)
		else:
			_pause_game(false)
		$PauseGameSound.play()

func _on_resume_button_pressed() -> void:
	assert(not get_tree().paused)
	_pause_game(false)

func _on_game_ended(player_1_won) -> void:
	$Display.show_end(true, is_multiplayer, player_1_won)
	_can_pause = false
	$EndGameSound.play()
	
func _on_restart_button_pressed() -> void:
	if get_tree().paused:
		_pause_game(false)
	else:
		$Display.show_end(false)
	_game.queue_free()
	_start_game()

func _pause_game(status := true) -> void:
	get_tree().paused = status
	$Display.show_pause(status)

func _on_exit_button_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	closed.emit()
