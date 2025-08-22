extends Node2D
var viewport_w
var viewport_h
var arena_w = 1024
var arena_h = 512

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_w = get_viewport_rect().size.x
	viewport_h = get_viewport_rect().size.y
	$WallBounceHigh.global_position = Vector2(viewport_w/2, (viewport_h-arena_h)/2)
	$WallBounceLow.global_position = Vector2(viewport_w/2, viewport_h-(viewport_h-arena_h)/2)
	$WallGoalLeft.global_position = Vector2((viewport_w-arena_w)/2, viewport_h/2)
	$WallGoalRight.global_position = Vector2(viewport_w-(viewport_w-arena_w)/2, viewport_h/2)
	$Sprite2D.global_position = Vector2(viewport_w/2, viewport_h/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
