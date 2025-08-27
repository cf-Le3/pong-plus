extends Node
@export var game_scene: PackedScene
var game

func _on_title_new_game_multiplayer() -> void:
	enable_title(false)
	game = game_scene.instantiate()
	game.connect("close_game", _on_close_game)
	add_child(game)
	
func enable_title(status: bool) -> void:
	$Title.visible = status
	$Title.set_process_input(status)
