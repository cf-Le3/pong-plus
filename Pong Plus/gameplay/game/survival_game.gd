class_name SurvivalGame
extends Game

const MAX_HEALTH := 5

# Nodes
var secondTimer: Timer

# Game state
var _health := MAX_HEALTH
var _score := 0
var _time_elapsed := 0

func _ready() -> void:
	super()
	secondTimer = Timer.new()
	secondTimer.connect("timeout", _on_second_timer_timeout)

func begin() -> void:
	secondTimer.start()
	super()

func _on_second_timer_timeout() -> void:
	_time_elapsed += 1

func _game_over() -> void:
	secondTimer.stop()
	print("DEBUG | Time elapsed: " + str(_time_elapsed))
	super()
