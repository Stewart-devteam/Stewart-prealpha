## [code]CharacterPath[/code] gestiona la trayectoria de los personajes para que se muevan a lo
## largo de una fila
class_name CharactersPath extends Path2D


## Longitud máxima de la curva
const PATH_MAX_LENGTH := 100.0
## Mínima distancia a la que hay que moverse para actualizar el path
const MIN_PATH_TRACE := 1.0
## Distancia entre personajes
const CHARA_DISTANCE := 30.0


func _ready() -> void:
	_find_and_set_characters()


## Encuentra a los personajes y los configura para ser seguidos
func _find_and_set_characters() -> void:
	# ? La estructura de la escena bajo este nodo debe ser:
	# ? - CharactersPath: Path2D (este nodo)
	# ?     - PathFollower
	# ?         - Character: Character
	# ?     - PathFollower2
	# ?         - Character2: Character
	# ?     - ...
	# Busca a los personajes que haya y conecta la señal de actualización solo para el primero
	var follower_found := false
	for child in get_children():
		var character: Character = child.get_child(0)

		# El personaje lider, el primero, es el único que manda la señal
		if not follower_found:
			follower_found = true
			character.top_level = true # Evita que el líder sea arrastrado por el PathFollower
			character.update_path.connect(func(new_pos: Vector2):
				# Importante: El nodo CharactersPath NO debe ser hijo del Jugador
				_on_update_path(new_pos)
				_set_characters_pos()
			)
		# El resto sigue al lider
		else:
			character.is_following = true
			# Desactivamos colisiones para los seguidores para que no bloqueen al líder
			character.collision_layer = 0
			character.collision_mask = 0


## Actualiza la trayectoria de los personajes cuando reciba la señal de los jugadores
func _on_update_path(new_pos: Vector2) -> void:
	# Convertimos la posición global a local para la curva
	curve.add_point(to_local(new_pos))

	# Elimina el ultimo punto si la curva supera el largo máximo
	if curve.get_baked_length() > PATH_MAX_LENGTH: curve.remove_point(0)


## Ubica a los personajes en una distancia equivalente a lo largo de la curva
func _set_characters_pos() -> void:
	var baked_length := curve.get_baked_length()
	if baked_length <= 0: return

	var children := get_children()
	# Empezamos desde el índice 1 (el primer seguidor)
	for i in range(1, children.size()):
		var character_follow: PathFollow2D = children[i]
		# Desactivamos el loop para evitar saltos
		character_follow.loop = false

		var character: Character = character_follow.get_child(0)

		if not character.is_following: continue

		# Separamos a los personajes de forma equidistante
		# Usamos max(0) para que si el path es corto, esperen en el origen
		var target_distance := baked_length - (i * CHARA_DISTANCE)
		character_follow.progress = max(0.0, target_distance)
