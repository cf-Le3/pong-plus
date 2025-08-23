extends CharacterBody2D
@export var is_player_1: bool

func _ready() -> void:
	if not is_player_1:
		$Sprite2D.texture = preload("res://paddle/paddle2.png")

func _physics_process(delta: float) -> void:
	pass
