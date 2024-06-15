extends CanvasLayer
class_name MetaMenu

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container: GridContainer = %GridContainer
@onready var back_button: Button = %BackButton

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn")


func _ready():
	back_button.pressed.connect(on_back_pressed)
	
	# remove debug childrens
	for child in grid_container.get_children():
		child.queue_free()
	
	for u in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate() as MetaUpgradeCard
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(u)


func on_back_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
