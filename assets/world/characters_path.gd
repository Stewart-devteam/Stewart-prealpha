## [code]CharacterPath[/code] gestiona la trayectoria de los personajes para que se muevan a lo
## largo de una fila según la entrada del jugador
class_name CharactersPath extends Path2D


## Longitud máxima de la curva
const PATH_MAX_LENGTH := 100.0
## Mínima distancia a la que hay que moverse para actualizar el path
const MIN_PATH_TRACE := 1.0
## Distancia entre personajes
const CHARA_DISTANCE := 30.0


## Nodo que contiene los personajes controlados por el jugador
@export var characters_node: Node


#region Preparación


func _ready() -> void:
	_find_and_set_characters()


## Encuentra a los personajes y los configura para ser seguidos
func _find_and_set_characters() -> void:
	# ? La estructura de la escena bajo este nodo debe ser:
	# ? - PathFollow
	# ?     - RemoteTransform -> Apunta al personaje
	# ? - PathFollow2
	# ?     - RemoteTransform -> Apunta al personaje
	# ? - ...
	# Busca a los personajes (verificando que son los correctos)
	var characters := characters_node.get_children().filter(func(c): return c is Character)
	if characters.is_empty():
		push_warning("[CharactersPath] No se encontraron personajes válidos en el nodo")
		return

	# Por cada personaje que no sea lider instancia un PathFollow, un RemoteTransform y empieza a asignar
	var follower_found := false
	for character: Character in characters:
		# Forzamos a que el personaje ignore escalas/posiciones de sus padres
		# Para evitar problemas de movimiento
		character.top_level = true
		character.is_following = true

		# Designa al lider
		if not follower_found:
			follower_found = true
			character.is_following = false

			# Conecta la señal para actualizar el path
			character.update_path.connect(_on_update_path)
			continue

		# Desactiva la colisión para evitar problemas de movimiento
		character.collision_layer = 0
		character.collision_mask = 0

		# Crea los nodos y añade al SceneTree
		var path_follow := PathFollow2D.new()
		var remote_transform := RemoteTransform2D.new()

		add_child(path_follow)
		path_follow.add_child(remote_transform)

		# Configura el path_follow y el remote_transform
		path_follow.rotates = false
		path_follow.loop = false
		remote_transform.update_rotation = false
		remote_transform.update_scale = false

		# Asignamos el personaje al remote_transform
		remote_transform.remote_path = remote_transform.get_path_to(character)


#endregion


#region Actualización


## Actualiza la trayectoria de los personajes cuando reciba la señal de los jugadores
func _on_update_path(new_pos: Vector2) -> void:
	# Convertimos la posición global a local para la curva
	curve.add_point(to_local(new_pos))

	# Elimina el ultimo punto si la curva supera el largo máximo
	if curve.get_baked_length() > PATH_MAX_LENGTH: curve.remove_point(0)

	# Reubica los personajes
	_set_characters_pos()


## Ubica a los personajes en una distancia equivalente a lo largo de la curva
func _set_characters_pos() -> void:
	# Obtenemos la longitud de la curva
	var baked_length := curve.get_baked_length()
	if baked_length <= 0: return

	# Buscamos a todos los personajes
	for i in get_children().size():
		var character_follow: PathFollow2D = get_child(i)
		var remote_transform: RemoteTransform2D = character_follow.get_child(0)

		# Obtenemos el personaje si es válido
		var character: Character = remote_transform.get_node(remote_transform.remote_path)
		if not character.is_following: continue

		# Separamos a los personajes según CHARA_DISTANCE
		# ? La distancia se cuenta en reversa porque el lider dibuja el final de la curva
		# ? Usamos max(0) para que si el path es corto, esperen en el origen
		var target_distance := baked_length - (i + 1) * CHARA_DISTANCE
		character_follow.progress = max(0.0, target_distance)


#endregion
