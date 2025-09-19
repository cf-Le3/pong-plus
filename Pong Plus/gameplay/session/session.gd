class_name Session
extends Node

signal session_closed

@export var _game_scene: PackedScene

var is_multiplayer := false
var game_config := GameConfig.new()
var _game: Game

func _ready() -> void:
	_create_new_game()

func _create_new_game() -> void:
	_game = _game_scene.instantiate()
	_game.is_multiplayer = is_multiplayer
	_game.game_config = game_config
	_game.connect("game_ended", _on_game_ended)
	add_child(_game)

func _on_game_ended() -> void:
	session_closed.emit()
