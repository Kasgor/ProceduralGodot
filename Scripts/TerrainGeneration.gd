class_name TerrainGeneration

extends Node

var mesh: MeshInstance3D
var size_depth: int = 200
var size_width: int = 200
var mesh_res : int = 3
var plane_mesh = PlaneMesh.new()
var mesh_material = preload("res://ProceduralGeneration/Materials/terrain_material.tres")
var mesh_material_grass = preload("res://ProceduralGeneration/Materials/second_texture/TerrainMaterialGrass.tres")
var max_height: float = 50
@export var falloff_enabled: bool

var task_id = -1
@export var noise: FastNoiseLite
@export var elevation_curve: Curve

var falloff_image: Image

@onready var number_generator: RandomNumberGenerator = RandomNumberGenerator.new()
var spawnable_objects : Array[Spawnable]

func _ready():
	get_spawnables()
	
	plane_mesh.material = mesh_material
	var falloff_texture = preload("res://ProceduralGeneration/Materials/second_texture/TerrainFalloff.png")
	falloff_image = falloff_texture.get_image()
	Signals.connect("generate_terrain_via_ui", _on_ui_generate_generate_terrain_via_ui)
	Signals.connect("change_material_of_the_mesh_signal", change_material)
	generate()
	number_generator.seed = randi()

func generate():
	
	#start()

	#plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size_width, size_depth)
	plane_mesh.subdivide_depth = size_depth*mesh_res
	plane_mesh.subdivide_width = size_width*mesh_res
	
	#var normal_map = mesh_material.get("shader_parameter/normal_map")
	#print(normal_map)
	#mesh_material.set("shader_parameter/normal_map/noise", noise)

	
	#plane_mesh.material = mesh_material
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

func get_spawnables():
	for i in get_children():
		if i is Spawnable:
			spawnable_objects.append(i)

func get_random_position_on_terrain():
	var x = number_generator.randf_range(-size_width/2, size_width/2)
	var z = number_generator.randf_range(-size_depth/2, size_depth/2)
	var y = get_noise_y(x, z)
	return Vector3(x, y, z)

func change_material():
	if (plane_mesh.material == mesh_material):
		plane_mesh.material = mesh_material_grass
		mesh.set_surface_override_material(0, mesh_material_grass )
	else:
		plane_mesh.material = mesh_material
		mesh.set_surface_override_material(0, mesh_material)


func get_noise_y(x, z)->float:
	var value = noise.get_noise_2d(x, z)
	var remapped_value = (value+1)/2
	var adjusted_value = elevation_curve.sample(remapped_value)
	adjusted_value = (adjusted_value*2)-1
	
	var falloff_value_impact_x = (x+(size_width/2))/size_width
	var falloff_value_impact_z = (z+(size_depth/2))/size_depth
	
	var fallof_pixel_x = int(falloff_value_impact_x*falloff_image.get_width())
	var fallof_pixel_z = int(falloff_value_impact_z*falloff_image.get_height())
	var falloff
	falloff = falloff_image.get_pixel(fallof_pixel_x, fallof_pixel_z).r

	if (falloff_enabled):
		return adjusted_value*max_height*falloff
	else :
		return adjusted_value*max_height


func _on_ui_generate_generate_terrain_via_ui():
	
	for n in self.get_children():
		if not n is  Spawnable:
			self.remove_child(n)
			n.queue_free()
	
	
	await generate()
	
	Signals.emit_signal("toggle_load_screen", false)
