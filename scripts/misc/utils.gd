extends RefCounted

class_name Utils

static func get_name_from_resource(resource: Resource) -> String:
	var path := resource.get_path()
	var filename := path.get_file()
	var name := filename.get_basename()
	return name

static func is_valid_cell(cell: Vector2, matrix: Array) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < matrix.size() and cell.y < matrix[0].size()


# Static method to copy the cell_tokens_ids
static func copy_array_matrix(original: Array) -> Array:
	var copy: Array = []
	for row in original:
		var row_copy: Array = row.duplicate()
		copy.append(row_copy)
	return copy
