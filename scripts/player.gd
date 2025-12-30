extends CharacterBody2D

@export var speed: float = 10000
@export var speed_boost: float = 2.5
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var music: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _process(_delta: float) -> void:
    _velocity(_delta)
    _animation()

    # Se mueve
    move_and_slide()

# Procesa la velocidad de movimiento
func _velocity(delta: float):
    # Obtiene la dirección del movimiento
    var direction: Vector2 = Input.get_vector("left", "right", "up", "down")

    # Aplica la velocidad en la dirección elegida
    velocity = direction * speed * delta

    # Va más rápido (personaje y música) con el sprint
    if Input.is_action_pressed("sprint"):
        velocity *= speed_boost
        music.pitch_scale = speed_boost
    else:
        music.pitch_scale = 1

# Procesa animaciones
func _animation():
    # Cambia de animación si se está moviendo
    if velocity != Vector2.ZERO:
        animation.play("walk")
    else:
        animation.play("idle")

    # Voltea el sprite horizontalmente
    if velocity.x < 0:
        animation.flip_h = true
    elif velocity.x > 0:
        animation.flip_h = false
