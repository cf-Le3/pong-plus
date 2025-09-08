extends HSlider
@export var _bus_name: String
var _bus_index: int

func _ready() -> void:
	_bus_index = AudioServer.get_bus_index(_bus_name)

func _on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(new_value))
