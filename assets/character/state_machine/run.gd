class_name CharacterRun extends CharacterState


func start() -> void:
	character.play_anim(&"run")


func physics_update(_delta: float) -> void:
	# Si está quieto, pasa a Idle
	if not character.input_direction:
		to_state.emit(CharacterIdle)
		return

	# Si soltamos correr, pasamos a Walk
	if not Input.is_action_pressed(&"sprint"):
		to_state.emit(CharacterWalk)
		return

	character.velocity = character.input_direction * character.run_speed
