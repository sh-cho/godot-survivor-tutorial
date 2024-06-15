extends CanvasLayer

signal transitioned_halfway
var skip_emit := false

@onready var rect: ColorRect = $ColorRect
@onready var material: ShaderMaterial = rect.material


func transition():
	rect.visible = true
	material.set_shader_parameter("fill_in", true)
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
	transitioned_halfway.emit()

	material.set_shader_parameter("fill_in", false)
	material.set_shader_parameter("progress", 0)
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
	rect.visible = false


func transition_to_scene(scene_path: String):
	transition()
	await transitioned_halfway
	get_tree().change_scene_to_file(scene_path)
