extends RefCounted

class_name RandomResourcePool

var _resource_item_pool: Array = []

func add_items(items: Array[PoolItemResource], should_clear:bool) -> void:
	if should_clear:
		clear()
	
	populate_and_shuffle_pool(items)

func clear() -> void:
	_resource_item_pool.clear()

func populate_and_shuffle_pool(items: Array[PoolItemResource]) -> void:
	for item in items:
		for _i in range(item.amount):
			_resource_item_pool.append(item.item_resource)
	_resource_item_pool.shuffle()

func pop_item() -> Resource:
	if _resource_item_pool.size() > 0:
		return _resource_item_pool.pop_front()
	else:
		printerr("The pool is empty!")
		return null

func is_empty() -> bool:
	return _resource_item_pool.size() == 0
