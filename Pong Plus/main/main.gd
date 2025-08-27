extends Node
@export var game_scene: PackedScene
@export var help_scene: PackedScene
var game
var help
var version = "v0.3.1"

func _ready() -> void:
	$Title.set_version(version)

func _on_title_new_game_multiplayer() -> void:
	enable_title(false)
	game = game_scene.instantiate()
	game.connect("close_game", _on_close_game)
	add_child(game)
	
func _on_close_game() -> void:
	game.queue_free()
	enable_title(true)
	
func _on_title_view_help() -> void:
	enable_title(false)
	help = help_scene.instantiate()
	help.connect("close_help", _on_close_help)
	add_child(help)

func _on_close_help() -> void:
	help.queue_free()
	enable_title(true)
	
func enable_title(status: bool) -> void:
	$Title.visible = status
	$Title.set_process_input(status)
	if status == true:
		$Title.delay_input()
