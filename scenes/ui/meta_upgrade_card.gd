extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel

var upgrade: MetaUpgrade


func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func set_meta_upgrade(upgrade: MetaUpgrade) -> void:
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var current_quantity := 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]

	var is_maxed: bool = current_quantity >= upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / upgrade.experience_cost
	percent = min(percent, 1.0)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		purchase_button.text = "Max"
	
	progress_label.text = "%d/%d" % [currency, upgrade.experience_cost]
	count_label.text = "x%d" % current_quantity


func select_card():
	$AnimationPlayer.play("selected")


func on_purchase_pressed():
	if upgrade == null:
		return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")
