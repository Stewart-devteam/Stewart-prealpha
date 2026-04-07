class_name CharacterWalk extends CharacterState


func start() -> void:
	character.play_anim(&"walk")


func physics_update(_delta: float) -> void:
	# Si está quieto, pasa a Idle
	if not character.input_direction:
		to_state.emit(CharacterIdle)
		return

	# Si presionamos correr, pasamos a Run
	if Input.is_action_pressed(&"sprint"):
		to_state.emit(CharacterRun)
		return

	character.velocity = character.input_direction * character.walk_speed
