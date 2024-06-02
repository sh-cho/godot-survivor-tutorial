extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var rng := RandomNumberGenerator.new()


func _ready():
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1,
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


# Get random 2 upgrades, without duplicates
func pick_upgrades() -> Array[AbilityUpgrade]:
	assert(upgrade_pool.size() >= 2, "upgrade pool size should >= 2")
	var picked := {}  # <index, null>
	var next_idx: int

	while true:
		next_idx = rng.randi_range(0, upgrade_pool.size() - 1)
		if picked.has(next_idx):
			continue
		
		picked[next_idx] = null
		
		if picked.size() >= 2:
			break
	
	# https://github.com/godotengine/godot/issues/72566
	var ret: Array[AbilityUpgrade]
	ret.assign(picked.keys().map(func(i): return upgrade_pool[i]))
	return ret


func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
