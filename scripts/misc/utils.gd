extends RefCounted

class_name Utils

static func get_name_from_resource(resource: Resource) -> String:
	var path = resource.get_path()
	var filename = path.get_file()
	var name = filename.get_basename()
	return name

# Static method to copy the cell_tokens_ids
static func copy_array_matrix(original: Array) -> Array:
	var copy: Array = []
	for row in original:
		var row_copy: Array = row.duplicate()
		copy.append(row_copy)
	return copy
