class_name License
extends CanvasLayer

signal closed

var _license_text_opening := "This game uses Godot Engine, available under the following license:\n\n"

func _ready() -> void:
	$%LicenseTextLabel.text = str(_license_text_opening + Engine.get_license_text())

func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() == null:
		$%BackButton.grab_focus()
		MenuSfx.play_select_sound()
	if event.is_action("ui_up"):
		$%ScrollContainer.set_v_scroll($%ScrollContainer.get_v_scroll()-10)
	elif event.is_action("ui_down"):
		$%ScrollContainer.set_v_scroll($%ScrollContainer.get_v_scroll()+10)

func _on_back_button_pressed() -> void:
	closed.emit()
	ButtonSfxManager.play_cancel_sound()
