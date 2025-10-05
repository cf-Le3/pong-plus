class_name Help
extends CanvasLayer

signal closed

enum Page{
	BASICS,
	ENDURANCE
}

const TITLE_BASICS := "HOW TO PLAY"
const TITLE_ENDURANCE := "ENDURANCE MODE" 

var page := Page.BASICS

func _ready() -> void:
	$%RightButton.grab_focus()

func _on_right_button_pressed() -> void:
	_change_page(Page.ENDURANCE)

func _on_left_button_pressed() -> void:
	_change_page(Page.BASICS)
	
func _change_page(target_page: Page) -> void:
	if target_page == Page.BASICS:
		$%Title.text = TITLE_BASICS
	elif target_page == Page.ENDURANCE:
		$%Title.text = TITLE_ENDURANCE
	
	$%BasicsContainer.visible = target_page == Page.BASICS
	$%EnduranceContainer.visible = target_page == Page.ENDURANCE
	
	$%LeftButton.disabled = target_page == Page.BASICS
	$%RightButton.disabled = target_page == Page.ENDURANCE
	
	var enabled_button: TextureButton
	
	if !$%LeftButton.disabled:
		enabled_button = $%LeftButton
	else:
		enabled_button = $%RightButton
	
	enabled_button.grab_focus()
	$%BackButton.focus_neighbor_top = $%BackButton.get_path_to(enabled_button)

func _on_back_button_pressed() -> void:
	closed.emit()
