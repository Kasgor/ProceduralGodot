class_name TerrainGeneration

extends Node

var mesh: MeshInstance3D
var size_depth: int = 200
var size_width: int = 200
var mesh_res : int = 3
var plane_mesh
var mesh_material = preload("res://ProceduralGeneration/Materials/terrain_material.tres")
var mesh_material_grass = preload("res://ProceduralGeneration/Materials/second_texture/TerrainMaterialGrass.tres")

var task_id = -1
@export var noise: FastNoiseLite


func _ready():
	Signals.connect("generate_terrain_via_ui", _on_ui_generate_generate_terrain_via_ui)
	Signals.connect("change_material_of_the_mesh_signal", change_material)
	generate()


func generate():
	
	#start()

	plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size_width, size_depth)
	plane_mesh.subdivide_depth = size_depth*mesh_res
	plane_mesh.subdivide_width = size_width*mesh_res
	
	#var normal_map = mesh_material.get("shader_parameter/normal_map")
	#print(normal_map)
	#mesh_material.set("shader_parameter/normal_map/noise", noise)

	
	plane_mesh.material = mesh_material
	#plane_mesh.material = mesh_material_grass
	
	var surface := SurfaceTool.new()
	var data = MeshDataTool.new()
	surface.create_from(plane_mesh, 0)
	
	var array_plane = surface.commit()
	data.create_from_surface(array_plane, 0)
	
	for i in range(data.get_vertex_count()):
		var vertex = data.get_vertex(i)
		var y = get_noise_y(vertex.x, vertex.z)
		vertex.y = y
		data.set_vertex(i, vertex)
	
	array_plane.clear_surfaces()
	
	data.commit_to_surface(array_plane)
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface.create_from(array_plane, 0)
	surface.generate_normals()
	
	mesh = MeshInstance3D.new()
	mesh.mesh= surface.commit()
	mesh.create_trimesh_collision()
	mesh.cast_shadow= GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	#mesh.add_to_group("NavSource")  #OPTIONAL
	#mesh.position += Vector3(0, -1, 0)
	
	add_child(mesh)


func change_material():
	#TODO CHANGE OF MATERIAL
	pass
	#if (mesh.mesh.back.material == mesh_material):
	#	mesh.mesh.material = mesh_material_grass
	#else:
	#	mesh.mesh.material = mesh_material


func get_noise_y(x, z)->float:
	var value = noise.get_noise_2d(x, z)
	return value*50


func _on_ui_generate_generate_terrain_via_ui():
	
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	
	
	await generate()
	
	Signals.emit_signal("toggle_load_screen", false)
