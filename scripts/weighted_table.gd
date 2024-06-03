class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum := 0


func add_item(item, weight: int):
	assert(weight > 0)
	
	items.append({"item": item, "weight": weight})
	weight_sum += weight


func remove_item(item_to_remove):
	items = items.filter(func (it): return it["item"] != item_to_remove)
	
	# recalculate sum
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]


# TODO: make it performant
func pick_item(exclude: Array = []):
	assert(not items.is_empty())

	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum := weight_sum
	if not exclude.is_empty():
		adjusted_items = []
		adjusted_weight_sum = 0
		for it in items:
			if it["item"] in exclude:
				continue
			adjusted_items.append(it)
			adjusted_weight_sum += it["weight"]
	
	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iteration_sum = 0
	for it in adjusted_items:
		iteration_sum += it["weight"]
		if chosen_weight <= iteration_sum:
			return it["item"]
