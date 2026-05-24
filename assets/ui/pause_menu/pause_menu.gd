class_name PauseMenu extends ColorRect


## Se emite cuando el menú se activa o desactiva
signal set_visible(value: bool)


func _ready() -> void:
	visible = false
	set_visible.emit(false)


func _on_resume_button_pressed() -> void:
	visible = false
	set_visible.emit(false)


func _on_menu_button_pressed() -> void:
	SceneManager.change_to_scene("start_menu")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		visible = not visible
		set_visible.emit(visible)
