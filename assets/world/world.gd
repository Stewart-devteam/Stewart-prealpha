class_name World extends Node2D


## Menú de pausa
@onready var pause_menu: PauseMenu = %PauseMenu


func _ready() -> void:
	for child in get_children():
		if child is Character: pause_menu.set_visible.connect(child.set_paused)
