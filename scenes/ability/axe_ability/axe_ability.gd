extends Node2D
class_name AxeAbility

const MAX_RADIUS := 100
const MAX_ROTATION := 2

@onready var hitbox_component := $HitboxComponent


var base_rotation: Vector2


func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, float(MAX_ROTATION), 3)
	tween.tween_callback(queue_free)


func tween_method(rotations: float):
	var percent = rotations / MAX_ROTATION
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	global_position = player.global_position + (current_direction * current_radius)
