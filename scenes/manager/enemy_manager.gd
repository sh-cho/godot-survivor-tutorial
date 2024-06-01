extends Node

# 10px outside
const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer = $Timer

var base_spawn_time = 0  # sec


func _ready():
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position() -> Vector2:
	# Spawn outside of the view
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO

	var spawn_position: Vector2
	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)

		# raycast check
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)

		if result.is_empty():
			# no collision - OK
			return spawn_position

		random_direction = random_direction.rotated(deg_to_rad(90))

	return Vector2.ZERO


func on_timer_timeout():
	timer.start()

	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	
