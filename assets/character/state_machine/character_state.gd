class_name CharacterState extends BaseState


## Wrapper para el personaje
var character: Character:
	set(value):
		character = value
		controlled_node = value
	get:
		return controlled_node


## Dirección de la entrada del teclado
var direction: Vector2


func _physics_process(_delta: float) -> void:
	# Actualiza la dirección de la entrada de teclado
	direction = Input.get_vector("left", "right", "up", "down")
