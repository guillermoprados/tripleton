extends RefCounted

class_name Utils

static func get_name_from_resource(resource: Resource) -> String:
	var path = resource.get_path()
	var filename = path.get_file()
	var name = filename.get_basename()
	return name
