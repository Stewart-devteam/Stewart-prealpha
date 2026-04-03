class_name Character extends CharacterBody2D


const directions := {
	UP = "up",
	DOWN = "down",
	RIGHT = "right",
	LEFT = "left",
}


@export_group("Movement")
## Velocidad al caminar
@export var walk_speed: float = 12.0
## Velocidad al correr
@export var run_speed: float = 24.0


## Sprite con las animaciones
@onready var sprite: AnimatedSprite2D = $PlaceholderSprite


## Dirección de la entrada del teclado
var direction: Vector2
## Nombre de la última dirección
var last_direction_name := &"down":
	set(value):
		last_direction_name = value
		print("[Character] Última dirección: %s" % last_direction_name)


func _physics_process(_delta: float) -> void:
	# Actualiza la dirección de la entrada de teclado
	direction = Input.get_vector("left", "right", "up", "down")
	if direction: _update_direction_name()


## Ejecuta la animación que se le pide, según el nombre y la dirección
func play_anim(anim_name: StringName):
	var final_direction := last_direction_name

	# Voltea el sprite dependiendo de la dirección horizontal
	# ! También establece la animación en side (Temporal)
	match last_direction_name:
		&"right": scale.x = 8
		&"left": scale.x = -8

	if last_direction_name == &"right" or last_direction_name == &"left":
		final_direction = &"side"

	var final_name := "%s_%s" % [anim_name, final_direction]
	print("[Character] Ejecutando animación: %s" % final_name)
	sprite.play(final_name)


## Actualiza el nombre de la última dirección
func _update_direction_name() -> void:
	if abs(direction.x) > abs(direction.y):
		last_direction_name = directions.RIGHT if direction.x > 0 else directions.LEFT
		return

	if abs(direction.y) > abs(direction.x):
		last_direction_name = directions.DOWN if direction.y > 0 else directions.UP
		return
