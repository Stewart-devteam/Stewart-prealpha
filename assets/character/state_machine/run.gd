class_name CharacterRun extends CharacterState


@export var sprint_speed: float = 24.0


func physics_update(_delta: float) -> void:
	# Si está quieto, pasa a Idle
	if not direction: to_state.emit(CharacterIdle)

	# Si soltamos correr, pasamos a Walk
	if not Input.is_action_pressed("sprint"): to_state.emit(CharacterWalk)

	character.velocity = direction * sprint_speed
	character.move_and_slide()
