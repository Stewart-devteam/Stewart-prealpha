extends CharacterBody2D

@export var speed := 400.0
@onready var agent := $NavigationAgent2D
@onready var sprite := $Sprite

func _physics_process(_delta):
    var input_dir = Input.get_vector("left", "right", "up", "down")

    if input_dir != Vector2.ZERO:
        agent.target_position = global_position + input_dir * 32

    if agent.is_navigation_finished():
        velocity = Vector2.ZERO
    else:
        var next_pos = agent.get_next_path_position()
        var dir = (next_pos - global_position).normalized()
        velocity = dir * speed

        # Voltea el sprite horizontalmente dependiendo del movimiento
        sprite.flip_h = dir.x < 0
    move_and_slide()
