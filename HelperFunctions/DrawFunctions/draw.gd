extends Node


func point(vec: Vector3, mesh_instance: MeshInstance) -> void:
	var array: Array = []
	var array_mesh: ArrayMesh = mesh_instance.mesh
	array.resize(ArrayMesh.ARRAY_MAX)

	array[ArrayMesh.ARRAY_VERTEX] = [vec]
	
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS, array)

func points(vec_array: PoolVector3Array, mesh_instance: MeshInstance) -> void:
	var array: Array = []
	var array_mesh: ArrayMesh = mesh_instance.mesh
	array.resize(ArrayMesh.ARRAY_MAX)

	array[ArrayMesh.ARRAY_VERTEX] = vec_array
	
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS, array)

func continuous_line(vec_array: PoolVector3Array, mesh_instance: MeshInstance) -> void:
	var array: Array = []
	var array_mesh: ArrayMesh = mesh_instance.mesh
	array.resize(ArrayMesh.ARRAY_MAX)
	
	array[ArrayMesh.ARRAY_VERTEX] = vec_array
	
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, array)

func triangle(vec_array: PoolVector3Array, mesh_instance: MeshInstance) -> void:
	var array: Array = []
	var array_mesh: ArrayMesh = mesh_instance.mesh
	array.resize(ArrayMesh.ARRAY_MAX)
	
	array[ArrayMesh.ARRAY_VERTEX] = vec_array
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_FAN, array)

func polygon(vec_array: PoolVector3Array, mesh_instance: MeshInstance) -> void:
	var array: Array = []
	var array_mesh: ArrayMesh = mesh_instance.mesh
	var normals: PoolVector3Array = []
	var indices: PoolIntArray = range(len(vec_array)) + [1]
	array.resize(ArrayMesh.ARRAY_MAX)
	
	var normalized_center: Vector3 = vec_array[0].normalized()
	for _i in range(len(vec_array)):
		normals.append(normalized_center)
	array[ArrayMesh.ARRAY_VERTEX] = vec_array
	array[ArrayMesh.ARRAY_NORMAL] = normals
	array[ArrayMesh.ARRAY_INDEX] = indices
	
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_FAN, array)

func polygons(array_vec_array: Array, mesh_instance: MeshInstance, color: Color) -> void:
	for i in range(len(array_vec_array)):
		polygon(array_vec_array[i], mesh_instance)
	
	var material = SpatialMaterial.new()
	for j in range(len(array_vec_array)):
		material.albedo_color = color
		mesh_instance.set_surface_material(mesh_instance.get_surface_material_count() - j - 1, material)
#this looks messy for now (works though), change later and make it better! u cunt
