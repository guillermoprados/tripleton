# random_resource_item_pool.gd
extends RefCounted

class_name RandomResourcePool

var _resource_item_pool: Array = []

func _init(items: Array[PooleableResource] = []):
	populate_and_shuffle_pool(items)

func populate_and_shuffle_pool(items: Array[PooleableResource]):
	_resource_item_pool.clear()
	for item in items:
		for _i in range(item.number_of_items):
			_resource_item_pool.append(item.token)
	_resource_item_pool.shuffle()

func pop_item() -> Resource:
	if _resource_item_pool.size() > 0:
		return _resource_item_pool.pop_front()
	else:
		printerr("The pool is empty!")
		return null

func is_empty() -> bool:
	return _resource_item_pool.size() == 0
