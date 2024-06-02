class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum := 0


func add_item(item, weight: int):
	assert(weight > 0)
	
	items.append({"item": item, "weight": weight})
	weight_sum += weight


func pick_item():
	assert(not items.is_empty())
	
	var chosen_weight = randi_range(1, weight_sum)
	var iteration_sum = 0
	for it in items:
		iteration_sum += it["weight"]
		if chosen_weight <= iteration_sum:
			return it["item"]
