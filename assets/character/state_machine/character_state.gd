class_name CharacterState extends BaseState


## Wrapper para el personaje
var character: Character:
	set(value):
		character = value
		controlled_node = value
	get:
		return controlled_node
