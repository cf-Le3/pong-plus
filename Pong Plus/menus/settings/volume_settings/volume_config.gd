class_name VolumeConfig

var _master_vol_value := 1.0
var _music_vol_value := 0.5
var _sfx_vol_value := 1.0

func get_master_vol_value() -> float:
	return _master_vol_value

func set_master_vol_value(val: float) -> void:
	_master_vol_value = val

func get_music_vol_value() -> float:
	return _music_vol_value

func set_music_vol_value(val: float) -> void:
	_music_vol_value = val

func get_sfx_vol_value() -> float:
	return _sfx_vol_value

func set_sfx_vol_value(val: float) -> void:
	_sfx_vol_value = val
