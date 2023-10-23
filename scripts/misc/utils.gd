extends RefCounted

class_name Utils

static func get_name_from_resource(resource: Resource) -> String:
	var path = resource.get_path()
	var filename = path.get_file()
	var name = filename.get_basename()
	return name

static func get_files_names_at_path(path) -> Array:
	var names: Array = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				names.append(file_name)
			file_name = dir.get_next()			
	else:
		assert (false, "An error occurred when trying to access the path.")
	
	names.sort()
	
	return names
