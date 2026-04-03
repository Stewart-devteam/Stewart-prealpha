class_name CharacterIdle extends CharacterState


func start() -> void:
	if not character.is_node_ready(): await character.ready
	character.play_anim("idle")


func physics_update(_delta: float) -> void:
	# Si no está quieto, pasa a Walk
	if character.direction: to_state.emit(CharacterWalk)
