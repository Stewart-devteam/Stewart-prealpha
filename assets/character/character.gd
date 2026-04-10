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
## Épsilon para cálculos de animaciones
const EPSILON := 0.05


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

## Última posición global del personaje
@onready var last_global_pos: Vector2 = global_position
## Última velocidad global del personaje. La usaremos para las animaciones
@onready var last_velocity: Vector2 = Vector2.ZERO


## Bandera que determina si el jugador se mueve por el jugador o sigue a otro
var is_following: bool = false

## Dirección de la entrada. Usado a lo largo de la máquina de estados
var input_direction: Vector2
## Nombre de la dirección actual, para su uso en las animaciones del personaje
var direction_name: StringName = Directions.DOWN:
	set(value):
		if value == direction_name: return
		direction_name = value
		print("[Character] Última dirección: %s" % direction_name)


func _physics_process(delta: float) -> void:
	# Actualiza la dirección de la entrada de teclado
	input_direction = Input.get_vector(&"left", &"right", &"up", &"down")

	# Actualiza el path si nos hemos movido lo suficiente
	var distance := (global_position - last_path_pos).length()
	if distance >= CharactersPath.MIN_PATH_TRACE: last_path_pos = global_position

	# Actualiza la última velocidad global. La velocidad normal no es útil aquí
	last_velocity = (global_position - last_global_pos) / delta
	last_global_pos = global_position

	# Actualiza la nombre de la dirección para animar
	_update_direction_name()

	if not is_following: move_and_slide()


#region Animaciones


## Ejecuta la animación que se le pide, según el nombre y la dirección. [br]
## Si no hay nombre, reutiliza el actual. Útil para actualizar la dirección
func play_anim(anim_name := &"") -> void:
	# Si no hay nombre, reutiliza el actual (sin la dirección)
	var current_anim_name := sprite.animation.get_slice("_", 0)
	if not anim_name: anim_name = current_anim_name

	# Voltea el sprite usando flip_h dependiendo de la dirección horizontal
	sprite.flip_h = direction_name == Directions.LEFT

	# ! Establece el nombre de la animación en side (Temporal, luego se hacen diferidas)
	var final_direction_name := direction_name
	if final_direction_name in [Directions.RIGHT, Directions.LEFT]: final_direction_name = &"side"

	# Omite poner la animación si ya es la actual
	var final_name := "%s_%s" % [anim_name, final_direction_name]
	if final_name == sprite.animation: return

	print("[Character] Ejecutando animación: %s" % final_name)
	sprite.play(final_name)


## Actualiza el nombre de la última dirección para su uso en las animaciones
func _update_direction_name() -> void:
	# Solo actualiza la dirección si hay un movimiento significativo
	if last_velocity.length_squared() < EPSILON: return

	var abs_x = abs(last_velocity.x)
	var abs_y = abs(last_velocity.y)

	# Horizontal
	if abs_x > abs_y + EPSILON:
		direction_name = Directions.RIGHT if last_velocity.x > 0 else Directions.LEFT
	# Vertical
	elif abs_y > abs_x + EPSILON:
		direction_name = Directions.DOWN if last_velocity.y > 0 else Directions.UP
	# 45 grados (diagonal): priorizamos el eje vertical
	else:
		direction_name = Directions.DOWN if last_velocity.y > 0 else Directions.UP

	play_anim()


#endregion
