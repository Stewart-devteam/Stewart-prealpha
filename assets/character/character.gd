class_name Character extends CharacterBody2D


## Señal que indica que el jugador se ha movido lo suficiente como para actualizar la trayectoria de
## los personajes
signal update_path(new_pos: Vector2)

## Nombres de las direcciones de las animaciones
const Directions := {
	UP = &"up",
	DOWN = &"down",
	RIGHT = &"right",
	LEFT = &"left",
}


@export_group("Movement")
## Velocidad al caminar
@export var walk_speed: float = 12.0
## Velocidad al correr
@export var run_speed: float = 24.0


## Sprite con las animaciones
@onready var sprite: AnimatedSprite2D = $PlaceholderSprite
## Última posición (global) en la que se actualizó el path de los personajes
@onready var last_path_pos: Vector2 = global_position:
	set(value):
		last_path_pos = value
		update_path.emit(value)


## Bandera que determina si el jugador se mueve o sigue a otro
var is_following: bool = false
## Dirección de la entrada. Usado a lo largo de la máquina de estados
var input_direction: Vector2:
	set(value):
		if value == input_direction: return
		input_direction = value
		_update_direction_name()
## Nombre de la última dirección, para su uso en las animaciones del personaje
var last_direction_name: StringName = Directions.DOWN:
	set(value):
		if value == last_direction_name: return
		last_direction_name = value
		print("[Character] Última dirección: %s" % last_direction_name)


func _physics_process(_delta: float) -> void:
	# Actualiza la dirección de la entrada de teclado
	input_direction = Input.get_vector(&"left", &"right", &"up", &"down")

	# Actualiza el path si nos hemos movido lo suficiente
	var distance := (global_position - last_path_pos).length()
	if distance >= CharactersPath.MIN_PATH_TRACE: last_path_pos = global_position

	if not is_following: move_and_slide()


#region Animaciones


## Ejecuta la animación que se le pide, según el nombre y la dirección. [br]
## Si no hay nombre, reutiliza el actual. Útil para actualizar la dirección
func play_anim(anim_name := &"") -> void:
	# Si no hay nombre, reutiliza el actual (sin la dirección)
	var current_anim_name := sprite.animation.get_slice("_", 0)
	if not anim_name: anim_name = current_anim_name

	# Voltea el sprite usando flip_h dependiendo de la dirección horizontal
	sprite.flip_h = last_direction_name == Directions.LEFT

	# ! Establece el nombre de la animación en side (Temporal, luego se hacen diferidas)
	var final_direction_name := last_direction_name
	if final_direction_name in [Directions.RIGHT, Directions.LEFT]: final_direction_name = &"side"

	# Omite poner la animación si ya es la actual
	var final_name := "%s_%s" % [anim_name, final_direction_name]
	if final_name == sprite.animation: return

	print("[Character] Ejecutando animación: %s" % final_name)
	sprite.play(final_name)


## Actualiza el nombre de la última dirección para su uso en las animaciones
func _update_direction_name() -> void:
	if abs(input_direction.x) > abs(input_direction.y):
		last_direction_name = Directions.RIGHT if input_direction.x > 0 else Directions.LEFT

	if abs(input_direction.y) > abs(input_direction.x):
		last_direction_name = Directions.DOWN if input_direction.y > 0 else Directions.UP

	play_anim()


#endregion
