extends Camera2D


## Velocidad a la que la cámara sigue al jugador
@export var follow_speed := 5.0


@onready var parent: Character = get_parent()


func _ready() -> void:
	# Deslinda y mueve la cámara hacia la posición de su padre de inmediato
	top_level = true
	global_position = parent.global_position

	# ? Ajusta la velocidad de seguimiento al zoom de la cámara
	# ? Asume que los dos valores de zoom (Vector2) son el mismo
	# follow_speed *= zoom.x


func _physics_process(delta: float) -> void:
	_lerp_camera_position(delta)


## Interpola la posición de la camara hacia la del jugador para suavizar el movimiento
func _lerp_camera_position(delta: float) -> void:
	var final_pos: Vector2 = parent.global_position

	# Ahorra cálculos cuando la cámara se queda quieta
	if global_position.is_equal_approx(final_pos): return

	var weight = 1 - exp(-follow_speed * delta)
	global_position = global_position.lerp(final_pos, weight)
