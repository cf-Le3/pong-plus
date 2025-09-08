extends Node
@export var game_scene: PackedScene
@export var volume_settings_scene: PackedScene
@export var game_settings_scene: PackedScene
@export var help_scene: PackedScene
@export var credits_scene: PackedScene
var _game_config: GameConfig
var game: Game
var volume_settings: VolumeSettings
var game_settings: GameSettings
var help: Help
var credits: Credits
var version := "v1.1.0"

func _ready() -> void:
	_game_config = GameConfig.new()
	$Title.set_version(version)
	$Music.play()

func _on_title_new_game_singleplayer() -> void:
	create_new_game_session(false)

func _on_title_new_game_multiplayer() -> void:
	create_new_game_session(true)

func create_new_game_session(is_multiplayer: bool) -> void:
	enable_title(false)
	game = game_scene.instantiate()
	game.config_is_multiplayer = is_multiplayer
	game.game_config = _game_config
	game.connect("close_game", _on_close_game)
	add_child(game)
	
func _on_close_game() -> void:
	game.queue_free()
	enable_title(true)

func _on_title_open_volume_settings() -> void:
	enable_title(false)
	volume_settings = volume_settings_scene.instantiate()
	volume_settings.connect("close_volume_settings", _on_close_volume_settings)
	add_child(volume_settings)

func _on_close_volume_settings() -> void:
	volume_settings.queue_free()
	enable_title(true)	

func _on_title_open_game_settings() -> void:
	enable_title(false)
	game_settings = game_settings_scene.instantiate()
	game_settings.game_config = _game_config
	game_settings.connect("close_game_settings", _on_close_game_settings)
	add_child(game_settings)

func _on_close_game_settings(game_config: GameConfig) -> void:
	_game_config = game_config
	game_settings.queue_free()
	enable_title(true)

func _on_title_view_help() -> void:
	enable_title(false)
	help = help_scene.instantiate()
	help.connect("close_help", _on_close_help)
	add_child(help)

func _on_close_help() -> void:
	help.queue_free()
	enable_title(true)
	
func _on_title_view_credits() -> void:
	enable_title(false)
	credits = credits_scene.instantiate()
	credits.connect("close_credits", _on_close_credits)
	add_child(credits)
	
func _on_close_credits() -> void:
	credits.queue_free()
	enable_title(true)
	
func enable_title(status: bool) -> void:
	$Title.visible = status
	$Title.set_process_input(status)
