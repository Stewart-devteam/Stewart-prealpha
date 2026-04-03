class_name CharacterIdle extends CharacterState


func physics_update(_delta: float) -> void:
	# Si presiona run, pasa a Run
	if Input.is_action_pressed("sprint"): to_state.emit(CharacterRun)

	# Si no está quieto, pasa a Walk
	if direction: to_state.emit(CharacterWalk)
