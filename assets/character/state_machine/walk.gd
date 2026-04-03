class_name CharacterWalk extends CharacterState


@export var walk_speed: float = 12.0


func physics_update(_delta: float) -> void:
	# Si está quieto, pasa a Idle
	if not direction: to_state.emit(CharacterIdle)

	# Si presionamos correr, pasamos a Run
	if Input.is_action_pressed("sprint"): to_state.emit(CharacterRun)

	character.velocity = direction * walk_speed
	character.move_and_slide()
