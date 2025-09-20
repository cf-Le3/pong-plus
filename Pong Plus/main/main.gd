extends Node

@export_category("Packed Scenes")
@export var _session_scene: PackedScene
@export var _volume_settings_scene: PackedScene
@export var _game_settings_scene: PackedScene
@export var _license_scene: PackedScene
@export var _help_scene: PackedScene
@export var _credits_scene: PackedScene

var _game_config: GameConfig
var _volume_config: VolumeConfig
var _session: Session
var _volume_settings: VolumeSettings
var _game_settings: GameSettings
var _license: License
var _help: Help
var _credits: Credits
var _version := "v1.1.0"

func _ready() -> void:
	_game_config = GameConfig.new()
	_volume_config = VolumeConfig.new()
	$Title.set_version(_version)
	$Music.play()

func _on_title_single_player_game_started() -> void:
	_create_new_session(false)

func _on_title_multi_player_game_started() -> void:
	_create_new_session(true)

func _create_new_session(is_multiplayer: bool) -> void:
	_enable_title(false)
	_session = _session_scene.instantiate()
	_session.is_multiplayer = is_multiplayer
	_session.game_config = _game_config
	_session.connect("closed", _on_session_closed)
	add_child(_session)
	
func _on_session_closed() -> void:
	_session.queue_free()
	_enable_title(true)
	$Title.switch_menu(Title.ActiveMenu.TITLE)

func _on_title_volume_settings_opened() -> void:
	_enable_title(false)
	_volume_settings = _volume_settings_scene.instantiate()
	_volume_settings.volume_config = _volume_config
	_volume_settings.connect("closed", _on_volume_settings_closed)
	add_child(_volume_settings)

func _on_volume_settings_closed(volume_config: VolumeConfig) -> void:
	_volume_config = volume_config
	_volume_settings.queue_free()
	_enable_title(true)	

func _on_title_game_settings_opened() -> void:
	_enable_title(false)
	_game_settings = _game_settings_scene.instantiate()
	_game_settings.game_config = _game_config
	_game_settings.connect("closed", _on_game_settings_closed)
	add_child(_game_settings)

func _on_game_settings_closed(game_config: GameConfig) -> void:
	_game_config = game_config
	_game_settings.queue_free()
	_enable_title(true)
	$Title.switch_menu(Title.ActiveMenu.TITLE)

func _on_title_license_opened() -> void:
	_enable_title(false)
	_license = _license_scene.instantiate()
	_license.connect("closed", _on_license_closed)
	add_child(_license)
	
func _on_license_closed() -> void:
	_license.queue_free()
	_enable_title(true)

func _on_title_help_opened() -> void:
	_enable_title(false)
	_help = _help_scene.instantiate()
	_help.connect("closed", _on_help_closed)
	add_child(_help)

func _on_help_closed() -> void:
	_help.queue_free()
	_enable_title(true)
	
func _on_title_credits_opened() -> void:
	_enable_title(false)
	_credits = _credits_scene.instantiate()
	_credits.connect("closed", _on_credits_closed)
	add_child(_credits)
	
func _on_credits_closed() -> void:
	_credits.queue_free()
	_enable_title(true)
	
func _enable_title(status: bool) -> void:
	$Title.visible = status
	$Title.set_process_input(status)
